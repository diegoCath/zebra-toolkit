//
//  PrinterManager.m
//
//
//  Created by Diego Cathalifaud on 1/25/16.
//  Copyright (c) 2016 Diego Cathalifaud. All rights reserved.
//

#import "PrinterManager.h"

#import <ZebraPrinter.h>
#import <ZebraPrinterConnection.h>
#import <ZebraPrinterFactory.h>
#import <MfiBtPrinterConnection.h>

@implementation PrinterManager

- (void)print {
    [NSThread detachNewThreadSelector:@selector(startPrinter) toTarget:self withObject:nil];
}

- (void)startPrinter {
    
    @autoreleasepool {
     
        BOOL couldPrint = NO;
        
        if([self.delegate respondsToSelector:@selector(printerStatusChanged:)]) {
            [self.delegate printerStatusChanged:kStatusConnecting];
        }
        
        EAAccessoryManager *manager = [EAAccessoryManager sharedAccessoryManager];
        NSArray *bluetoothPrinters = [[NSArray alloc] initWithArray:manager.connectedAccessories];
        EAAccessory *printer = bluetoothPrinters.firstObject;
        
        id<ZebraPrinterConnection, NSObject> connection = [[MfiBtPrinterConnection alloc] initWithSerialNumber:printer.serialNumber];
        
        BOOL didOpen = [connection open];
        if(didOpen) {
            NSError *error = nil;
            id<ZebraPrinter> printer = [ZebraPrinterFactory getInstance:connection error:&error];
            
            if(printer) {
                PrinterLanguage language = [printer getPrinterControlLanguage];
                
                if(language == PRINTER_LANGUAGE_CPCL) {
                    if([self.delegate respondsToSelector:@selector(printerFailedWithErrorCode:)]) {
                        [self.delegate printerFailedWithErrorCode:kErrorWrongLanguage];
                    }
                }
                else {
                    
                    if([self.delegate respondsToSelector:@selector(printerStatusChanged:)]) {
                        [self.delegate printerStatusChanged:kStatusSendingData];
                    }
                    
                    NSError *error = nil;
                    
                    BOOL ret = [[printer getToolsUtil] sendCommand:self.commands error:&error];
                    
                    if(!ret) {
                        NSLog(@"printer error?");
                    }
                    
                    if(error) {
                        if([self.delegate respondsToSelector:@selector(printerFailedWithErrorCode:)]) {
                            [self.delegate printerFailedWithErrorCode:kErrorPrintingError];
                        }
                    }
                    
                    else {
                        couldPrint = YES;
                    }
                }
            }
            else {
                if([self.delegate respondsToSelector:@selector(printerFailedWithErrorCode:)]) {
                    [self.delegate printerFailedWithErrorCode:kErrorNoPrinter];
                }
            }
        }
        else {
            if([self.delegate respondsToSelector:@selector(printerFailedWithErrorCode:)]) {
                [self.delegate printerFailedWithErrorCode:kErrorNoPrinter];
            }
        }
        
        if([self.delegate respondsToSelector:@selector(printerStatusChanged:)]) {
            [self.delegate printerStatusChanged:kStatusDisconnecting];
        }
        
        [NSThread sleepForTimeInterval:2.0];
        
        [connection close];
        
        if(couldPrint) {
            if([self.delegate respondsToSelector:@selector(printerFinishedPrinting)]) {
                [self.delegate printerFinishedPrinting];
            }
        }
    }
}

@end
