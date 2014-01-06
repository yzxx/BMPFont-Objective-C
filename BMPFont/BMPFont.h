//
//  BMPFont.h
//  BMPFont
//
//  Created by zhanglei on 14-1-4.
//  Copyright (c) 2014年 zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMPFont : NSObject

+ (instancetype) bmpFontFromBinFile:(NSString *)fileName;

- (int) fontHeight;
- (bool) unicodeToBmpFont:(wchar_t)unicodeChar bmpFontBuffer:(uint8_t *)buffer bmpFontBufferLen:(int *)bufferLen bmpFontWidth:(int *)width;

@end
