//
//  MEDPipeline.m
//  med
//
//  Created by naoty on 2014/03/07.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDPipeline.h"

@interface MEDPipeline ()
@property (nonatomic) NSMutableArray *scripts;
@end

@implementation MEDPipeline

// TODO: Set $PATH from config files to [NSTask -environment].
const NSString *PATH = @"";

- (id)init
{
    self = [super init];
    if (self) {
        self.scripts = [NSMutableArray array];
    }
    return self;
}

- (void)addScript:(NSString *)script
{
    [self.scripts addObject:script];
}

- (void)runWithInput:(NSString *)input
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSTask *echo = [[NSTask alloc] init];
        echo.launchPath = @"/bin/echo";
        echo.arguments = @[input];
        
        NSPipe *echoOutputPipe = [NSPipe pipe];
        echo.standardOutput = echoOutputPipe;
        
        [echo launch];
        [echo waitUntilExit];
        
        NSTask *previousTask = echo;
        for (NSString *script in self.scripts) {
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = @"/bin/sh";
            task.arguments = @[@"-l", @"-c", script];
            task.environment = @{@"PATH": PATH};
            task.standardInput = previousTask.standardOutput;
            
            NSPipe *outputPipe = [NSPipe pipe];
            task.standardOutput = outputPipe;
            
            if ([self.scripts indexOfObject:script] == self.scripts.count - 1) {
                [[outputPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
                [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:[outputPipe fileHandleForReading] queue:nil usingBlock:^(NSNotification *notification){
                    NSData *outputData = [[outputPipe fileHandleForReading] availableData];
                    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate pipeline:self didReceiveStandardOutput:outputString];
                    });
                }];
            }
            
            [task launch];
            [task waitUntilExit];
            
            previousTask = task;
        }
    });
}

@end
