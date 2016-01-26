//
//  ZPLHelper.m
//  BasicServices
//
//  Created by Diego Cathalifaud on 1/25/16.
//  Copyright (c) 2016 Diego Cathalifaud. All rights reserved.
//

#import "DCZPLHelper.h"

@interface DCZPLHelper ()

@property(nonatomic) int width;
@property(nonatomic, strong) NSMutableString *commands;
@property(nonatomic) int cursorX;
@property(nonatomic) int cursorY;

@end

@implementation DCZPLHelper

- (id)initWithLabelWidth:(int)labelWidth labelLength:(int)labelLength {
    
    if(self = [super init]) {
        self.commands = [[NSMutableString alloc] init];
        
        self.width = labelWidth;
        [self.commands appendString:[NSString stringWithFormat:@"^XA^POI^PW%d^MNN^LL%d^LH0,0^CI28", self.width, length]];
    }
}

- (void)moveCursorByX:(int)dx y:(int)dy {
    
    [self moveCursorToX:self.cursorX + dx y:self.cursorY + dy];
}

- (void)moveCursorToX:(int)x y:(int)y {
    
    self.cursorX = x;
    self.cursorY = y;
    
    [self.commands appendString:[NSString stringWithFormat:@"^FO%d,%d", x, y]];
}

- (void)drawImageWithDataString:(NSString*)dataStr byteCount:(int)bytes bytesPerRow:(int)bpr {
    
    /*  command used:
            - ^GFa,b,c,d,data
                a = compression type
                b = binary byte count
                c = graphic field count
                d = bytes per row
                data = data
     */
    
    [self.commands appendString:[NSString stringWithFormat:@"^GFA,%d,%d,%d,%@^FS", bytes, bytes, bpr, dataStr]];
}

- (void)drawHorizontalLineWithThickness:(int)e {
    
    [self.commands appendString:[NSString stringWithFormat:@"^GB%d,%d,%d^FS", self.width, e, e]];
}

- (void)addWrappingText:(NSString*)text withFontHeight:(int)h {
    
    [self.commands appendString:[NSString stringWithFormat:@"^A0N,%d,%d", h, h]];
    [self.commands appendString:[NSString stringWithFormat:@"^FB%d,10,,^FD%@^FS", self.width - 20, text]];
}

- (void)addTextBox:(NSString*)text withBoxWidth:(int)w fontHeight:(int)h {
    
    [self.commands appendString:[NSString stringWithFormat:@"^A0N,%d,%d", h, h]];
    [self.commands appendString:[NSString stringWithFormat:@"^TBN,%d,%d", w, h-1]];
    [self.commands appendString:[NSString stringWithFormat:@"^FD%@^FS", text]];
}

- (void)addText:(NSString*)text withFontHeight:(int)h {
    
    [self.commands appendString:[NSString stringWithFormat:@"^A0N,%d,%d", h, h]];
    [self.commands appendString:[NSString stringWithFormat:@"^FD%@^FS", text]];
}

- (void)addPDF417BarcodeWithString:(NSString*)str {
    
    /* commands used:
            - ^BYw,r,h
                w = module width (in dots)
                r = wide bar to narrow bar width ratio (optional)
                h = bar code height (in dots)
            - ^B7o,h,s,c,r,t
                o = orientation
                h = bar code height for individual rows (in dots)
                s = security level
                c = number of data columns to encode
                r = number of rows to encode
                t = truncate right row indicators and stop pattern
     */
    
    // if barcode is not printed, it can be because the number of rows/columns is too small
    // @TODO(diego): add parameters of ^BY and ^B7 as method parameters
    [self.commands appendString:[NSString stringWithFormat:@"^BY3,3^B7N,5,5,7,20,N^FD%@^FS", str]];
}

- (void)addCustomCommand:(NSString*)command {
    [self.commands appendString:command];
}

- (NSString*)finish {
    [self.commands appendString:@"^XZ"];
    return self.commands;
}

- (NSString*)getCommands {
    return self.commands;
}

@end
