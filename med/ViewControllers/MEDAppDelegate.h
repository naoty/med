//
//  MEDAppDelegate.h
//  med
//
//  Created by naoty on 2014/03/05.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MEDAppDelegate : NSDocumentController <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet NSMenuItem *stylesheetsMenuItem;
@property (nonatomic, weak) IBOutlet NSMenuItem *markdownPublishersMenuItem;
@property (nonatomic, weak) IBOutlet NSMenuItem *htmlPublishersMenuItem;

@end
