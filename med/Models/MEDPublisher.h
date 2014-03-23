//
//  MEDPublisher.h
//  med
//
//  Created by naoty on 2014/03/24.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEDPublisher : NSObject
- (id)initWithName:(NSString *)name;
- (void)runWithFilename:(NSString *)filename standardInput:(NSString *)standardInput;
@end
