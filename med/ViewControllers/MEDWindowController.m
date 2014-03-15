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

// HTML
@property (nonatomic, copy) NSString *layout;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *body;

@end

@implementation MEDWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Layout of webview
        NSString *path = [[NSBundle mainBundle] pathForResource:@"layout" ofType:@"html"];
        self.layout = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        self.style = @"";
        self.body = @"";
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    MEDConfig *config = [MEDConfig sharedConfig];
    
    self.editor.font = [NSFont fontWithName:config.fontName size:[config.fontSize floatValue]];
    self.webView.frameLoadDelegate = self;
    self.preview = [self.webView mainFrame];
    self.pipeline = [[MEDPipeline alloc] init];
    self.pipeline.delegate = self;
    
    // Enable web inspector
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

- (void)changePreviewStylesheetAtPath:(NSString *)path
{
    self.style = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self loadPreview];
}

#pragma mark - Private methods

- (void)loadPreview
{
    NSString *html = [NSString stringWithFormat:self.layout, self.style, self.body];
    [self.preview loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
}

#pragma mark - NSTextDelegate

- (void)textDidChange:(NSNotification *)notification
{
    NSString *text = ((NSTextView *)notification.object).string;
    ((MEDDocument *) self.document).text = text;
    [self.pipeline runWithInput:text];
}

#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    // Disable horizontal scroll on preview
    NSScrollView *scrollView = sender.mainFrame.frameView.documentView.enclosingScrollView;
    scrollView.horizontalScrollElasticity = NSScrollElasticityNone;
}

#pragma mark - MEDPipelineDelegate

- (void)pipeline:(MEDPipeline *)pipeline didReceiveStandardOutput:(NSString *)standardOutput
{
    self.body = [standardOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self loadPreview];
}

@end
