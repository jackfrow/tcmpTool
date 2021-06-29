//
//  TcmpManager.m
//  tcmpTool
//
//  Created by jackfrow on 2021/6/29.
//

#import "TcmpManager.h"

typedef NS_ENUM(NSInteger,TcmpState) {
    TcmpStateSuccess,
    TcmpStateTimeOut
};

@interface TcmpManager ()

@property (nonatomic, strong) NSArray* servers;

@property (nonatomic, strong) dispatch_group_t group;

@property (nonatomic, strong) PingComplete complete;

@property (nonatomic, assign) BOOL callBack;

@end

@implementation TcmpManager


-(void)startPingWithCount:(NSInteger)count
                  timeOut:(NSInteger)timeOut
                  servers:(NSArray *)servers
                complete:(nonnull PingComplete)complete
    {
        self.callBack = false;
        self.servers = servers;
        self.complete = complete;
        
        __weak typeof(self) weakSelf = self;
        
        for (TcmpServers* server in servers) {
            [self callEnter];
            server.count = count;
//            __weak typeof(self) weakSelf = self;
            server.complete = ^() {
                [weakSelf callLeave];
            };
        }
        
        for (TcmpServers* server in servers) {
            [server startPing];
        }
        

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOut * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self completeWithState:TcmpStateTimeOut];
        });
        
        dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
            [self completeWithState:TcmpStateSuccess];
        });
        
    }


-(void)callEnter{
    dispatch_group_enter(self.group);
}

-(void)callLeave{
    dispatch_group_leave(self.group);
}

-(void)completeWithState:(TcmpState)state{
    
    if (self.callBack) {
        return;
    }
    self.callBack = true;
    if (self.complete) {
        self.complete(self.servers);
    }
    self.complete = nil;
    self.servers = nil;
    
}


-(dispatch_group_t)group{
    if (_group == nil) {
        _group = dispatch_group_create();
    }
    return _group;
}

@end
