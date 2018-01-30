//
//  CloudRSA.hpp
//  CloudHospital
//
//  Created by wangankui on 26/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#ifndef CloudRSA_hpp
#define CloudRSA_hpp

#include <stdio.h>
#include <string>
#include "CloudRSAKeyPair.hpp"

class CloudRSA {
    
private:
    CloudRSAKeyPair key_pair;
    
public:
    CloudRSA();
    ~CloudRSA();
    
    void setPair(const CloudRSAKeyPair &pair);
    
    CloudData publicEncrypt(const CloudData &data, int padding = RSA_PKCS1_PADDING) const;
    CloudData publicDecrypt(const CloudData &data, int padding = RSA_PKCS1_PADDING) const;
    bool publicVerify(const CloudData &data, const CloudData &sign, int type = NID_sha1) const;
    
    CloudData privateEncrypt(const CloudData &data, int padding = RSA_PKCS1_PADDING) const;
    CloudData privateDecrypt(const CloudData &data, int padding = RSA_PKCS1_PADDING) const;
    CloudData privateSign(const CloudData &data, int type = NID_sha1) const;

private:
    CloudData RSAEncryptImpl(const CloudData &data, bool is_public, int padding) const;
    CloudData RSADecryptImpl(const CloudData &data, bool is_public, int padding) const;
    int getFlen(int rsa_size, int padding) const;
};

struct CloudRSAHelper {
    CloudRSA (*rsa_create)(const CloudData &public_key, const CloudData &private_key);
};

extern struct CloudRSAHelper RSAHelper;

#endif /* CloudRSA_hpp */
