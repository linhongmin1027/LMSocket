//
//  LMNatureSocketManager.m
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/3.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import "LMNatureSocketManager.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface LMNatureSocketManager ()

@property(nonatomic, assign)int clientScoket;

@end
@implementation LMNatureSocketManager
+(instancetype)share{
    static LMNatureSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
        [instance initSocket];
        [instance pullMsg];
    
    });
    return instance;
}
-(void)initSocket{
    if (_clientScoket) {
        [self disConnect];
        _clientScoket=0;
    }
    _clientScoket=CreateClinetSocket();
    
    const char *server_ip="127.0.0.1";
    short server_port=6969;
    if (ConnectionToServer(_clientScoket, server_ip, server_port)==0) {
        NSLog(@"连接服务器失败");
        return;
    }
    NSLog(@"连接服务器成功");
    
}

static int CreateClinetSocket()
{
    int ClineSocket=0;
    ClineSocket=socket(AF_INET, SOCK_STREAM, 0);
    return ClineSocket;
}
//发起连接
static int ConnectionToServer(int client_socket,const char *server_ip,unsigned port)
{
    struct sockaddr_in sAddr={0};
    sAddr.sin_len=sizeof(sAddr);
    
    sAddr.sin_family=AF_INET;
    inet_aton(server_ip,&sAddr.sin_addr);
    sAddr.sin_port=htons(port);
    if (connect(client_socket, (struct sockaddr *)&sAddr, sizeof(sAddr)==0)) {
        return client_socket;
    }
    return 0;
}
-(void)pullMsg{
    //开辟一个线程来接收信息
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(receiveAction) object:nil];
    [thread start];
}
-(void)connect{
    [self initSocket];
    
}
-(void)disConnect{
    close(self.clientScoket);
    
}
-(void)sendMsg:(NSString *)msg{
    
    const char *sendMessage=[msg UTF8String];
    send(self.clientScoket, sendMessage, sizeof(sendMessage)+1, 0);
}
-(void)receiveAction{
    
    while (1) {
        char receive_message[1024]={0};
        recv(self.clientScoket, receive_message, sizeof(receive_message), 0);
        //NSLog(@"接收的信息：%s",receive_message);
    }
    
    
    
    
    
}
@end
