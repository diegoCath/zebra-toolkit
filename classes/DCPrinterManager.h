//
//  PrinterManager.h
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

/*
 Manages the connection with a bluetooth zebra printer. Instructs the printer to print a given set of commands
 */
@interface DCPrinterManager : NSObject

@property(nonatomic, weak) id<DCPrinterDelegate> delegate;

/*
 These are the commands you want to send to the printer
 */
@property(nonatomic, strong) NSString *commands;

- (void)print;

@end
