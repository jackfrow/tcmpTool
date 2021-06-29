//
//  TcmpManager.h
//  tcmpTool
//
//  Created by jackfrow on 2021/6/29.
//

#import <Foundation/Foundation.h>
#import "TcmpServers.h"
#import "SimplePing.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^PingComplete)(NSArray* models);

@interface TcmpManager : NSObject

-(void)startPingWithCount:(NSInteger)count
                  timeOut:(NSInteger)timeOut
                  servers:(NSArray*)servers
                 complete:(PingComplete)complete;

@end

NS_ASSUME_NONNULL_END
