//
//  MEDConfig.h
//  med
//
//  Created by naoty on 2014/03/08.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEDConfig : NSObject

@property (nonatomic, copy) NSString *path;
@property (nonatomic) NSArray *parsers;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic) NSNumber *fontSize;
@property (nonatomic) NSNumber *padding;

@property (nonatomic) NSMutableArray *defaultStylesheetPaths;
@property (nonatomic) NSMutableArray *userStylesheetPaths;

+ (id)sharedConfig;

@end
