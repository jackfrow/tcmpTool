//
//  TcmpServers.h
//  tcmpTool
//
//  Created by jackfrow on 2021/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


extern NSInteger const timeOut;

@class TcmpServers;

typedef void(^CompleteBlock)(void);

@interface TcmpServers : NSObject

@property (nonatomic, copy,nullable) CompleteBlock complete;

@property (nonatomic, readonly,strong) NSString *host;

@property (nonatomic, assign) NSTimeInterval coast;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) bool finish;

@property (nonatomic, strong) id object;

-(instancetype)initWithHost:(NSString*)host;

-(void)startPing;


@end

NS_ASSUME_NONNULL_END
