//
//  AppLocalserver.h
//  DDProjectDylib
//
//  Created by perfay on 2018/9/13.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLocalserver : NSObject

+ (id)getInstance;
+ (id)ActionHander:(id)arg1;
- (void)stop;
- (id)run;

@end
