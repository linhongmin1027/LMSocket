//
//  LMJiuduSocketManager.h
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/4.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LMJiuduSocketManagerDelegate<NSObject>

-(void)didReceiveMessage:(id)message;

@end
@interface LMJiuduSocketManager : NSObject
+(instancetype)shareWithDelegate:(id<LMJiuduSocketManagerDelegate>)delegate;


-(void)startConnect;
-(void)disConnect;
-(void)sendMessage:(id)message;
@end
