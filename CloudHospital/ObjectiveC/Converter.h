//
//  Converter.h
//  CloudHospital
//
//  Created by wangankui on 30/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#import <Foundation/Foundation.h>

struct Converter {
    NSString * (*path)(NSString *name);
    NSData * (*data_file)(NSString *path);
    NSData * (data_utf8_file)(NSString *data);
    NSString * (*data_to_string)(NSData *data);
    NSData * (*string_to_data)(NSString *string);
    
    NSData * (*data_shift)(NSData *, NSInteger shift);
    NSData * (*data_add_random)(NSData *data);
    NSData * (*data_remove_random)(NSData *data);
    NSData * (*data_common_encrypt)(NSString *key, NSData *data);
    NSData * (*data_common_decrypt)(NSString *key, NSData *data);
    
    NSData * (*data_base64_encode)(NSData *data);
    NSData * (*data_base64_decode)(NSData *data);
    
    NSData * (*data_aes_encrypt)(NSString *key, NSData *data);
    NSData * (*data_aes_decrypt)(NSString *key, NSData *data);
    
    NSData * (*data_rsa_public_encrypt)(NSData *data);
    NSData * (*data_rsa_private_sign)(NSData *data);
    
    NSString * (*rsa_public_encrypt)(NSString *string);
    NSString * (*rsa_private_sign)(NSString *string);
    NSString * (*device_token)(void);
};

extern struct Converter Converter;



#define NSData_RSA_Private_Sign(data) Converter.data_rsa_private_sign(data)




