//
//  IPNDeviceManager.m
//  IPNBlueToothDevice
//
//  Created by 刘宁 on 15/1/13.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import "IPNDeviceManager.h"
#import "IPNBLEDevice.h"
#import  <CoreBluetooth/CoreBluetooth.h>

#define kDeviceName      @"IPNBLEDeviceName"

@interface IPNDeviceManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@end

@implementation IPNDeviceManager
{
    NSArray *_scannedDevices;
    CBCentralManager      *_centralManager;
}

@synthesize scannedDevices=_scannedDevices;

static  IPNDeviceManager*_sharedInstance=nil;
+(IPNDeviceManager *)sharedInstance{
    @synchronized(self) {
        if (_sharedInstance==nil)
        {
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            _sharedInstance=[[IPNDeviceManager alloc]init];
            _sharedInstance.scannedDevices=[NSArray new];
            _sharedInstance.deviceName=[userDefaults stringForKey:kDeviceName];
        }
    }
    return _sharedInstance;
}

-(void)setCurrentDevice:(IPNBLEDevice *)currentDevice{
    _currentDevice=currentDevice;
    if (currentDevice!=nil && _connectDelegate!=nil) {
        [_connectDelegate connect];
    }
}

-(void)setScannedDevices:(NSArray *)scannedDevices{
    @synchronized(self){
        _scannedDevices=scannedDevices;
        [self.delegate updateScannedDevices];
    }
}

-(void)setDeviceName:(NSString *)deviceName{
    _deviceName=deviceName;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceName forKey:kDeviceName];
}

-(id)innerManager{
    return _centralManager;
}

#pragma mark - Function

-(void)beginAutoConnect{
    if (self.deviceName==nil)
        return;
    [_currentDevice disconnect];
    _currentDevice=nil;
    _isAutoConnect=true;
    
    if (_currentDevice!=nil && _currentDevice.isConnected) {
        [_currentDevice disconnect];
        _currentDevice=nil;
    }
    
    self.scannedDevices=nil;
    _centralManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

-(void)startScan{
    [self stopScan];
    
    if (_currentDevice!=nil && _currentDevice.isConnected) {
        [_currentDevice disconnect];
        _currentDevice=nil;
    }
    
    self.scannedDevices=nil;
    _centralManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

-(void)stopScan{
    if (_isAutoConnect) {
        _isAutoConnect=false;
    }
    [_centralManager stopScan];
}

#pragma mark - CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey,nil];
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
            [central scanForPeripheralsWithServices:nil options:dic];
            break;
        default:
            break;
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if(peripheral.name!=Nil && [[advertisementData objectForKey:@"kCBAdvDataIsConnectable"] integerValue]==1){
        [_centralManager stopScan];
        
        NSString* name=peripheral.name;
        if (_currentDevice!=nil) {
            if ([_currentDevice.deviceName isEqualToString:name])
                return;
        }
        
        NSMutableArray *array=[NSMutableArray new];
        IPNBLEDevice *dv=[[IPNBLEDevice alloc]initWithPeripheral:peripheral];
        [array addObject:dv];
        [array addObjectsFromArray:_scannedDevices];
        [self setScannedDevices:array.copy];
        
        if (_isAutoConnect && [name isEqualToString:_deviceName]) {
            [dv connect];
        }
    }
}


@end
