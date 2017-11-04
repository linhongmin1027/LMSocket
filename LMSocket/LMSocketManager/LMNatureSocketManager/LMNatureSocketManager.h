//
//  LMNatureSocketManager.h
//  LMSocket
//
//  Created by 林宏敏 on 2017/11/3.
//  Copyright © 2017年 LMSocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMNatureSocketManager : NSObject
+(instancetype)share;
-(void)connect;
-(void)sendMsg:(NSString *)msg;
@end
