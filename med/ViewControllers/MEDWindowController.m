//
//  MEDWindowController.m
//  med
//
//  Created by naoty on 2014/03/10.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "MEDWindowController.h"
#import "MEDDocument.h"
#import "MEDPipeline.h"
#import "MEDConfig.h"

@interface MEDWindowController () <NSTextDelegate, MEDPipelineDelegate>
@property (nonatomic, weak) IBOutlet WebView *webView;
@property (nonatomic) WebFrame *preview;
@property (nonatomic) MEDPipeline *pipeline;
@end

@implementation MEDWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    MEDConfig *config = [MEDConfig sharedConfig];
    
    self.editor.font = [NSFont fontWithName:config.fontName size:[config.fontSize floatValue]];
    self.preview = [self.webView mainFrame];
    self.pipeline = [[MEDPipeline alloc] init];
    self.pipeline.delegate = self;
    
    MEDDocument *document = (MEDDocument *)self.document;
    if (document.text != nil) {
        self.editor.string = ((MEDDocument *)self.document).text;
        [self.pipeline runWithInput:self.editor.string];
    }
}

- (void)showWindow:(id)sender
{
    [self.window makeKeyAndOrderFront:sender];
}

#pragma mark - NSTextDelegate

- (void)textDidChange:(NSNotification *)notification
{
    NSString *text = ((NSTextView *)notification.object).string;
    ((MEDDocument *)self.document).text = text;
    [self.pipeline runWithInput:text];
}

#pragma mark - MEDPipelineDelegate

- (void)pipeline:(MEDPipeline *)pipeline didReceiveStandardOutput:(NSString *)standardOutput
{
    [self.preview loadHTMLString:standardOutput baseURL:nil];
}

@end