//
//  ViewController.m
//  tcmpTool
//
//  Created by jackfrow on 2021/6/29.
//

#import "ViewController.h"
#import "TcmpManager.h"

@interface ViewController ()

@property (nonatomic, strong) TcmpServers *ping;
@property (nonatomic, strong) TcmpManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)ping:(id)sender {
    
    
    NSMutableArray* models = [[NSMutableArray alloc] init];
    
    for (NSString* url in @[@"www.baidu.com"]) {
        TcmpServers* server = [[TcmpServers alloc] initWithHost:url];
        [models addObject:server];
    }
//    self.manager = [[TcmpManager alloc] init];
    
    [self.manager startPingWithCount:3 timeOut:3 servers:models complete:^(NSArray * _Nonnull models) {
        
        for (TcmpServers* server in models) {
            NSLog(@"server = %f",server.coast);
        }
    }];

//    TcmpServers* server = [[TcmpServers alloc] initWithHost:@"www.baidu.com"];
//    server.count = 20;
//    [server startPing];
//    server.complete = ^(TcmpServers * _Nonnull server) {
//        NSLog(@"complete = %f",server.coast);
//    };
//
//    self.ping = server;
}

-(TcmpManager *)manager{
    if (_manager == nil) {
        _manager = [[TcmpManager alloc] init];
    }
    return  _manager;
}


@end
