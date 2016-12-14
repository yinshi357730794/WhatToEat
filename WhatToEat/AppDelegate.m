//
//  AppDelegate.m
//  WhatToEat
//
//  Created by YinShi on 16/10/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "AppDelegate.h"

#import "UIFactory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //正式调教: !CRUserObj(@"firstTimeLauch")
    if (1) {
        CRUserSetObj(@"1", @"firstTimeLauch");
        NSArray *foodList1 = [[UIFactory makeDefaultBreakfastDataSource] prepareForUserDefaultSaving];
        NSMutableArray *foodList2 = [NSMutableArray arrayWithObjects:@"红烧肉",@"米饭",@"小白菜", nil];
        NSMutableArray *foodList3 = [NSMutableArray arrayWithObjects:@"粥",@"玉米",@"水果拼盘", nil];
        
        CRUserSetObj(foodList1, @"UDBreakfast");
        CRUserSetObj(foodList2, @"UDLunch");
        CRUserSetObj(foodList3, @"UDSupper");
        
        //定义默认的早餐(meal)结构
        //@{@"type":@0,@"count":@1}表示: "类型"是:主食, 然后下面有1个子元素
        NSArray *defaultMealStucture1 =  [NSArray arrayWithObjects:
                                          @{@"type":@1,@"count":@1},
                                          @{@"type":@2,@"count":@1},
                                          @{@"type":@3,@"count":@1},
                                          @{@"type":@4,@"count":@1},nil];
        CRUserSetObj(defaultMealStucture1, @"UDDefaultBreakfastStucture");
        
        NSArray *defaultMealStucture2 =   [NSArray arrayWithObjects:
                                           @{@"type":@1,@"count":@1},
                                           @{@"type":@2,@"count":@1},
                                           @{@"type":@3,@"count":@1},
                                           @{@"type":@4,@"count":@1},nil];
        CRUserSetObj(defaultMealStucture2, @"UDDefaultLunchStucture");
        
        NSArray *defaultMealStucture3 =   [NSArray arrayWithObjects:
                                           @{@"type":@1,@"count":@1},
                                           @{@"type":@2,@"count":@1},
                                           @{@"type":@3,@"count":@1},
                                           @{@"type":@4,@"count":@1},nil];
        CRUserSetObj(defaultMealStucture3, @"UDDefaultSupperStucture");
        
        
        
        //设置:默认的大图模式
        CRUserSetBOOL(YES, @"UDFavouriteListMode");
        
        
        
    }
    //扫描所有媒体资料库
    [AppManager QueryAllMusic];

    NSNumber *playMode = CRUserObj(@"UDPlayMode");
    if (playMode) {
        MusicHelper.thePlayMode = playMode.integerValue;

    }else{
        //如果没有设置, 默认为1, 即:单曲循环
        MusicHelper.thePlayMode = PlayMode_Single;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
