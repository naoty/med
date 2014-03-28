//
//  MEDPublisher.m
//  med
//
//  Created by naoty on 2014/03/24.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDPublisher.h"
#import "MEDConfig.h"

@interface MEDPublisher ()
@property (nonatomic, copy) NSString *name;
@end

@implementation MEDPublisher

- (id)initWithName:(NSString *)name
{
    self = [self init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (void)runWithFilename:(NSString *)filename standardInput:(NSString *)standardInput
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSDate *startTime = [NSDate date];
        
        NSTask *task = [NSTask new];
        task.launchPath = @"/bin/sh";
        task.arguments = @[@"-l", @"-c", [NSString stringWithFormat:@"%@ '%@'", self.name, filename]];
        task.environment = @{@"PATH": [[MEDConfig sharedConfig] path]};
        
        NSPipe *inputPipe = [NSPipe pipe];
        [inputPipe.fileHandleForWriting writeData:[standardInput dataUsingEncoding:NSUTF8StringEncoding]];
        task.standardInput = inputPipe;
        
        NSPipe *outputPipe = [NSPipe pipe];
        task.standardOutput = outputPipe;
        [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:outputPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification *notification){
            NSDate *finishTime = [NSDate date];
            NSTimeInterval time = [finishTime timeIntervalSinceDate:startTime];
            
            NSData *outputData = outputPipe.fileHandleForReading.availableData;
            NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate publisher:self didReceiveStandardOutput:outputString time:time];
            });
        }];
        
        NSPipe *errorPipe = [NSPipe pipe];
        task.standardError = errorPipe;
        [errorPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:errorPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification *notification){
            NSDate *finishTime = [NSDate date];
            NSTimeInterval time = [finishTime timeIntervalSinceDate:startTime];
            
            NSData *errorData = errorPipe.fileHandleForReading.availableData;
            NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate publisher:self didReceiveStandardError:errorString time:time];
            });
        }];
        
        [task launch];
        [task waitUntilExit];
    });
}

@end
