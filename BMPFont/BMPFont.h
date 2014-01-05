//
//  BMPFont.h
//  BMPFont
//
//  Created by zhanglei on 14-1-4.
//  Copyright (c) 2014年 zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    char fileHead[4];
    uint32_t fileSize;
    uint8_t sectionNum;
    uint8_t fontHeight;
    uint16_t flag;
    char reserve[4];
}binFileHead;

typedef struct
{
    uint32_t offAddr    : 26;
    uint32_t fontWidth  : 6;
}binFileCharInfo;

typedef struct
{
    uint16_t firstChar;
    uint16_t lastChar;
    uint32_t firstAddr;
}binFileSection;


@interface BMPFont : NSObject
{
    NSFileHandle *binFile;
    binFileSection *sections;
}

@property (nonatomic) binFileHead head;

+ (instancetype) bmpFontFromBinFile:(NSString *)fileName;

- (bool)unicodeToBmpFont:(wchar_t)unicodeChar bmpFontBuffer:(uint8_t *)buffer bmpFontBufferLen:(int *)bufferLen bmpFontWidth:(int *)width;

@end
