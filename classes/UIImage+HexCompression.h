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
 NOTE(diego_cath): width and height of image need to be divisible by 8 because of the way the encoding works.
 
 */

- (NSString*)compressedHexRepresentation;

@end
