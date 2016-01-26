//
//  ZPLHelper.h
//  BasicServices
//
//  Created by Diego Cathalifaud on 1/25/16.
//  Copyright (c) 2016 Diego Cathalifaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCZPLHelper : NSObject

/*
    - initializes the label with the specified width and length. Writes a header of standard commands. Check the code if you want to customize
 */
- (id)initWithLabelWidth:(int)labelWidth labelLength:(int)labelLength;

/*
    - dx and dy is the distance you want to move the cursor by.
    - the cursor is the place you want your next command to be printed
 */
- (void)moveCursorByX:(int)dx y:(int)dy;

/*
    - x and y is the position you want to move the cursor to.
    - the cursor is the place you want your next command to be printed
 */
- (void)moveCursorToX:(int)x y:(int)y;

/*
    - draws an image at the cursor position
    - dataStr is the a string containing the image data in ASCII form. You can use http://labelary.com/viewer.html and click on "Add Image" to get this parameter. There you can also get the byteCount and bytesPerRow parameters.
 */
- (void)drawImageWithDataString:(NSString*)dataStr byteCount:(int)bytes bytesPerRow:(int)bpr;

/*
    - draws a horizontal line at the cursor position
 */
- (void)drawHorizontalLineWithThickness:(int)e;

/*
    - draws a paragraph of text at the cursor position
 */
- (void)addWrappingText:(NSString*)text withFontHeight:(int)h;

/*
    - this method is supposed to draw a multi-line text box but for some reason it's not working properly
 */
- (void)addTextBox:(NSString*)text withBoxWidth:(int)w fontHeight:(int)h;

/*
    - adds a single line text field at the cursor position
 */
- (void)addText:(NSString*)text withFontHeight:(int)h;

/*
    - draws a pdf417 barcode with the specified string. Some parameters need some tweaks, check the code if you want to customize
 */
- (void)addPDF417BarcodeWithString:(NSString*)str;

/*
    - appends a string to the current list of commands
 */
- (void)addCustomCommand:(NSString*)command;

/*
    - writes the "end of label" command and returns the list of commands
 */
- (NSString*)finish;

/*
    - returns the current list of commands
 */
- (NSString*)getCommands;

@end
