//
//  UIImage+HexCompression.h
//
//  Created by Diego Cathalifaud on 7/30/15.
//  Copyright (c) 2015 Diego Cathalifaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HexCompression)

/*
 
 - returns the zpl hex representation of self (UIImage)
 
 */

- (NSString*)compressedHexRepresentation;

@end
