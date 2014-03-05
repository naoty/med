//
//  MEDMasterViewController.m
//  med
//
//  Created by naoty on 2014/03/05.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "MEDMasterViewController.h"

@interface MEDMasterViewController () <NSTextDelegate>
@property (nonatomic) IBOutlet NSTextView *editor;
@property (nonatomic, weak) IBOutlet WebView *webView;
@property (nonatomic) WebFrame *preview;
@end

@implementation MEDMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.editor.font = [NSFont fontWithName:@"Monaco" size:12.0f];
    self.preview = [self.webView mainFrame];
}

#pragma mark - NSTextDelegate

- (void)textDidChange:(NSNotification *)notification
{
    NSString *text = ((NSTextView *)notification.object).string;
    [self.preview loadHTMLString:text baseURL:nil];
}

@end
