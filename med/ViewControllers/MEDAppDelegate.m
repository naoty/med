//
//  MEDAppDelegate.m
//  med
//
//  Created by naoty on 2014/03/05.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDAppDelegate.h"
#import "MEDWindowController.h"
#import "MEDConfig.h"

@interface MEDAppDelegate ()
@property (nonatomic) MEDConfig *config;
@property (nonatomic) NSMenu *stylesheetsSubMenu;
@end

@implementation MEDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.config = [MEDConfig sharedConfig];
    [self addStylesheetMenu];
}

#pragma mark - Private methods

- (void)addStylesheetMenu
{
    self.stylesheetsSubMenu = [[NSMenu alloc] init];
    
    // Default stylesheets
    for (NSString *stylesheetPath in self.config.defaultStylesheetPaths) {
        NSString *filename = [stylesheetPath lastPathComponent];
        [self.stylesheetsSubMenu addItemWithTitle:filename action:@selector(didDefaultStylesheetMenuItemSelected:) keyEquivalent:@""];
    }
    
    // User's stylesheets
    if (self.config.userStylesheetPaths.count > 0) {
        [self.stylesheetsSubMenu addItem:[NSMenuItem separatorItem]];
        for (NSString *stylesheetPath in self.config.userStylesheetPaths) {
            NSString *filename = [stylesheetPath lastPathComponent];
            [self.stylesheetsSubMenu addItemWithTitle:filename action:@selector(didStylesheetMenuItemSelected:) keyEquivalent:@""];
        }
    }
    
    self.stylesheetsMenuItem.submenu = self.stylesheetsSubMenu;
}

- (void)didDefaultStylesheetMenuItemSelected:(id)sender
{
    NSMenuItem *selectedMenuItem = (NSMenuItem *) sender;
    NSString *stylesheetPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:selectedMenuItem.title];
    
    NSWindow *mainWindow = [[NSApplication sharedApplication] mainWindow];
    MEDWindowController *windowController = (MEDWindowController *) mainWindow.windowController;
    [windowController changePreviewStylesheetAtPath:stylesheetPath];
}

- (void)didStylesheetMenuItemSelected:(id)sender
{
    NSMenuItem *selectedMenuItem = (NSMenuItem *) sender;
    NSString *stylesheetPath = [[@"~/.med/stylesheets" stringByAppendingPathComponent:selectedMenuItem.title] stringByExpandingTildeInPath];
    
    NSWindow *mainWindow = [[NSApplication sharedApplication] mainWindow];
    MEDWindowController *windowController = (MEDWindowController *) mainWindow.windowController;
    [windowController changePreviewStylesheetAtPath:stylesheetPath];
}

@end
