//
//  ViewController.m
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/3.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import "ViewController.h"
#import "LMNatureSocketManager.h"
#import "LMAsynSocketManager.h"
#import "LMWebSocketManager.h"
#import "LMJiuduSocketManager.h"
@interface ViewController ()<LMJiuduSocketManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *message;
@property(nonatomic, strong)LMJiuduSocketManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager=[LMJiuduSocketManager shareWithDelegate:self];
 
    
}
- (IBAction)connect:(id)sender {
    [self.manager startConnect];
   
   
}
- (IBAction)send:(id)sender {
    
    NSDictionary *message=@{
                            @"app":@"1",
                            @"type":@"chat",
                            @"content":self.message.text,
                            @"webadress":@"ws.9dcj.com",
                            @"ieshouuserid":@"-1",
                            @"jieshounickname":@"所有人"
                            };
    NSData *data=[NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
    [self.manager sendMessage:data];
    
    
}
- (IBAction)disconnect:(id)sender {
    
    [self.manager disConnect];
    
}
#pragma mark LMJiuduSocketManagerDelegate
-(void)didReceiveMessage:(id)message{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
