//
//  LMWebSocketManager.m
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/4.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import "LMWebSocketManager.h"
#import <SRWebSocket.h>
static NSString *khost=@"127.0.0.1";
static const uint16_t kport=6969;

#define dispatch_main_asyn_safe(block)\
if ([NSThread isMainThread]) {\
block();\
}else{\
dispatch_async(dispatch_get_main_queue(), block);\
}
@interface LMWebSocketManager ()<SRWebSocketDelegate>
{
    SRWebSocket *_socket;
    NSTimer *_heartBeat;
    NSTimeInterval _reConnectTime;
}
@end
@implementation LMWebSocketManager
+(instancetype)share{
    
    static LMWebSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
        [instance initSocket];
        
    });
    return instance;
}
-(void)initSocket{
    if (_socket) {
        return;
    }
    
    _socket=[[SRWebSocket alloc]initWithURL:[NSURL URLWithString:@"ws://ws.9dcj.com"] protocols:@[@"chat",@"superchat"]];
    _socket.delegate=self;
    
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount=1;
    
    [_socket setDelegateOperationQueue:queue];
    
    [_socket open];
}
-(void)initHeartBeat{
    
    dispatch_main_asyn_safe(^{
        [self destoryHeartBeat];
        __weak typeof(self) weakSelf=self;
        
        _heartBeat=[NSTimer scheduledTimerWithTimeInterval:3*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"sendHeartBeat");
            [weakSelf sendMessage:@"heartBeat"];
        }];
        
    });
}
-(void)destoryHeartBeat{
    
    dispatch_main_asyn_safe(^{
        if (_heartBeat) {
            [_heartBeat invalidate];
            _heartBeat=nil;
        }
        
    })
    
    
    
}

#pragma mark -
-(void)connect{
    [self initSocket];
    
    _reConnectTime=0;
}
-(void)disConnect{
    if (_socket) {
        [_socket close];
        _socket=nil;
    }
    
}



//发消息
-(void)sendMessage:(NSString *)message{
    [_socket send:message];
}
//重连机制
-(void)reConnect{
    [self disConnect];
    if (_reConnectTime>64) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _socket=nil;
        [self initSocket];
    });
    
    if (_reConnectTime==0) {
        _reConnectTime=2;
    }else{
        _reConnectTime*=2;
    }
}
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
     NSLog(@"服务器返回收到消息:%@",message);
    
}
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"连接成功");
    
    //连接成功了开始发送心跳
    [self initHeartBeat];
}
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"连接失败.....\n%@",error);
    
    [self reConnect];
}
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    [self destoryHeartBeat];
}
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    
    NSLog(@"收到pong回调");
}
@end
