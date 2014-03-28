//
//  MEDWindowController.h
//  med
//
//  Created by naoty on 2014/03/10.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MEDPublisher.h"

@interface MEDWindowController : NSWindowController <MEDPublisherDelegate>

@property (nonatomic) IBOutlet NSTextView *editor;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic) MEDPublisher *publisher;

- (void)changePreviewStylesheetAtPath:(NSString *)path;

@end
