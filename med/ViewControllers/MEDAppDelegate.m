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
#import "MEDPublisher.h"
#import "MEDDocument.h"

@interface MEDAppDelegate ()
@property (nonatomic) MEDConfig *config;
@property (nonatomic) NSMenu *stylesheetsSubMenu;
@property (nonatomic, readonly) MEDWindowController *mainWindowController;
@end

@implementation MEDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.config = [MEDConfig sharedConfig];
    [self addStylesheetMenu];
    [self addPublishersMenu];
}

- (void)addStylesheetMenu
{
    self.stylesheetsSubMenu = [NSMenu new];
    
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

- (void)addPublishersMenu
{
    if (self.config.markdownPublishers.count > 0) {
        NSMenu *markdownPublishersSubMenu = [NSMenu new];
        for (NSString *filename in self.config.markdownPublishers) {
            [markdownPublishersSubMenu addItemWithTitle:filename action:@selector(didMarkdownPublisherMenuItemSelected:) keyEquivalent:@""];
        }
        self.markdownPublishersMenuItem.submenu = markdownPublishersSubMenu;
    }
    
    if (self.config.htmlPublishers.count > 0) {
        NSMenu *htmlPublishersSubMenu = [NSMenu new];
        for (NSString *filename in self.config.htmlPublishers) {
            [htmlPublishersSubMenu addItemWithTitle:filename action:@selector(didHTMLPublisherMenuItemSelected:) keyEquivalent:@""];
        }
        self.htmlPublishersMenuItem.submenu = htmlPublishersSubMenu;
    }
}

#pragma mark - Selectors

- (void)didDefaultStylesheetMenuItemSelected:(id)sender
{
    NSMenuItem *selectedMenuItem = (NSMenuItem *) sender;
    NSString *stylesheetPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:selectedMenuItem.title];
    [[self mainWindowController] changePreviewStylesheetAtPath:stylesheetPath];
}

- (void)didStylesheetMenuItemSelected:(id)sender
{
    NSMenuItem *selectedMenuItem = (NSMenuItem *) sender;
    NSString *stylesheetPath = [[@"~/.med/stylesheets" stringByAppendingPathComponent:selectedMenuItem.title] stringByExpandingTildeInPath];
    [[self mainWindowController] changePreviewStylesheetAtPath:stylesheetPath];
}

- (void)didMarkdownPublisherMenuItemSelected:(id)sender
{
    NSMenuItem *selectedMenuItem = (NSMenuItem *) sender;
    MEDPublisher *publisher = [[MEDPublisher alloc] initWithName:selectedMenuItem.title];
    [self.mainWindowController runMarkdownPublisher:publisher];
}

- (void)didHTMLPublisherMenuItemSelected:(id)sender
{
    NSMenuItem *selectedMenuItem = (NSMenuItem *) sender;
    MEDPublisher *publisher = [[MEDPublisher alloc] initWithName:selectedMenuItem.title];
    [self.mainWindowController runHTMLPublisher:publisher];
}

#pragma mark - Private methods

- (MEDWindowController *)mainWindowController
{
    NSWindow *mainWindow = [[NSApplication sharedApplication] mainWindow];
    return (MEDWindowController *) mainWindow.windowController;
}

@end
