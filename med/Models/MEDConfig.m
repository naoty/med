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

#pragma mark - Singleton pattern

- (id)initSharedInstance
{
    self = [super init];
    if (self) {
        // Default config
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *bundledConfigPath = [bundle pathForResource:@"med" ofType:@"json"];
        [self loadWithContentOfFile:bundledConfigPath];
    
        // User's config
        NSString *userConfigPath = [@"~/.med.json" stringByExpandingTildeInPath];
        [self loadWithContentOfFile:userConfigPath];
        
        // Default stylesheet
        _defaultStylesheetPaths = [NSMutableArray array];
        NSString *defaultStylesheetPath = [bundle pathForResource:@"github" ofType:@"css"];
        [self.defaultStylesheetPaths addObject:defaultStylesheetPath];
        
        // User's stylesheets
        _userStylesheetPaths = [NSMutableArray array];
        NSString *userStylesheetsDirectoryPath = [@"~/.med/stylesheets" stringByExpandingTildeInPath];
        NSArray *filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userStylesheetsDirectoryPath error:nil];
        for (NSString *filename in filenames) {
            NSString *extension = [filename pathExtension];
            if ([extension isEqualToString:@"css"]) {
                NSString *fullPath = [userStylesheetsDirectoryPath stringByAppendingPathComponent:filename];
                [self.userStylesheetPaths addObject:fullPath];
            }
        }
    }
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private methods

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
        return;
    }
    
    _path = json[@"path"] ?: _path;
    _parsers = json[@"parsers"] ?: _parsers;
    
    NSDictionary *publishers = json[@"publishers"];
    if (publishers) {
        _markdownPublishers = publishers[@"markdown"] ?: _markdownPublishers;
        _htmlPublishers = publishers[@"html"] ?: _htmlPublishers;
    }
    
    NSDictionary *editor = json[@"editor"];
    if (editor) {
        _fontName = editor[@"fontName"] ?: _fontName;
        _fontSize = editor[@"fontSize"] ?: _fontSize;
        _padding = editor[@"padding"] ?: _padding;
        _smartIndentEnabled = [editor[@"smartIndentEnabled"] boolValue] ?: _smartIndentEnabled;
        _softTabEnabled = [editor[@"softTabEnabled"] boolValue] ?: _softTabEnabled;
        _tabWidth = editor[@"tabWidth"] ?: _tabWidth;
        _autoPairCompletionEnabled = [editor[@"autoPairCompletionEnabled"] boolValue] ?: _autoPairCompletionEnabled;
    }
}

@end
