//
//  MEDWindowController.h
//  med
//
//  Created by naoty on 2014/03/10.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MEDWindowController : NSWindowController
@property (nonatomic) IBOutlet NSTextView *editor;
- (void)changePreviewStylesheetAtPath:(NSString *)path;
@end
