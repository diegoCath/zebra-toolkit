//
//  PrinterManager.h
//
//
//  Created by Diego Cathalifaud on 1/25/16.
//  Copyright (c) 2016 Diego Cathalifaud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kErrorWrongLanguage,
    kErrorNoPrinter,
    kErrorInvalidInput,
    kErrorPrintingError
} DCPrinterErrorCode;

typedef enum {
    kStatusConnecting,
    kStatusSendingData,
    kStatusDisconnecting
} DCPrinterStatusCode;

@protocol DCPrinterDelegate <NSObject>

- (void)printerFinishedPrinting;
- (void)printerStatusChanged:(DCPrinterStatusCode)status;
- (void)printerFailedWithErrorCode:(DCPrinterErrorCode)error;

@end

@interface DCPrinterManager : NSObject

@property(nonatomic, weak) id<DCPrinterDelegate> delegate;
@property(nonatomic, strong) NSString *commands;

- (void)print;

@end
