//
//  IPNDeviceManager.h
//  IPNBlueToothDevice
//
//  Created by 刘宁 on 15/1/13.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPNBLEDevice.h"

@protocol IPNBLEDeviceManagerDelegate

-(void)updateScannedDevices;

@end


@protocol IPNBLEDeviceConnectDelegate

-(void)connect;

@end


@interface IPNDeviceManager : NSObject

@property (nonatomic,strong) IPNBLEDevice* currentDevice;
@property (nonatomic,strong) NSString* deviceName;
@property (nonatomic,strong) NSArray* scannedDevices;
@property (nonatomic,weak) id<IPNBLEDeviceManagerDelegate> delegate;
@property (nonatomic,weak) id<IPNBLEDeviceConnectDelegate> connectDelegate;
@property (nonatomic,readonly) BOOL isAutoConnect;
@property (nonatomic,readwrite) BOOL isManualDisconnect;
@property (nonatomic,readwrite) BOOL hasSignedIn;
@property (nonatomic,readonly) id innerManager;

-(void) beginAutoConnect;
-(void) startScan;
-(void) stopScan;

+(IPNDeviceManager *) sharedInstance;


@end
