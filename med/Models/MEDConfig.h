//
//  MEDConfig.h
//  med
//
//  Created by naoty on 2014/03/08.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEDConfig : NSObject

@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, readonly) NSArray *parsers;
@property (nonatomic, readonly) NSArray *markdownPublishers;
@property (nonatomic, readonly) NSArray *htmlPublishers;
@property (nonatomic, copy, readonly) NSString *fontName;
@property (nonatomic, readonly) NSNumber *fontSize;
@property (nonatomic, readonly) NSNumber *padding;
@property (nonatomic, readonly) BOOL smartIndentEnabled;
@property (nonatomic, readonly) BOOL softTabEnabled;
@property (nonatomic, readonly) NSNumber *tabWidth;
@property (nonatomic, readonly) BOOL autoPairCompletionEnabled;

@property (nonatomic, readonly) NSMutableArray *defaultStylesheetPaths;
@property (nonatomic, readonly) NSMutableArray *userStylesheetPaths;

+ (id)sharedConfig;

@end
