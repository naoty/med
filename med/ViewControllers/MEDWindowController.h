//
//  MEDWindowController.h
//  med
//
//  Created by naoty on 2014/03/10.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MEDPublisher.h"

@class NTYSmartTextView;

@interface MEDWindowController : NSWindowController <MEDPublisherDelegate>

@property (nonatomic) IBOutlet NTYSmartTextView *editor;

- (void)changePreviewStylesheetAtPath:(NSString *)path;
- (void)runMarkdownPublisher:(MEDPublisher *)publisher;
- (void)runHTMLPublisher:(MEDPublisher *)publisher;

@end
