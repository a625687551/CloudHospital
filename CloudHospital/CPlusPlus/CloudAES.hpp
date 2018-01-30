//
//  CloudAES.hpp
//  CloudHospital
//
//  Created by wangankui on 26/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#ifndef CloudAES_hpp
#define CloudAES_hpp

#include <stdio.h>
#include "CloudData.hpp"

class CloudAES {
    
private:
    CloudData aes_iv;
    CloudData aes_key;
    
public:
    CloudAES();
    ~CloudAES();
    
    void setSecret(const CloudData &data);
    CloudData AESEncrypt(const CloudData &data) const;
    CloudData AESDecrypt(const CloudData &data) const;
    
private:
    CloudData cryptImpl(const CloudData &data, bool encrypt) const;
};


struct CloudAESHelper {
    CloudData (*aes_encrypt)(const CloudData &key, const CloudData &data);
    CloudData (*aes_decrypt)(const CloudData &key, const CloudData &data);
};

extern CloudAESHelper AESHelper;

#endif /* CloudAES_hpp */
