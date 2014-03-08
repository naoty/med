//
//  MEDMasterViewController.m
//  med
//
//  Created by naoty on 2014/03/05.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "MEDMasterViewController.h"
#import "MEDPipeline.h"
#import "MEDConfig.h"

@interface MEDMasterViewController () <NSTextDelegate, MEDPipelineDelegate>
@property (nonatomic) IBOutlet NSTextView *editor;
@property (nonatomic, weak) IBOutlet WebView *webView;
@property (nonatomic) WebFrame *preview;
@property (nonatomic) MEDPipeline *pipeline;
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
    
    MEDConfig *config = [MEDConfig sharedConfig];
    
    self.editor.font = [NSFont fontWithName:config.fontName size:[config.fontSize floatValue]];
    self.preview = [self.webView mainFrame];
    
    self.pipeline = [[MEDPipeline alloc] init];
    self.pipeline.delegate = self;
}

#pragma mark - NSTextDelegate

- (void)textDidChange:(NSNotification *)notification
{
    NSString *text = ((NSTextView *)notification.object).string;
    [self.pipeline runWithInput:text];
}

#pragma mark - MEDPipelineDelegate

- (void)pipeline:(MEDPipeline *)pipeline didReceiveStandardOutput:(NSString *)standardOutput
{
    [self.preview loadHTMLString:standardOutput baseURL:nil];
}

@end
