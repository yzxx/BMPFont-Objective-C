//
//  BMPFont.m
//  BMPFont
//
//  Created by zhanglei on 14-1-4.
//  Copyright (c) 2014年 zhanglei. All rights reserved.
//

#import "BMPFont.h"

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

@implementation BMPFont
{
    NSFileHandle *binFile;
    binFileSection *sections;
    binFileHead head;
}

+ (instancetype) bmpFontFromBinFile:(NSString *)fileName;
{
    BMPFont *bmpFont = [BMPFont new];
    
    bmpFont->binFile = [NSFileHandle fileHandleForReadingAtPath:fileName];
    if(!bmpFont->binFile)
        return nil;
    
    NSData *data = [bmpFont->binFile readDataToEndOfFile];
    
    binFileHead head;
    [data getBytes:&head length:sizeof(binFileHead)];
    bmpFont->head = head;
    
    if(!head.sectionNum)
        return nil;
    
    bmpFont->sections = malloc(sizeof(binFileSection)*head.sectionNum);
    if(!bmpFont->sections)
        return nil;
    
    int read = sizeof(binFileHead);
    for (int i = 0; i < head.sectionNum; i++)
    {
        [data getBytes:&(bmpFont->sections+i)->firstChar range:NSMakeRange(read+0, 2)];
        [data getBytes:&(bmpFont->sections+i)->lastChar range:NSMakeRange(read+2, 2)];
        [data getBytes:&(bmpFont->sections+i)->firstAddr range:NSMakeRange(read+4, 4)];

        read += 8;
    }
    
    return bmpFont;
}

- (void)dealloc
{
    if(sections)
        free(sections);
}

- (int) fontHeight
{
    return head.fontHeight;
}

- (bool)unicodeToBmpFont:(wchar_t)unicodeChar bmpFontBuffer:(uint8_t *)buffer bmpFontBufferLen:(int *)bufferLen
           bmpFontWidth:(int *)width
{
    int section = -1;
    
    for(int i = 0; i < head.sectionNum; i++)
    {
        if(unicodeChar >= (sections+i)->firstChar && unicodeChar <= (wchar_t)(sections+i)->lastChar)
        {
            section = i;
            break;
        }
    }
    
    if(section == -1)
        return false;
    
    int addr = (sections+section)->firstAddr+(unicodeChar-(sections+section)->firstChar)*sizeof(binFileCharInfo);
    
    [binFile seekToFileOffset:addr];
    NSData *data = [binFile readDataOfLength:sizeof(binFileCharInfo)];
    if(!data)
        return false;
    
    binFileCharInfo info;
    [data getBytes:&info length:sizeof(binFileCharInfo)];
    if(!info.offAddr)
        return false;
    
    *bufferLen = head.fontHeight*(info.fontWidth+7)/8;
    *width = info.fontWidth;
    
    [binFile seekToFileOffset:info.offAddr];
    data = [binFile readDataOfLength:*bufferLen];
    if(!data)
        return false;
    
    [data getBytes:buffer length:*bufferLen];
    
    return true;
}

@end
         
