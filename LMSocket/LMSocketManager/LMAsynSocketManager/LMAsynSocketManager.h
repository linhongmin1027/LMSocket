//
//  LMAsynSocketManager.h
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/4.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMAsynSocketManager : NSObject
+(instancetype)share;
-(BOOL)connect;
-(void)disConnect;
-(void)sendMsg:(NSString *)message;
-(void)pullTheMessage;
@end
