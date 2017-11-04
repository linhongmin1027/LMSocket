//
//  LMJiuduSocketManager.m
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/4.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import "LMJiuduSocketManager.h"
#import <SRWebSocket.h>
#define WSURLSTRING @"ws://ws.9dcj.com"
@interface LMJiuduSocketManager ()<SRWebSocketDelegate>

@property(nonatomic, strong)SRWebSocket *socket;

@property(nonatomic, weak)id<LMJiuduSocketManagerDelegate>delegate;
@end
@implementation LMJiuduSocketManager
+(instancetype)shareWithDelegate:(id<LMJiuduSocketManagerDelegate>)delegate{
    static LMJiuduSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    instance.delegate=delegate;
    return instance;
}
-(void)startConnect{
    [self disConnect];
    [self.socket open];

}
-(void)disConnect{
    if (_socket) {
        [_socket close];
        _socket=nil;
    }
    
    
}
-(SRWebSocket *)socket{
    if (!_socket) {
        _socket=[[SRWebSocket alloc]initWithURL:[NSURL URLWithString:WSURLSTRING] protocols:@[@"chat",@"superchat"]];
        _socket.delegate=self;
        NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        queue.maxConcurrentOperationCount=1;
        [_socket setDelegateOperationQueue:queue];
    }
    return _socket;
    
}
-(void)sendMessage:(id)message{
    
    [self.socket send:message];
    
    
}
#pragma mark -
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"九度收到消息%@",message);
   
    if ([self.delegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [self.delegate didReceiveMessage:message];
    }
    
    
    
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"九度连接成功");
    NSDictionary *message=@{
                            @"accesstoken":@"",
                            @"ip":@"192.168.128.100",
                            @"roomid":@"1082",
                            @"type":@"login",
                            @"uuid":@"A92CD98C-DCF6-4CFF-8EDE-46C466F609FD"
                            };
    NSData *data=[NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
    [_socket send:data];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"九度连接失败");
    
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"九度连接关闭");
    [self disConnect];
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSLog(@"收到心跳");

}
@end
