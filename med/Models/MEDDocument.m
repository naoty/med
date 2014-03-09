//
//  MEDDocument.m
//  med
//
//  Created by naoty on 2014/03/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDDocument.h"
#import "MEDWindowController.h"

@implementation MEDDocument

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)makeWindowControllers
{
    MEDWindowController *windowController = [[MEDWindowController alloc] initWithWindowNibName:@"MEDWindow"];
    [self addWindowController:windowController];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
    }
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
    }
    return YES;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
