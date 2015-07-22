//
//  IPNPayChannelTableViewCell.h
//  IPNBlueToothDevice
//
//  Created by 刘宁 on 14/11/24.
//  Copyright (c) 2014年 刘宁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPNBLEDevice.h"

@interface IPNBLETableViewCell : UITableViewCell

@property (nonatomic,strong) IPNBLEDevice* device;
@property (nonatomic) BOOL isConnect;

-(void) setConnected;

@end
