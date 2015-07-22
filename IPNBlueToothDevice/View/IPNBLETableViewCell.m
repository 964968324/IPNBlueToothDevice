//
//  IPNPayChannelTableViewCell.m
//  IPNBlueToothDevice
//
//  Created by 刘宁 on 14/11/24.
//  Copyright (c) 2014年 刘宁. All rights reserved.
//

#import "IPNBLETableViewCell.h"

@implementation IPNBLETableViewCell

-(void)setDevice:(IPNBLEDevice *)device{
    _isConnect=false;
    _device=device;
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 160, 24)];
    lblName.text=device.deviceName;
    lblName.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:lblName];
}

-(void)setConnected{
    _isConnect=true;
    UILabel *lblConnect = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 100, 24)];
    lblConnect.textAlignment=NSTextAlignmentRight;
    lblConnect.text=@"已连接";
    lblConnect.font=[UIFont systemFontOfSize:18];
    lblConnect.textColor=[UIColor greenColor];
    [self.contentView addSubview:lblConnect];
}


@end
