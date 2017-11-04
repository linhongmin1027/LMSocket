//
//  LMAsynSocketManager.m
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/4.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import "LMAsynSocketManager.h"
#import <GCDAsyncSocket.h>
static NSString *khost=@"127.0.0.1";
static const uint16_t kport=6969;
@interface LMAsynSocketManager()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_gcdSocket;
}

@end

@implementation LMAsynSocketManager

+(instancetype)share{
    static LMAsynSocketManager *insrance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        insrance=[[self alloc]init];
        [insrance initSocket];
    });
    return insrance;
    
}
//建立连接
-(BOOL)connect{
    
    return [_gcdSocket connectToHost:khost onPort:kport error:nil];
    
}
//断开连接
-(void)disConnect{
    [_gcdSocket disconnect];
    
}
-(void)sendMsg:(NSString *)message{
    NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
    [_gcdSocket writeData:data withTimeout:-1 tag:110];
    
}
//监听最新的消息
-(void)pullTheMessage{
    
    [_gcdSocket readDataWithTimeout:-1 tag:110];
    
    
    
}
#pragma mark privateMethod
-(void)initSocket{
    _gcdSocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
}


#pragma mark GCDAsyncSocketDelegate
//连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"GCD连接成功，host:%@,port:%d",host,port);
    [self pullTheMessage];
    //心跳写在这里
    
}
//断开连接的时候调用
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    
    NSLog(@"GCD断开连接，host:%@,port:%d",sock.localHost,sock.localPort);
    
    //断线重连写在这里
}
//写成功的回调
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
     NSLog(@"写的回调,tag:%ld",tag);
}
//收到消息的回调
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到消息：%@",msg);
    
    [self pullTheMessage];
    
}
@end

















