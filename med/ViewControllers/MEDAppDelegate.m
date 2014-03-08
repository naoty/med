//
//  MEDAppDelegate.m
//  med
//
//  Created by naoty on 2014/03/05.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDAppDelegate.h"
#import "MEDMasterViewController.h"
#import "MEDConfig.h"

@interface MEDAppDelegate ()
@property (nonatomic) MEDMasterViewController *masterViewController;
@end

@implementation MEDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self loadConfig];
    
    self.masterViewController = [[MEDMasterViewController alloc] initWithNibName:@"MEDMasterViewController" bundle:nil];
    self.masterViewController.view.frame = ((NSView *)self.window.contentView).bounds;
    [self.window.contentView addSubview:self.masterViewController.view];
}

#pragma mark - Private methods

- (void)loadConfig
{
    MEDConfig *config = [MEDConfig sharedConfig];
    
    // Default config
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundledConfigPath = [bundle pathForResource:@"med" ofType:@"json"];
    [config loadWithContentOfFile:bundledConfigPath];
    
    // User's config
    NSString *userConfigPath = [@"~/.med.json" stringByExpandingTildeInPath];
    [config loadWithContentOfFile:userConfigPath];
}

@end
