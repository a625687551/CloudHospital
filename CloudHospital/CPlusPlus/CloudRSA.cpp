//
//  CloudRSA.cpp
//  CloudHospital
//
//  Created by wangankui on 26/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#include "CloudRSA.hpp"
#include <assert.h>

CloudRSA::CloudRSA() {
    
}

CloudRSA::~CloudRSA() {
    
}

void CloudRSA::setPair(const CloudRSAKeyPair &pair) {
    key_pair = pair;
}

CloudData CloudRSA::publicEncrypt(const CloudData &data, int padding) const {
    assert(key_pair.publicKey());
    
    return RSAEncryptImpl(data, true, padding);
}

CloudData CloudRSA::publicDecrypt(const CloudData &data, int padding) const {
    assert(key_pair.publicKey());
    
    return RSADecryptImpl(data, true, padding);
}

bool CloudRSA::publicVerify(const CloudData &data, const CloudData &sign, int type) const {
    assert(key_pair.publicKey());
    
    RSA *rsa = key_pair.publicKey();
    unsigned char digest[SHA_DIGEST_LENGTH] = {'\0'};
    SHA1((const unsigned char *)data.bytes(), data.length(), digest);
    
    unsigned int m_length = (unsigned int)sizeof(digest);
    const unsigned char *sigbuf = (const unsigned char *)sign.bytes();
    int ret = RSA_verify(type, digest, m_length, sigbuf, (unsigned int)sign.length(), rsa);
    return (ret == 1);
}

CloudData CloudRSA::privateEncrypt(const CloudData &data, int padding) const {
    assert(key_pair.privateKey());
    
    return RSAEncryptImpl(data, false, padding);
}

CloudData CloudRSA::privateDecrypt(const CloudData &data, int padding) const {
    assert(key_pair.privateKey());
    
    return RSADecryptImpl(data, false, padding);
}

CloudData CloudRSA::privateSign(const CloudData &data, int type) const {
    assert(key_pair.privateKey());
    
    RSA *rsa = key_pair.privateKey();
    void *buf = malloc(RSA_size(rsa));
    unsigned char digest[SHA_DIGEST_LENGTH] = {'\0'};
    
    SHA1((const unsigned char *)data.bytes(), data.length(), digest);
    unsigned int len = 0;
    
    CloudData result;
    if (1 == RSA_sign(type, digest, (unsigned int)sizeof(digest), (unsigned char *)buf, &len, rsa)) {
        result = CloudData(buf, len);
    }
    
    free(buf);
    
    return result;
}


CloudData CloudRSA::RSAEncryptImpl(const CloudData &data, bool is_public, int padding) const {
    RSA *rsa = is_public ? key_pair.publicKey() : key_pair.privateKey();
    const int rsaSize = RSA_size(rsa);
    const int bufSize = rsaSize + 1;
    
    void *fromBuf = malloc(bufSize);
    bzero(fromBuf, bufSize);
    memcpy(fromBuf, data.bytes(), data.length());
    
    void *toBuf = malloc(bufSize);
    bzero(toBuf, bufSize);
    int flen = this->getFlen(rsaSize, padding);
    int len = -1;
    if (is_public) {
        len = RSA_public_encrypt(flen, (unsigned char *)fromBuf, (unsigned char *)toBuf, rsa, padding);
    } else {
        len = RSA_private_encrypt(flen, (unsigned char *)fromBuf, (unsigned char *)toBuf, rsa, padding);
    }
    
    CloudData result;
    if (len >= 0) {
        result = CloudData(toBuf, len);
    }
    
    free(toBuf);
    free(fromBuf);
    
    return result;
}

CloudData CloudRSA::RSADecryptImpl(const CloudData &data, bool is_public, int padding) const {
    CloudData result;
    
    const int flen = (int)data.length();
    if (flen == 0) {
        return result;
    }
    
    RSA *rsa = is_public ? key_pair.publicKey() : key_pair.privateKey();
    void *buf = malloc(flen);
    int len = -1;
    if (is_public) {
        len = RSA_public_decrypt(flen, (unsigned char *)data.bytes(), (unsigned char *)buf, rsa, padding);
    } else {
        len = RSA_private_decrypt(flen, (unsigned char *)data.bytes(), (unsigned char *)buf, rsa, padding);
    }
    
    if (len >= 0) {
        result = CloudData((const char *)buf, strlen((const char *)buf));
    }
    
    free(buf);
    
    return result;
}

int CloudRSA::getFlen(int rsa_size, int padding) const {
    int result = rsa_size;
    switch (padding) {
        case RSA_PKCS1_PADDING:
        case RSA_SSLV23_PADDING: {
            result -= 11;
            break;
        }
        case RSA_X931_PADDING: {
            result -= 2;
            break;
        }
        case RSA_NO_PADDING: {
            break;
        }
        case RSA_PKCS1_OAEP_PADDING: {
            result = result - 2 * SHA_DIGEST_LENGTH - 2;
            break;
        }
        default: {
            result = -1;
            break;
        }
    }
    return result;
}


static CloudRSA impl_rsa_create(const CloudData &public_data, const CloudData &private_data) {
    CloudRSA rsa;
    rsa.setPair(RSAKeyPairHelper.rsa_keypair_create(public_data, private_data));
    return rsa;
}



CloudRSAHelper RSAHelper;

__attribute__((constructor)) static void impl_rsa_init() {
    RSAHelper.rsa_create = impl_rsa_create;
}


