//
//  MEDPipeline.m
//  med
//
//  Created by naoty on 2014/03/07.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDPipeline.h"
#import "MEDConfig.h"

@interface MEDPipeline ()
@property (nonatomic, copy) NSString *path;
@property (nonatomic) NSArray *scripts;
@end

@implementation MEDPipeline

- (id)init
{
    self = [super init];
    if (self) {
        MEDConfig *config = [MEDConfig sharedConfig];
        self.path = config.path;
        self.scripts = config.scripts;
    }
    return self;
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
        NSDate *startTime = [NSDate date];
        for (NSString *script in self.scripts) {
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = @"/bin/sh";
            task.arguments = @[@"-l", @"-c", script];
            task.environment = @{@"PATH": self.path};
            task.standardInput = previousTask.standardOutput;
            
            NSPipe *outputPipe = [NSPipe pipe];
            task.standardOutput = outputPipe;
            
            if ([self.scripts indexOfObject:script] == self.scripts.count - 1) {
                [[outputPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
                [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:[outputPipe fileHandleForReading] queue:nil usingBlock:^(NSNotification *notification){
                    NSDate *finishTime = [NSDate date];
                    NSTimeInterval time = [finishTime timeIntervalSinceDate:startTime];
                    
                    NSData *outputData = [[outputPipe fileHandleForReading] availableData];
                    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate pipeline:self didReceiveStandardOutput:outputString time:time];
                    });
                }];
            }
            
            NSPipe *errorPipe = [NSPipe pipe];
            task.standardError = errorPipe;
            
            [[errorPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
            [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:[errorPipe fileHandleForReading] queue:nil usingBlock:^(NSNotification *notification){
                NSDate *finishTime = [NSDate date];
                NSTimeInterval time = [finishTime timeIntervalSinceDate:startTime];
                
                NSData *errorData = [[errorPipe fileHandleForReading] availableData];
                NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate pipeline:self didReceiveStandardError:errorString time:time];
                });
            }];
            
            [task launch];
            [task waitUntilExit];
            
            previousTask = task;
        }
    });
}

@end
