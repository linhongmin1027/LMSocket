//
//  LMWebSocketManager.h
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/4.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMWebSocketManager : NSObject
-(void)connect;
+(instancetype)share;
-(void)sendMessage:(NSString *)message;
-(void)disConnect;
@end
