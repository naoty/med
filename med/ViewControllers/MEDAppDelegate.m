//
//  MEDAppDelegate.m
//  med
//
//  Created by naoty on 2014/03/05.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDAppDelegate.h"
#import "MEDMasterViewController.h"

@interface MEDAppDelegate ()
@property (nonatomic) MEDMasterViewController *masterViewController;
@end

@implementation MEDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.masterViewController = [[MEDMasterViewController alloc] initWithNibName:@"MEDMasterViewController" bundle:nil];
    self.masterViewController.view.frame = ((NSView *)self.window.contentView).bounds;
    [self.window.contentView addSubview:self.masterViewController.view];
}

@end
