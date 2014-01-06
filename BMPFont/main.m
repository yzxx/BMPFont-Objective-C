//
//  main.m
//  BMPFont
//
//  Created by zhanglei on 14-1-4.
//  Copyright (c) 2014年 zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMPFont.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"arialuni_U16.bin"];
        
        BMPFont *bmpFont = [BMPFont bmpFontFromBinFile:path];
        if(!bmpFont)
        {
            NSLog(@"load bmpFont fail...");
            return -1;
        }
        
        wchar_t c = L'羽';
        //wchar_t c = 0x66f8;
        
        int fontHeight = [bmpFont fontHeight];
        
        uint8_t *buffer = malloc(fontHeight*fontHeight);
        int bufferSize, width;
        
        bool ret = [bmpFont unicodeToBmpFont:c bmpFontBuffer:buffer bmpFontBufferLen:&bufferSize bmpFontWidth:&width];
        if(!ret)
        {
            NSLog(@"convert fail...");
            return -1;
        }
        
        int bytePerLine = bufferSize/fontHeight;
        
        for(int i = 0; i < fontHeight; i++)
        {
            for(int j = 0; j < width; j++)
            {
                if((*((buffer+i*bytePerLine)+j/8)>>(7-j%8))&0x01)
                    printf("* ");
                else
                    printf("  ");
            }
            printf("\n");
        }
        
        
    }
    return 0;
}

