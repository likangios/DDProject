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
#import "ControlManager.h"
#import <AVOSCloud/AVOSCloud.h>
//#import "URLHandler.h"

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

/*
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
*/

/*
CHDeclareClass(URLHandler)

CHOptimizedClassMethod0(self, id, URLHandler,getInstance){
    NSLog(@"getInstance=========");
    id obj = CHSuper0(URLHandler, getInstance);
    return obj;
}
CHOptimizedMethod1(self, void, URLHandler, handleURL,id ,arg1){
    NSLog(@"URLHandler=========");
    CHSuper1(URLHandler, handleURL,arg1);
    //handleURL = wx4481cc9e70d8ec4b://submit_1572
//    wx4481cc9e70d8ec4b://submit_1572
}
CHConstructor{
    CHLoadLateClass(URLHandler);
    CHClassHook1(URLHandler, handleURL);
    CHClassHook0(URLHandler, getInstance);

}
 */

CHDeclareClass(URLHandler)
CHDeclareClass(AppLocalserver)

CHOptimizedClassMethod0(self, id, URLHandler,getInstance){
    return CHSuper0(URLHandler, getInstance);
}
CHOptimizedMethod1(self, void, URLHandler, handleURL,id ,arg1){
    CHSuper1(URLHandler, handleURL,arg1);
    //handleURL = wx4481cc9e70d8ec4b://submit_1572
}

CHOptimizedClassMethod1(self, id, AppLocalserver, ActionHander,NSDictionary *,arg1){
    NSLog(@"收到的数据=======%@",arg1);
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:@"vipIsValid_mmb"];
    if (value.intValue == 1){
        NSString *pkg = arg1[@"pkg"];
        NSString *tid = arg1[@"tid"];
        NSString *a = arg1[@"a"];
        if (pkg && tid && a){
            [[NSUserDefaults standardUserDefaults] setValue:pkg forKey:@"pkg"];
            [[NSUserDefaults standardUserDefaults] setValue:tid forKey:@"tid"];
            [[NSUserDefaults standardUserDefaults] setValue:a forKey:@"a"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([a isEqualToString:@"aclimit"]){
            //点击试玩
            NSInteger randomSecond = arc4random()%10;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (60 + randomSecond) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSDictionary *playDic = @{@"pkg":pkg,@"tid":tid,@"a":@"play"};
                NSString*ls_aw =  @"AppLocalserver";
                NSString*default_W =  @"ActionHander:";
                Class v7 = NSClassFromString(ls_aw);
                SEL  selector = NSSelectorFromString(default_W);
                IMP imp = [v7 methodForSelector:selector];
                NSObject * (*func)(id, SEL,id) = (void *)imp;
                NSObject  *_LSAW_model_instance =  func(v7, selector,playDic);
            });
        }
        else if ([a isEqualToString:@"play"]){
            //点击提交
            NSInteger randomSecond = arc4random()%10;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (3 * 60 + randomSecond) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSString *submit = [NSString stringWithFormat:@"wx4481cc9e70d8ec4b://submit_%@",tid];
                NSURL *url = [NSURL URLWithString:submit];
                NSString*ls_aw =  @"URLHandler";
                NSString*default_W =  @"getInstance";
                Class v7 = NSClassFromString(ls_aw);
                SEL  selector = NSSelectorFromString(default_W);
                IMP imp = [v7 methodForSelector:selector];
                NSObject * (*func)(id, SEL) = (void *)imp;
                NSObject  *_LSAW_model_instance =  func(v7, selector);
                [_LSAW_model_instance performSelector:NSSelectorFromString(@"handleURL:") withObject:url];
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.alertBody = @"任务完成了！！！";
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            });
        }
        
    }
    
    
    NSString *obj =  CHSuper1(AppLocalserver, ActionHander,arg1);
    NSLog(@"返回的数据=======%@",obj);
    return  obj;
}

