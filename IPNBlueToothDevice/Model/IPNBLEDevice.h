//
//  IPNBLEDevice.h
//  IPNBlueToothDevice
//
//  Created by 刘宁 on 15/1/13.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <CoreBluetooth/CoreBluetooth.h>

@interface IPNBLEDevice : NSObject

-(instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@property (nonatomic,readonly)BOOL isConnected;
@property (nonatomic,strong) NSString* deviceID;
@property (nonatomic,readonly) NSString* deviceName;
@property (nonatomic,readonly) CBPeripheral* peripheral;

-(void) connect;
-(void) disconnect;

@end
