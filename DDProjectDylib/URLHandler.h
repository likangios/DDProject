//
//  URLHandler.h
//  DDProjectDylib
//
//  Created by perfay on 2018/9/13.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLHandler : NSObject
+ (id)getInstance;
- (void)handleURL:(NSURL *)arg1;
@end
