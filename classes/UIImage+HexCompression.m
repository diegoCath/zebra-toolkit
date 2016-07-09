//
//  UIImage+HexCompression.m
//
//  Created by Diego Cathalifaud on 7/30/15.
//  Copyright (c) 2015 Diego Cathalifaud. All rights reserved.
//

#import "UIImage+HexCompression.h"

@implementation UIImage (HexCompression)

- (NSString*)compressedHexRepresentation {
    
    // NOTE(diego_cath): this block is used to convert a string that represents a 4-bit binary number into a single hexadecimal digit
    
    NSString* (^hexForByte)(NSString*) = ^NSString*(NSString *binary) {
        
        if([binary isEqualToString:@"0000"]) {
            return @"0";
        }
        if([binary isEqualToString:@"0001"]) {
            return @"1";
        }
        if([binary isEqualToString:@"0010"]) {
            return @"2";
        }
        if([binary isEqualToString:@"0011"]) {
            return @"3";
        }
        if([binary isEqualToString:@"0100"]) {
            return @"4";
        }
        if([binary isEqualToString:@"0101"]) {
            return @"5";
        }
        if([binary isEqualToString:@"0110"]) {
            return @"6";
        }
        if([binary isEqualToString:@"0111"]) {
            return @"7";
        }
        if([binary isEqualToString:@"1000"]) {
            return @"8";
        }
        if([binary isEqualToString:@"1001"]) {
            return @"9";
        }
        if([binary isEqualToString:@"1010"]) {
            return @"A";
        }
        if([binary isEqualToString:@"1011"]) {
            return @"B";
        }
        if([binary isEqualToString:@"1100"]) {
            return @"C";
        }
        if([binary isEqualToString:@"1101"]) {
            return @"D";
        }
        if([binary isEqualToString:@"1110"]) {
            return @"E";
        }
        if([binary isEqualToString:@"1111"]) {
            return @"F";
        }
        return @"0";
    };
    
    NSDictionary *countRepresentationCharacters = @{
                                                    @(1) : @('G'), @(2) : @('H'), @(3) : @('I'), @(4) : @('J'), @(5) : @('K'), @(6) : @('L'), @(7) : @('M'), @(8) : @('N'), @(9) : @('O'), @(10) : @('P'), @(11) : @('Q'), @(12) : @('R'), @(13) : @('S'), @(14) : @('T'), @(15) : @('U'), @(16) : @('V'), @(17) : @('W'), @(18) : @('X'), @(19) : @('Y'),
                                                    @(20) : @('g'), @(40) : @('h'), @(60) : @('i'), @(80) : @('j'), @(100) : @('k'), @(120) : @('l'), @(140) : @('m'), @(160) : @('n'), @(180) : @('o'), @(200) : @('p'), @(220) : @('q'), @(240) : @('r'), @(260) : @('s'), @(280) : @('t'), @(300) : @('u'), @(320) : @('v'), @(340) : @('w'), @(360) : @('x'), @(380) : @('y'), @(400) : @('z')};
    
    // NOTE(diego_cath): this block is used to convert a number into its ascii-hex compresion counterpart
    
    __block NSString* (^getCountRepresentation)(int) = ^NSString* (int count) {
        
        if(count > 400) {
            return [NSString stringWithFormat:@"%c%@", [countRepresentationCharacters[@(400)] charValue], getCountRepresentation(count - 400)];
        }
        if(count > 20 && count % 20 != 0) {
            
            int n20 = count/20;
            return [NSString stringWithFormat:@"%c%@", [countRepresentationCharacters[@(n20*20)] charValue], getCountRepresentation(count - n20*20)];
        }
        
        return [NSString stringWithFormat:@"%c", [countRepresentationCharacters[@(count)] charValue]];
    };
    
    // NOTE(diego_cath): this block is used to compress a hex number (represented as a string) using the ascii-hex compression format
    
    NSString* (^processLine)(NSString*) = ^NSString* (NSString *line) {
        NSMutableString *retVal = [[NSMutableString alloc] init];
        
        int index = 0;
        
        while(index < line.length) {
            char currentChar = [line characterAtIndex:index];
            int count = 0;
            while(index + count < line.length && [line characterAtIndex:index + count] == currentChar) {
                count++;
            }
            
            if(count == 1) {
                [retVal appendFormat:@"%c", currentChar];
            }
            else if(currentChar == '0' && index + count == line.length) {
                [retVal appendString:@","];
            }
            else {
                [retVal appendFormat:@"%@%c", getCountRepresentation(count), currentChar];
            }
            
            index += count;
        }
        
        return retVal;
    };
    
    // NOTE(diego_cath): here we take the input image and obtain a pixel representation of it
    
    NSString *currentHex = @"";
    NSString *currentLine = @"";
    NSString *prevLine;
    NSString *currentByte = @"";
    
    int x = 0, y = 0, count = image.size.width * image.size.height;
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    //NOTE(diego_cath): here we iterate through all pixels of the image, we transform pixels into bits, group bits into hex digits, group hex digits in a string and then compress the string.
    
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0 ; i < count ; ++i) {
        CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
        CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
        CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
        CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
        byteIndex += bytesPerPixel;
        
        int avg = (red + green + blue) / 3;
        
        if(avg > 100 || alpha < .1) {
            currentByte = [currentByte stringByAppendingString:@"0"];
        }
        else {
            currentByte = [currentByte stringByAppendingString:@"1"];
        }
        
        if(currentByte.length == 4) {
            currentLine = [currentLine stringByAppendingString:hexForByte(currentByte)];
            currentByte = @"";
        }
        if(currentLine.length*4 == width) {
            
            currentLine = processLine(currentLine);
            if([currentLine isEqualToString:prevLine]) {
                currentLine = @":";     //NOTE(diego_cath): in ascii-hex compression format, a colon is replaced by the previous line.
            }
            else {
                prevLine = currentLine;
            }
            
            currentHex = [currentHex stringByAppendingString:currentLine];
            currentLine = @"";
        }
    }
    
    free(rawData);
    
    return currentHex;
}

@end
