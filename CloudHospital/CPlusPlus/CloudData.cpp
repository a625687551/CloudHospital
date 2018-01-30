//
//  CloudData.cpp
//  CloudHospital
//
//  Created by wangankui on 26/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

#include "CloudData.hpp"
#include "utf8/checked.h"
#include <string>
//#include "evp.h"
//#include "buffer.h"

CloudData::CloudData() {
    this->m_data = nullptr;
    this->m_len = 0;
}

CloudData::CloudData(const CloudData &other) {
    this->m_data = nullptr;
    this->m_len = 0;
    
    reset(other.bytes(), other.length());
}

CloudData::CloudData(const void *data, size_t len, bool transfer_memory) {
    this->m_data = nullptr;
    this->m_len = 0;
    
    if (transfer_memory) {
        this->m_data = (void *)data;
        this->m_len = len;
    } else {
        reset(data, len);
    }
}

CloudData::~CloudData() {
    if (m_data) {
        free(m_data);
    }
    m_data = nullptr;
    m_len = 0;
}


CloudData & CloudData::operator=(const CloudData &other) {
    if (this != &other) {
        reset(other.bytes(), other.length());
    }
    return *this;
}

CloudData CloudData::operator+(const CloudData &other) const {
    if (other.empty()) {
        return *this;
    }
    
    size_t len = this->length() + other.length();
    
    void *buf = malloc(len);
    memcpy(buf, this->bytes(), this->length());
    memcpy((char *)buf + this->length(), other.bytes(), other.length());
    
    return CloudData(buf, len, true);
}

bool CloudData::operator==(const CloudData &other) const {
    if (this->bytes() == nullptr && other.bytes() == nullptr) {
        return true;
    }
    
    if (this->bytes() == nullptr || other.bytes() == nullptr) {
        return  false;
    }
    
    if (this->length() != other.length()) {
        return false;
    }
    
    return memcmp(this->bytes(), other.bytes(), this->length()) == 0;
}

const void * CloudData::bytes() const {
    return m_data;
}

size_t CloudData::length() const {
    return m_len;
}

bool CloudData::empty() const {
    return m_len <= 0 || !m_data;
}

void CloudData::reset(const void *data, size_t len) {
    void *memory = this->m_data;
    this->m_data = nullptr;
    this->m_len = 0;
    
    if (data && len > 0) {
        this->m_data = malloc(len);
        this->m_len = len;
        memcpy(this->m_data, data, len);
    }
    
    if (memory) {
        free(memory);
    }
}



CloudData impl_data_file(const char *path) {
    FILE *file = fopen(path, "r");
    if (!file) {
        return CloudData();
    }
    
    fseek(file, 0, SEEK_END);
    long len = ftell(file);
    void *buf = malloc(len);
    
    rewind(file);
    fread(buf, 1, len, file);
    fclose(file);
    
    return CloudData(buf, len, true);
}

CloudData impl_data_utf8(const CloudData &data) {
    std::string text = std::string((char *)data.bytes(), data.length());
    if (utf8::is_valid(text.begin(), text.end())) {
        return data;
    }
    
    return CloudData();
}

//CloudData impl_data_base64_encode(const CloudData &data) {
//    CloudData result;
//    if (data.empty()) {
//        return data;
//    }
//    
////    BIO *b64 = BIO_new(BIO_f_base64());
//}



CloudData impl_data_shift(const CloudData &data, long shift) {
    if (data.empty()) {
        return data;
    }
    
    const size_t len = data.length();
    unsigned char *buf = (unsigned char *)malloc(len);
    for (int i = 0; i < len; ++i) {
        unsigned char c = ((unsigned char *)data.bytes())[i] + shift;
        buf[i] = c;
    }
    
    return CloudData(buf, len, true);
}

CloudData impl_data_add_random(const CloudData &data) {
    if (data.empty()) {
        return data;
    }
    
    const int randomMax = '~' - '!';
    const size_t len = data.length() * 2;
    void *buf = malloc(len);
    srand((unsigned)time(nullptr));
    for (int i = 0; i < len / 2; ++i) {
        ((unsigned char *)buf)[i * 2] = ((unsigned char *)data.bytes())[i];
        ((unsigned char *)buf)[i * 2 + 1] = random() % randomMax + '!';
    }
    
    return CloudData(buf, len, true);
}

CloudData impl_data_remove_random(const CloudData &data) {
    if (data.empty()) {
        return data;
    }
    
    const size_t len = (data.length() + 1) / 2;
    void *buf = malloc(len);
    for (int i = 0; i < len; ++i) {
        ((char *)buf)[i] = ((char *)data.bytes())[i * 2];
    }
    
    return CloudData(buf, len, true);
}






CloudDataHelper DataHelper;

__attribute__((constructor)) static void impl_data_init() {
    DataHelper.data_file = impl_data_file;
}
















