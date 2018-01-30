//
//  CloudAES.cpp
//  CloudHospital
//
//  Created by wangankui on 26/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#include "CloudAES.hpp"
#include <assert.h>
#include <CommonCrypto/CommonCrypto.h>

#define AES_KEY_LEN 32
#define AES_IV_LEN 16

CloudAES::CloudAES() {
    
}

CloudAES::~CloudAES() {
    
}

void CloudAES::setSecret(const CloudData &data) {
    if (data.empty()) {
        aes_iv = CloudData();
        aes_key = CloudData();
        return;
    }
    
    unsigned char *digest = (unsigned char *)malloc(CC_SHA384_DIGEST_LENGTH);
    CC_SHA384(data.bytes(), (CC_LONG)data.length(), (unsigned char *)digest);
    
    aes_key = CloudData(digest, AES_KEY_LEN);
    aes_iv = CloudData(digest + AES_IV_LEN, AES_KEY_LEN);
    
    free(digest);
}

CloudData CloudAES::AESEncrypt(const CloudData &data) const {
    assert(!aes_key.empty() && !aes_iv.empty());
    
    return cryptImpl(data, true);
}

CloudData CloudAES::AESDecrypt(const CloudData &data) const {
    assert(!aes_key.empty() && !aes_iv.empty());
    
    return cryptImpl(data, false);
}

CloudData CloudAES::cryptImpl(const CloudData &data, bool encrypt) const {
    if (data.empty()) {
        return data;
    }
    
    const size_t len = data.length();
    size_t bufferSize = len + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(encrypt ? kCCEncrypt : kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          aes_key.bytes(),
                                          AES_KEY_LEN,
                                          aes_iv.bytes(),
                                          data.bytes(),
                                          len,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    
    CloudData result;
    if (cryptStatus == kCCSuccess) {
        result = CloudData(buffer, encryptedSize);
    }
    
    free(buffer);
    
    return result;
}



static CloudData impl_aes_encrypt(const CloudData &key, const CloudData &data) {
    CloudAES aes;
    aes.setSecret(key);
    return aes.AESDecrypt(data);
}

static CloudData impl_aes_decrypt(const CloudData &key, const CloudData &data) {
    CloudAES aes;
    aes.setSecret(key);
    return aes.AESDecrypt(data);
}


CloudAESHelper AESHelper;

__attribute__((constructor)) static void impl_aes_init() {
    AESHelper.aes_encrypt = impl_aes_encrypt;
    AESHelper.aes_decrypt = impl_aes_decrypt;
}

