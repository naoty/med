//
//  MEDAppDelegate.m
//  med
//
//  Created by naoty on 2014/03/05.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDAppDelegate.h"
#import "MEDMasterViewController.h"

@implementation MEDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    MEDMasterViewController *masterViewController = [[MEDMasterViewController alloc] initWithNibName:@"MEDMasterViewController" bundle:nil];
    masterViewController.view.frame = ((NSView *)self.window.contentView).bounds;
    [self.window.contentView addSubview:masterViewController.view];
}

@end