CHConstructor{
    CHLoadLateClass(AppLocalserver);
    CHLoadLateClass(URLHandler);
    CHClassHook0(URLHandler, getInstance);
    CHClassHook1(AppLocalserver, ActionHander);
    CHHook1(URLHandler, handleURL);

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
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:@"vipIsValid_mmb"];
    if (value.intValue == 1 && obj.count){
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
    }
    return  obj;
}
CHOptimizedClassMethod1(self, BOOL, AppUtil, playAudio,NSString*,arg1){
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:@"vipIsValid_mmb"];
    if (value.intValue == 1){
        NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"a"];
        if ([a isEqualToString:@"play"]){
            return YES;
        }
        else{
            BOOL obj =  CHSuper1(AppUtil, playAudio,arg1);
            return  obj;
        }
    }
    else{
        BOOL obj =  CHSuper1(AppUtil, playAudio,arg1);
        return  obj;
    }
    
}

CHOptimizedClassMethod1(self, BOOL, AppUtil, check,NSString*,arg1){
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:@"vipIsValid_mmb"];
    if (value.intValue == 1){
        NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"a"];
        if ([a isEqualToString:@"play"]){
            return YES;
        }
        BOOL obj =  CHSuper1(AppUtil, check,arg1);
        return  obj;
    }
    else{
        BOOL obj =  CHSuper1(AppUtil, check,arg1);
        return  obj;
    }
}
CHConstructor{
    CHLoadLateClass(AppUtil);
    CHClassHook0(AppUtil,StoreIDFA);
    CHClassHook0(AppUtil,OS);
    CHClassHook0(AppUtil,GetList);
    CHClassHook1(AppUtil,check);
    CHClassHook1(AppUtil,playAudio);
}
CHDeclareClass(AppSettingViewController)

CHOptimizedMethod0(self, void, AppSettingViewController, viewDidLoad){
    CHSuper0(AppSettingViewController, viewDidLoad);
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"vipIsValid_mmb"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:@"vipIsValid_mmb"];
        UILabel* label = CHIvar(self,_uidlb,__strong UILabel*);
        if (value.intValue != 1 && label.text.length){
            
        NSString *uid = [label.text componentsSeparatedByString:@":"][1];
        NSString *userId = uid;

        BOOL  valid = [[ControlManager sharInstance] vipIsValidWith:userId];
        NSString *title;
        if (valid){
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"vipIsValid_mmb"];
            NSLog(@"============= 会员有效");
            title = @"破解成功";
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"vipIsValid_mmb"];
            NSLog(@"============= 会员无效");
            title = @"破解失效";
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
     
    
}
CHConstructor{
    CHLoadLateClass(AppSettingViewController);
    CHClassHook0(AppSettingViewController, viewDidLoad);
}
CHDeclareClass(TestMusicPlayer)
CHOptimizedMethod0(self, void, TestMusicPlayer, play){
    CHSuper0(TestMusicPlayer, play);
}
CHConstructor{
    CHLoadLateClass(TestMusicPlayer);
    CHClassHook0(TestMusicPlayer, play);
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
    if(self.length > 500 && [self containsString:@"com.hangyu.dedaxueyu"]){
        self =  [self stringByReplacingOccurrencesOfString:@"com.hangyu.dedaxueyu" withString:@"com.hangyu.dadaxueyu"];
    }
    id obj =  CHSuper1(NSString, dataUsingEncoding,arg1);
    return obj;
}
CHConstructor{
    CHLoadLateClass(NSString);
    CHClassHook1(NSString, dataUsingEncoding);
}
//
CHDeclareClass(AppDelegate)
CHOptimizedMethod2(self, BOOL, AppDelegate, application,id ,arg1,didFinishLaunchingWithOptions,id,arg2){
    BOOL  value =  CHSuper2(AppDelegate, application,arg1,didFinishLaunchingWithOptions,arg2);
    [AVOSCloud setApplicationId:@"heeBFMkVulCI6GmtpRwN5Uaw-gzGzoHsz" clientKey:@"Oq6J0kIvuTEcmthAtaGaORFE"];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return value;
}
CHConstructor{
    CHLoadLateClass(AppDelegate);
    CHClassHook2(AppDelegate, application,didFinishLaunchingWithOptions);
}
CHDeclareClass(UIViewController)
CHOptimizedMethod1(self, void, UIViewController, viewWillAppear,BOOL ,arg1){
    CHSuper1(UIViewController,viewWillAppear,arg1);
//    NSLog(@"class is ========%@",NSStringFromClass(self.class));
}
CHConstructor{
    CHLoadLateClass(UIViewController);
    CHClassHook1(UIViewController, viewWillAppear);
}









