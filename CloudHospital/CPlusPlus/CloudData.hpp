//
//  CloudData.hpp
//  CloudHospital
//
//  Created by wangankui on 26/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#ifndef CloudData_hpp
#define CloudData_hpp

#include <stdio.h>

class CloudData {
private:
    void *m_data;
    size_t m_len;
    
public:
    CloudData();
    CloudData(const CloudData &other);
    CloudData(const void *data, size_t len, bool transfer_memory = false);
    ~CloudData();
    
    CloudData & operator=(const CloudData &other);
    CloudData operator+(const CloudData &other) const;
    bool operator==(const CloudData &other) const;
    
    const void * bytes() const;
    size_t length() const;
    bool empty() const;
    
private:
    void reset(const void *data, size_t len);
};


struct CloudDataHelper {
    CloudData (*data_file)(const char *path);
    CloudData (*data_utf8)(const CloudData &data);
    
    CloudData (*data_base64_encode)(const CloudData &data);
    CloudData (*data_base64_decode)(const CloudData &data);
    
    CloudData (*data_shift)(const CloudData &data, long shift);
    CloudData (*data_add_random)(const CloudData &data);
    CloudData (*data_remove_random)(const CloudData &data);
};

extern struct CloudDataHelper DataHelper;

#endif /* CloudData_hpp */
