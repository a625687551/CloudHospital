//
//  CloudConvert.m
//  CloudHospital
//
//  Created by wangankui on 31/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#import "CloudConvert.h"
#import "CloudData.hpp"
#import "CloudAES.hpp"
#import "CloudRSA.hpp"

#define CLOUD_AES_KEY              @"hsyuntai.com"
#define CLOUD_RSA_PUBLIC_KEY_NAME  @"publicKey.pem"
#define CLOUD_RSA_PRIVATE_KEY_NAME @"privateKey.pem"


static NSData * impl_gen_nsdata(const CloudData &data) {
    return [NSData dataWithBytes:data.bytes() length:data.length()];
}

static CloudData impl_gen_clouddata(NSData *data) {
    return CloudData(data.bytes, data.length);
}

static CloudRSA * impl_rsa_public_key() {
    static CloudRSA rsa;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = Convert.data_utf8_file(Convert.path(CLOUD_RSA_PUBLIC_KEY_NAME));
        rsa = RSAHelper.rsa_create(impl_gen_clouddata(data), CloudData());
    });
    return &rsa;
}

static CloudRSA * impl_rsa_private_key() {
    static CloudRSA rsa;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = Convert.data_utf8_file(Convert.path(CLOUD_RSA_PRIVATE_KEY_NAME));
        rsa = RSAHelper.rsa_create(CloudData(), impl_gen_clouddata(data));
    });
    return &rsa;
}





static NSString * impl_path(NSString *name) {
    return [[NSBundle mainBundle] pathForResource:name ofType:nil];
}

static NSData * impl_data_file(NSString *path) {
    if (!path) {
        return nil;
    }
    return impl_gen_nsdata(DataHelper.data_file(path.UTF8String));
}

static NSData * impl_data_utf8_file(NSString *path) {
    if (!path) {
        return nil;
    }
    CloudData data = DataHelper.data_file(path.UTF8String);
    CloudData out_data = impl_gen_clouddata(Convert.data_common_decrypt(CLOUD_AES_KEY, impl_gen_nsdata(data)));
    out_data = DataHelper.data_utf8(out_data);
    if (out_data.length()) {
        return impl_gen_nsdata(out_data);
    }
    return impl_gen_nsdata(data);
}

static NSString * impl_data_to_string(NSData *data) {
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

static NSData * impl_string_to_data(NSString *string) {
    if (!string) {
        return nil;
    }
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}




static NSData * impl_data_shift(NSData *data, NSInteger shift) {
    if (!data) {
        return nil;
    }
    return impl_gen_nsdata(DataHelper.data_shift(impl_gen_clouddata(data), shift));
}

static NSData * impl_data_add_random(NSData *data) {
    if (!data) {
        return nil;
    }
    return impl_gen_nsdata(DataHelper.data_add_random(impl_gen_clouddata(data)));
}

static NSData * impl_data_remove_random(NSData *data) {
    if (!data) {
        return nil;
    }
    return impl_gen_nsdata(DataHelper.data_remove_random(impl_gen_clouddata(data)));
}

static NSData * impl_data_common_encrypt(NSString *key, NSData *data) {
    if (!data) {
        return nil;
    }
    CloudData out_data = impl_gen_clouddata(data);
    out_data = AESHelper.aes_encrypt(CloudData(key.UTF8String, key.length), out_data);
    return impl_gen_nsdata(DataHelper.data_add_random(DataHelper.data_shift(out_data, 10)));
}

static NSData *impl_data_common_decrypt(NSString *key, NSData *data) {
    if (!data) {
        return nil;
    }
    CloudData out_data = impl_gen_clouddata(data);
    out_data = DataHelper.data_shift(DataHelper.data_remove_random(out_data), -10);
    out_data = AESHelper.aes_decrypt(CloudData(key.UTF8String, key.length), out_data);
    return impl_gen_nsdata(out_data);
}





static NSData * impl_data_base64_encode(NSData *data) {
    if (!data) {
        return nil;
    }
    return impl_gen_nsdata(DataHelper.data_base64_encode(impl_gen_clouddata(data)));
}

static NSData * impl_data_base64_decode(NSData *data) {
    if (!data) {
        return nil;
    }
    return impl_gen_nsdata(DataHelper.data_base64_decode(impl_gen_clouddata(data)));
}






static NSData * impl_data_aes_encrypt(NSString *key, NSData *data) {
    if (!key && !data) {
        return nil;
    }
    return impl_gen_nsdata(AESHelper.aes_encrypt(CloudData(key.UTF8String, key.length), impl_gen_clouddata(data)));
}

static NSData * impl_data_aes_decrypt(NSString *key, NSData *data) {
    if (!key && !data) {
        return nil;
    }
    return impl_gen_nsdata(AESHelper.aes_decrypt(CloudData(key.UTF8String, key.length), impl_gen_clouddata(data)));
}





static NSData * impl_data_rsa_public_encrypt(NSData *data) {
    if (!data) {
        return nil;
    }
    return impl_gen_nsdata(impl_rsa_public_key()->publicEncrypt(impl_gen_clouddata(data)));
}

static NSData * impl_data_rsa_private_sign(NSData *data) {
    if (!data) {
        return nil;
    }
    return impl_gen_nsdata(impl_rsa_private_key()->privateSign(impl_gen_clouddata(data)));
}




static NSString * impl_rsa_public_encrypt(NSString *string) {
    if (!string) {
        return nil;
    }
    return Convert.data_to_string(Convert.data_base64_encode(Convert.data_rsa_public_encrypt(Convert.string_to_data(string))));
}

static NSString * impl_rsa_private_sign(NSString *string) {
    if (!string) {
        return nil;
    }
    return Convert.data_to_string(Convert.data_base64_encode(Convert.data_rsa_private_sign(Convert.string_to_data(string))));
}

static NSString * impl_device_token() {
    return nil;
}






CloudConvert Convert;

__attribute__((constructor)) static void impl_convert_init() {
    Convert.path = impl_path;
    Convert.data_file = impl_data_file;
    Convert.data_utf8_file = impl_data_utf8_file;
    Convert.data_to_string = impl_data_to_string;
    Convert.string_to_data = impl_string_to_data;
    
    Convert.data_shift = impl_data_shift;
    Convert.data_add_random = impl_data_add_random;
    Convert.data_remove_random = impl_data_remove_random;
    Convert.data_common_encrypt = impl_data_common_encrypt;
    Convert.data_common_decrypt = impl_data_common_decrypt;
    
    Convert.data_base64_encode = impl_data_base64_encode;
    Convert.data_base64_decode = impl_data_base64_decode;
    
    Convert.data_aes_encrypt = impl_data_aes_encrypt;
    Convert.data_aes_decrypt = impl_data_aes_decrypt;
    
    Convert.data_rsa_public_encrypt = impl_data_rsa_public_encrypt;
    Convert.data_rsa_private_sign = impl_data_rsa_private_sign;
    
    Convert.rsa_public_encrypt = impl_rsa_public_encrypt;
    Convert.rsa_private_sign = impl_rsa_private_sign;
    Convert.device_token = impl_device_token;
}
