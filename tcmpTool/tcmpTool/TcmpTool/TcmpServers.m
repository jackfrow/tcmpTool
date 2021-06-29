//
//  TcmpServers.m
//  tcmpTool
//
//  Created by jackfrow on 2021/6/29.
//

#import "TcmpServers.h"
#import "SimplePing.h"


typedef NS_ENUM(NSInteger,ULPingResult){
    ULPingResultFail,
    ULPingResultSuccess,
    ULPingResultSendFail
} ;


NSInteger const timeOut = 9999;

@interface TcmpServers ()<SimplePingDelegate>

@property (nonatomic, copy) NSString *hostName;

@property (nonatomic, strong) NSDate *startTime;

@property (nonatomic, strong) SimplePing *ping;

@property (nonatomic, assign) NSTimeInterval timeCoast;

@end

@implementation TcmpServers


-(instancetype)initWithHost:(NSString*)host{
    if (self = [super init]) {
        _host = host;
        _ping = [[SimplePing alloc] initWithHostName:host];
        _ping.delegate = self;
        [_ping setAddressStyle:SimplePingAddressStyleAny];
    }
    return  self;
}


-(void)startPing{
    [self.ping start];
}

-(void)sendPing{
    self.count -= 1;
    if (self.count < 0) {
        NSLog(@"ping finish");
        if (self.complete) {
            self.complete();
            self.complete = nil;
        }
        //在这里callback.
        return;
    }
    self.startTime = [[NSDate alloc] init];
    [self.ping sendPingWithData:nil];
}


-(void)pingResult:(ULPingResult)result{
    switch (result) {
        case ULPingResultSuccess:{
            NSLog(@"ULPingResultSuccess");
            NSDate* now = [[NSDate alloc] init];
            NSTimeInterval interval = [now timeIntervalSinceDate:self.startTime];
            self.timeCoast += interval * 1000;
        }
            break;
        case ULPingResultSendFail:
        case ULPingResultFail:
            NSLog(@"ULPingResultFailed");
            self.timeCoast += 9999;
            break;
    }
    [self sendPing];
}

-(NSTimeInterval)coast{
    return  self.timeCoast;
}


#pragma mark - SimplePingDelegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address{
//    NSLog(@"didStartWithAddress");
    [self sendPing];
}

    
- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    [self pingResult:ULPingResultFail];
}


- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
//    NSLog(@"didSendPacket");
}



- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error{
//    NSLog(@"didFailToSendPacket");
    [self pingResult:ULPingResultSendFail];
}


- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    NSLog(@"didReceivePingResponsePacket");
    [self pingResult:ULPingResultSuccess];
}


- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet{
    NSLog(@"didReceiveUnexpectedPacket");
//    [self pingResult:ULPingResultFail];
}

@end
