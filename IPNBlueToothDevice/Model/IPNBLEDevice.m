//
//  IPNBLEDevice.m
//  IPNBlueToothDevice
//
//  Created by 刘宁 on 15/1/13.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import "IPNBLEDevice.h"
#import "IPNDeviceManager.h"

@interface IPNBLEDevice ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@end

@implementation IPNBLEDevice


-(instancetype)initWithPeripheral:(CBPeripheral *)peripheral{
    if ([self init]) {
        _peripheral=peripheral;
        _deviceName=peripheral.name;
    }
    return self;
}


-(void)connect{
    CBCentralManager * centralManager=(CBCentralManager *)[IPNDeviceManager sharedInstance].innerManager;
    centralManager.delegate=self;
    [centralManager connectPeripheral:_peripheral options:nil];
}

-(void)disconnect{
    CBCentralManager * centralManager=(CBCentralManager *)[IPNDeviceManager sharedInstance].innerManager;
    centralManager.delegate=self;
    [centralManager cancelPeripheralConnection:_peripheral];
}

#pragma mark - CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStatePoweredOff:
            break;
        case CBCentralManagerStatePoweredOn:
            break;
        default:
            break;
    }    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    peripheral.delegate=self;
    [peripheral discoverServices:nil];
    
    _isConnected=true;
    IPNDeviceManager *dm=[IPNDeviceManager sharedInstance];
    dm.currentDevice=self;
    NSMutableArray *array= dm.scannedDevices.mutableCopy;
    [array removeObject:self];
    dm.scannedDevices=array.copy;
    [dm stopScan];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    _isConnected=false;
    IPNDeviceManager *dm=[IPNDeviceManager sharedInstance];
    dm.currentDevice=nil;
    dm.scannedDevices=nil;
    if (!dm.isManualDisconnect)
        [dm beginAutoConnect];
    else{
        dm.isManualDisconnect=false;
        [dm startScan];
    }

}

@end
