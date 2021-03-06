//
//  CloudRSAKeyPair.cpp
//  CloudHospital
//
//  Created by wangankui on 30/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#include "CloudRSAKeyPair.hpp"
#include <string>
#include <assert.h>

CloudRSAKeyPair::CloudRSAKeyPair() {
    public_rsa = nullptr;
    private_rsa = nullptr;
}

CloudRSAKeyPair::CloudRSAKeyPair(const CloudRSAKeyPair &other) {
    public_rsa = nullptr;
    private_rsa = nullptr;
    
    resetKeys(other.public_rsa, other.private_rsa);
}

CloudRSAKeyPair::~CloudRSAKeyPair() {
    resetKeys(nullptr, nullptr);
}

CloudRSAKeyPair & CloudRSAKeyPair::operator=(const CloudRSAKeyPair &other) {
    if (this != &other) {
        resetKeys(other.public_rsa, other.private_rsa);
    }
    return *this;
}

RSA * CloudRSAKeyPair::publicKey() const {
    return public_rsa;
}

RSA * CloudRSAKeyPair::privateKey() const {
    return private_rsa;
}

void CloudRSAKeyPair::resetKey(int key_size) {
    resetKeys(nullptr, nullptr);
    
    if (key_size <= 0) {
        return;
    }
    
    RSA *rsa = RSA_generate_key(key_size, RSA_F4, NULL, NULL);
    assert(rsa);
    
    public_rsa = RSAPublicKey_dup(rsa);
    assert(public_rsa);
    
    private_rsa = RSAPrivateKey_dup(rsa);
    assert(private_rsa);
    
    RSA_free(rsa);
}

void CloudRSAKeyPair::resetKey(const CloudData &data, bool is_public) {
    if (is_public) {
        if (public_rsa) {
            RSA_free(public_rsa);
        }
        public_rsa = nullptr;
        
    } else {
        if (private_rsa) {
            RSA_free(privateKey());
        }
        private_rsa = nullptr;
    }
    
    const size_t len = data.length();
    if (len <= 0) {
        return;
    }
    
    const char *head = is_public ? "-----BEGIN PUBLIC KEY-----\n" : "-----BEGIN PRIVATE KEY-----\n";
    const char *tail = is_public ? "\n-----END PUBLIC KEY-----\n" : "\n-----END PRIVATE KEY-----";
    const size_t head_len = strlen(head);
    const size_t tail_len = strlen(tail);
    const size_t buf_len = len + head_len + tail_len + 100;
    
    unsigned char *buf = (unsigned char *)malloc(buf_len);
    memcpy(buf, head, head_len);
    size_t key_len = head_len;
    size_t data_count_64 = 0;
    
    for (size_t idx = 0; idx < len; ++idx) {
        char c = ((char *)data.bytes())[idx];
        if (c == '\0' || c == '\n' || c == '\r') {
            continue;
        }
        buf[key_len] = c;
        ++key_len;
        ++data_count_64;
        if (data_count_64 % 64 == 0) {
            buf[key_len] = '\n';
            ++key_len;
        }
    }
    
    memcpy(buf + key_len, tail, tail_len);
    key_len += tail_len;
    
    BIO *bio = BIO_new_mem_buf(buf, (int)key_len);
    assert(bio);
    if (is_public) {
        public_rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);
        assert(public_rsa);
    } else {
        private_rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);
        assert(private_rsa);
    }
    
    BIO_free_all(bio);
    free(buf);
}

void CloudRSAKeyPair::resetKeys(RSA *public_key, RSA *private_key) {
    RSA *rsa = public_rsa;
    public_rsa = public_key;
    if (public_rsa) {
        RSA_up_ref(public_rsa);
    }
    RSA_free(rsa);
    
    rsa = private_rsa;
    private_rsa = private_key;
    if (private_rsa) {
        RSA_up_ref(private_rsa);
    }
    RSA_free(rsa);
}


static CloudRSAKeyPair impl_rsa_keypair_create(const CloudData &public_data, const CloudData &private_data) {
    CloudRSAKeyPair pair;
    pair.resetKey(public_data, true);
    pair.resetKey(private_data, false);
    return pair;
}


CloudRSAKeyPairHelper RSAKeyPairHelper;

__attribute__((constructor)) static void impl_rsa_keypair_init() {
    RSAKeyPairHelper.rsa_keypair_create = impl_rsa_keypair_create;
}

