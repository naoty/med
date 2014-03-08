//
//  MEDConfig.m
//  med
//
//  Created by naoty on 2014/03/08.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDConfig.h"

@implementation MEDConfig

+ (id)sharedConfig
{
    static MEDConfig *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MEDConfig alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (void)loadWithContentOfFile:(NSString *)path
{
    NSData *configData = [[NSData alloc] initWithContentsOfFile:path];
    if (configData == nil) {
        return;
    }
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        self.path = (json[@"path"] == nil) ? self.path : json[@"path"];
        self.scripts = (json[@"scripts"] == nil) ? self.scripts : json[@"scripts"];
        
        NSDictionary *editor = json[@"editor"];
        if (editor) {
            self.fontName = (editor[@"fontName"] == nil) ? self.fontName : editor[@"fontName"];
            self.fontSize = (editor[@"fontSize"] == nil) ? self.fontSize : editor[@"fontSize"];
        }
    }
}

#pragma mark - Singleton pattern

- (id)initSharedInstance
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
