  //
//  IPNBLEManagerViewController.m
//  IPNBlueToothDevice
//
//  Created by 刘宁 on 15/1/13.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import "IPNBLEManagerViewController.h"
#import "IPNBLETableViewCell.h"
#import "IPNDeviceManager.h"

@interface IPNBLEManagerViewController ()<UITableViewDataSource,UITableViewDelegate,IPNBLEDeviceManagerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

- (IBAction)searchDevice:(id)sender;
@end

@implementation IPNBLEManagerViewController
{
    __weak IPNDeviceManager *dm;
    BOOL _manualConnect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _activityView.hidden=true;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    dm=[IPNDeviceManager sharedInstance];
    dm.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showAlertView:(NSString *)info{
    UIAlertView *waitView=[[UIAlertView alloc]initWithTitle:@"" message:info delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    [waitView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [waitView dismissWithClickedButtonIndex:0 animated:YES];
    });
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger i=0;
    if (dm.currentDevice!=nil)
        i+=1;
    if (dm.scannedDevices!=nil)
        i+=dm.scannedDevices.count;
    return i;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPNBLETableViewCell *cell=[IPNBLETableViewCell new];
    if (indexPath.row==0 && dm.currentDevice !=nil) {
        cell.device=dm.currentDevice;
        if (dm.currentDevice.isConnected){
            [cell setConnected];
            if (_manualConnect) {
                [self showAlertView:@"蓝牙设备已连接"];
                [dm setDeviceName:dm.currentDevice.deviceName];
            }
        }
        return cell;
    }
    
    NSInteger i=indexPath.row;
    if (dm.currentDevice!=nil)
        i=i-1;
    if ( dm.scannedDevices !=nil) {
        IPNBLEDevice *device=(IPNBLEDevice *)[dm.scannedDevices objectAtIndex:i];
        cell.device=device;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index=indexPath.row;
    if (indexPath.row==0 ) {
        if (dm.currentDevice!=nil) {
           //是否断开
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"是否断开此设备连接？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alertView show];
            //[dm.currentDevice disconnect];
 
        }else{
            IPNBLEDevice *device=[dm.scannedDevices objectAtIndex:index];
            [device connect];
            _manualConnect=true;
        }
    }else{
        if (dm.currentDevice!=nil) {
            [_activityView startAnimating];
            _activityView.hidden=false;
            IPNBLEDevice *device=[dm.scannedDevices objectAtIndex:index-1];
            [dm setDeviceName:device.deviceName];
            [dm.currentDevice disconnect];
            
        }else{
            IPNBLEDevice *device=[dm.scannedDevices objectAtIndex:index];
           [device connect];
           _manualConnect=true;
        }
    }
}

#pragma mark - AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [_activityView startAnimating];
        _activityView.hidden=false;
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:true];
        dm.isManualDisconnect=true;
        [dm.currentDevice disconnect];
    }
}

- (IBAction)searchDevice:(id)sender {
        [_activityView startAnimating];
        _activityView.hidden=false;
        dm.scannedDevices =[NSArray new];
        
        [dm startScan];
}

-(void)updateScannedDevices{
    [self.tableView reloadData];
    if (dm.scannedDevices!=nil && dm.scannedDevices.count >0) {
        [_activityView stopAnimating];
        _activityView.hidden=true;
    }
}
@end
