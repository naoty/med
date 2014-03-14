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
    NSArray *stylesheetPaths = self.config.stylesheetPaths;
    if (stylesheetPaths.count > 0) {
        NSMenuItem *stylesheetsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Preview Stylesheets" action:nil keyEquivalent:@""];
        self.stylesheetsSubMenu = [[NSMenu alloc] init];
        stylesheetsMenuItem.submenu = self.stylesheetsSubMenu;
        for (NSString *stylesheetPath in stylesheetPaths) {
            NSString *filename = [stylesheetPath lastPathComponent];
            [self.stylesheetsSubMenu addItemWithTitle:filename action:@selector(didStylesheetMenuItemSelected:) keyEquivalent:@""];
        }
        [self.viewMenu insertItem:stylesheetsMenuItem atIndex:0];
        [self.viewMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
    }
}

- (void)didStylesheetMenuItemSelected:(id)sender
{
    NSMenuItem *selectedMenuItem = (NSMenuItem *)sender;
    
    for (NSMenuItem *menuItem in self.stylesheetsSubMenu.itemArray) {
        menuItem.state = (selectedMenuItem == menuItem) ? NSOnState : NSOffState;
    }
    
    NSString *stylesheetPath = [[@"~/.med/stylesheets" stringByAppendingPathComponent:selectedMenuItem.title] stringByExpandingTildeInPath];
    NSWindow *mainWindow = [[NSApplication sharedApplication] mainWindow];
    MEDWindowController *windowController = (MEDWindowController *) mainWindow.windowController;
    [windowController changePreviewStylesheetAtPath:stylesheetPath];
}

@end
