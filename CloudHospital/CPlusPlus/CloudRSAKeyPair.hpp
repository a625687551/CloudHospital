//
//  CloudRSAKeyPair.hpp
//  CloudHospital
//
//  Created by wangankui on 30/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#ifndef CloudRSAKeyPair_hpp
#define CloudRSAKeyPair_hpp

#include <stdio.h>
#include "CloudData.hpp"
#include <openssl/pem.h>

class CloudRSAKeyPair {
    
private:
    RSA *public_rsa;
    RSA *private_rsa;
    
public:
    CloudRSAKeyPair();
    CloudRSAKeyPair(const CloudRSAKeyPair &other);
    ~CloudRSAKeyPair();
    
    CloudRSAKeyPair &operator=(const CloudRSAKeyPair &other);
    
    RSA * publicKey() const;
    RSA * privateKey() const;
    
    void resetKey(int key_size);
    void resetKey(const CloudData &data, bool is_public);
    
private:
    void resetKeys(RSA *public_key, RSA *private_key);
};


struct CloudRSAKeyPairHelper {
    CloudRSAKeyPair (*rsa_keypair_create)(const CloudData &public_data, const CloudData &private_data);
};

extern struct CloudRSAKeyPairHelper RSAKeyPairHelper;

#define Cloud_RSA_KeyPair(public_data, private_data) RSAKeyPairHelper.rsa_keypair_create(public_data, private_data)

#endif /* CloudRSAKeyPair_hpp */
