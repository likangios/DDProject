//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  DDProjectDylib.m
//  DDProjectDylib
//
//  Created by perfay on 2018/9/6.
//  Copyright (c) 2018年 luck. All rights reserved.
//

#import "DDProjectDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>

CHConstructor{
    NSLog(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);

        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}


CHDeclareClass(CustomViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
    NSLog(@"This is a new method : %@", output);
}

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
    NSLog(@"hook class method");
    CHSuper0(CustomViewController, classMethod);
}

CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    [self newMethod:@"output"];
    
    //set new property
    self.newProperty = @"newProperty";
    
    NSLog(@"newProperty : %@", self.newProperty);
    
    //change the value
    return @"perfay";
    
}

//add new property
CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook0(CustomViewController, getMyName);
    CHClassHook0(CustomViewController, classMethod);
    
    CHHook0(CustomViewController, newProperty);
    CHHook1(CustomViewController, setNewProperty);
}

CHDeclareClass(AppLocalserver)
CHOptimizedClassMethod1(self, id, AppLocalserver, ActionHander,NSDictionary *,arg1){
    NSLog(@"收到的数据=======%@",arg1);
    NSString *pkg = arg1[@"pkg"];
    NSString *tid = arg1[@"tid"];
    NSString *a = arg1[@"a"];

    if (pkg && tid && a){
        [[NSUserDefaults standardUserDefaults] setValue:pkg forKey:@"pkg"];
        [[NSUserDefaults standardUserDefaults] setValue:tid forKey:@"tid"];
        [[NSUserDefaults standardUserDefaults] setValue:a forKey:@"a"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
   NSString *value =  CHSuper1(AppLocalserver, ActionHander,arg1);
    NSLog(@"返回的数据=======%@",value);
    return  value;
}
CHConstructor{
    CHLoadLateClass(AppLocalserver);
    CHClassHook1(AppLocalserver, ActionHander);
}

CHDeclareClass(AppDelegate)

CHOptimizedMethod0(self, void, AppDelegate, goInit){
     CHSuper0(AppDelegate, goInit);
}
CHConstructor{
    CHLoadLateClass(AppDelegate);
    CHClassHook0(AppDelegate, goInit);
}


CHDeclareClass(AppSettingViewController)

CHOptimizedMethod0(self, void, AppSettingViewController, remoteControlReceivedWithEvent){
    CHSuper0(AppSettingViewController, remoteControlReceivedWithEvent);
}
CHConstructor{
    CHLoadLateClass(AppSettingViewController);
    CHClassHook0(AppSettingViewController, remoteControlReceivedWithEvent);
}

CHDeclareClass(TestMusicPlayer)
CHOptimizedMethod0(self, void, TestMusicPlayer, play){
    CHSuper0(TestMusicPlayer, play);
}
CHConstructor{
    CHLoadLateClass(TestMusicPlayer);
    CHClassHook0(TestMusicPlayer, play);
}

CHDeclareClass(URLHandler)
CHOptimizedMethod1(self, void, URLHandler, handleURL,id ,arg1){
    CHSuper1(URLHandler, handleURL,arg1);
}
CHConstructor{
    CHLoadLateClass(URLHandler);
    CHClassHook1(URLHandler, handleURL);
}


CHDeclareClass(CommonFunc)
CHOptimizedClassMethod1(self, id, CommonFunc, submitNew,id ,arg1){
  id obj =  CHSuper1(CommonFunc, submitNew,arg1);
return  obj;
}
CHConstructor{
    CHLoadLateClass(CommonFunc);
    CHClassHook1(CommonFunc,submitNew);
}

CHDeclareClass(NetUtils)
CHOptimizedClassMethod1(self, id, NetUtils, getURLContent,id ,arg1){
    id obj =  CHSuper1(NetUtils, getURLContent,arg1);
    return  obj;
}
CHConstructor{
    CHLoadLateClass(NetUtils);
    CHClassHook1(NetUtils,getURLContent);
}
///
CHDeclareClass(AppUtil)

CHOptimizedClassMethod0(self, id, AppUtil, StoreIDFA){
    id obj =  CHSuper0(AppUtil, StoreIDFA);
    return  obj;
}

CHOptimizedClassMethod0(self, id, AppUtil, OS){
    id obj =  CHSuper0(AppUtil, OS);
    return  obj;
}
CHOptimizedClassMethod0(self, id, AppUtil, GetList){
    NSMutableArray *obj =  CHSuper0(AppUtil, GetList);
//    com.youguoshu.shidexian
    NSString *test = [[NSUserDefaults standardUserDefaults] valueForKey:@"pkg"];
    
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"a"];
    if ([a isEqualToString:@"aclimit"]){
        if (test && [obj containsObject:test]){
            [obj removeObject:test];
        }
    }
    else{
        if (test && ![obj containsObject:test]){
            [obj addObject:test];
        }
    }

    return  obj;
}
CHOptimizedClassMethod1(self, BOOL, AppUtil, playAudio,NSString*,arg1){
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"a"];
    if ([a isEqualToString:@"play"]){
        return YES;
    }
    else{
        BOOL obj =  CHSuper1(AppUtil, playAudio,arg1);
        return  obj;
    }
}

CHOptimizedClassMethod1(self, BOOL, AppUtil, check,NSString*,arg1){
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"a"];
    if ([a isEqualToString:@"play"]){
        return YES;
    }
    
    if ([a isEqualToString:@"aclimit"]){
        return NO;
    }
    BOOL obj =  CHSuper1(AppUtil, check,arg1);
    return  obj;

}
CHConstructor{
    CHLoadLateClass(AppUtil);
    CHClassHook0(AppUtil,StoreIDFA);
    CHClassHook0(AppUtil,OS);
    CHClassHook0(AppUtil,GetList);
    CHClassHook1(AppUtil,check);
    CHClassHook1(AppUtil,playAudio);
}

CHDeclareClass(AppCFG)
CHOptimizedClassMethod1(self, id, AppCFG, getValue,id ,arg1){
    id obj =  CHSuper1(AppCFG, getValue,arg1);
    return  obj;
}
CHConstructor{
    CHLoadLateClass(AppCFG);
    CHClassHook1(AppCFG,getValue);
}


CHDeclareClass(NSString)
CHOptimizedMethod1(self, id, NSString, dataUsingEncoding,NSUInteger ,arg1){
    NSLog(@"dataUsingEncoding========%@",self);
    id obj =  CHSuper1(NSString, dataUsingEncoding,arg1);
    return obj;
}
CHConstructor{
    CHLoadLateClass(NSString);
    CHClassHook1(NSString, dataUsingEncoding);
}










