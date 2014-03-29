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
#import "NTYSmartTextView.h"

@interface MEDWindowController () <NSTextDelegate, MEDPipelineDelegate>

@property (nonatomic) MEDPipeline *pipeline;
@property (nonatomic, weak) IBOutlet WebView *webView;
@property (nonatomic) WebFrame *preview;
@property (nonatomic, weak) IBOutlet NSTextField *footerTextField;

// Use to restore scroll position after reloading
@property (nonatomic) CGPoint savedPreviewScrollPosition;

// HTML
@property (nonatomic, copy) NSString *layout;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *body;

// Temporary memory for publisher
@property (nonatomic) MEDPublisher *publisher;

@end

@implementation MEDWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSString *layoutPath = [[NSBundle mainBundle] pathForResource:@"layout" ofType:@"html"];
        self.layout = [NSString stringWithContentsOfFile:layoutPath encoding:NSUTF8StringEncoding error:nil];
        
        MEDConfig *config = [MEDConfig sharedConfig];
        NSString *stylesheetPath = config.defaultStylesheetPaths[0];
        self.style = [NSString stringWithContentsOfFile:stylesheetPath encoding:NSUTF8StringEncoding error:nil];
        
        self.body = @"";
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    MEDConfig *config = [MEDConfig sharedConfig];
    
    self.editor.font = [NSFont fontWithName:config.fontName size:[config.fontSize floatValue]];
    self.editor.automaticQuoteSubstitutionEnabled = NO;
    self.editor.automaticDashSubstitutionEnabled = NO;
    self.editor.textContainerInset = NSMakeSize(config.padding.floatValue, config.padding.floatValue);
    self.editor.smartIndentEnabled = config.smartIndentEnabled;
    self.editor.softTabEnabled = config.softTabEnabled;
    self.editor.tabWidth = [config.tabWidth intValue];
    self.editor.autoPairCompletionEnabled = config.autoPairCompletionEnabled;
    
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

- (void)runMarkdownPublisher:(MEDPublisher *)publisher
{
    [self runPublisher:publisher standardInput:_editor.string];
}

- (void)runHTMLPublisher:(MEDPublisher *)publisher
{
    [self runPublisher:publisher standardInput:_body];
}

#pragma mark - Private methods

- (void)loadPreview
{
    NSString *html = [NSString stringWithFormat:_layout, _style, _body];
    [self rememberPreviewScrollPosition];
    [self.preview loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
}

- (void)rememberPreviewScrollPosition
{
    NSScrollView *scrollView = self.preview.frameView.documentView.enclosingScrollView;
    if (scrollView) {
        NSRect currentRect = scrollView.documentVisibleRect;
        if (currentRect.origin.y > 0) {
            self.savedPreviewScrollPosition = currentRect.origin;
        } else {
            self.savedPreviewScrollPosition = NSZeroPoint;
        }
    }
}

- (void)runPublisher:(MEDPublisher *)publisher standardInput:(NSString *)standardInput
{
    self.publisher = publisher;
    
    _publisher.delegate = self;
    
    MEDDocument *document = self.document;
    if (document.isDocumentEdited) {
        _publisher.standardInput = standardInput;
        [document saveDocumentWithDelegate:self didSaveSelector:@selector(document:didSave:contextInfo:) contextInfo:nil];
    } else {
        NSString *filename = document.fileURL.lastPathComponent.stringByDeletingPathExtension;
        [_publisher runWithFilename:filename standardInput:standardInput];
    }
}

- (void)document:(NSDocument *)document didSave:(BOOL)didSave contextInfo:(void *)contextInfo
{
    NSString *filename = document.fileURL.lastPathComponent.stringByDeletingPathExtension;
    [_publisher runWithFilename:filename];
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
    [self.preview.frameView.documentView scrollPoint:NSMakePoint(0, _savedPreviewScrollPosition.y)];
    self.savedPreviewScrollPosition = NSZeroPoint;
}

#pragma mark - MEDPipelineDelegate

- (void)pipeline:(MEDPipeline *)pipeline didReceiveStandardOutput:(NSString *)standardOutput time:(NSTimeInterval)time
{
    self.body = [standardOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self loadPreview];
    _footerTextField.textColor = [NSColor controlTextColor];
    _footerTextField.stringValue = [NSString stringWithFormat:@"%.2fms", time * 1000];
}

- (void)pipeline:(MEDPipeline *)pipeline didReceiveStandardError:(NSString *)standardError time:(NSTimeInterval)time
{
    if (![standardError isEqualToString:@""]) {
        _footerTextField.textColor = [NSColor redColor];
        _footerTextField.stringValue = [standardError stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

#pragma mark - MEDPublisherDelegate

- (void)publisher:(MEDPublisher *)publisher didReceiveStandardOutput:(NSString *)standardOutput time:(NSTimeInterval)time
{
    if (![standardOutput isEqualToString:@""]) {
        NSString *message = [standardOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _footerTextField.stringValue = [NSString stringWithFormat:@"%@ [%.2fms]", message, time * 1000];
    }
}

- (void)publisher:(MEDPublisher *)publisher didReceiveStandardError:(NSString *)standardError time:(NSTimeInterval)time
{
    if (![standardError isEqualToString:@""]) {
        NSString *message = [standardError stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _footerTextField.stringValue = [NSString stringWithFormat:@"%@ [%.2fms]", message, time * 1000];
    }
}

@end
