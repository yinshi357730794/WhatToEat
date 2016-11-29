//
//  UIFactory.h
//  WhatToEat
//
//  Created by YinShi on 16/10/25.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFactory : NSObject

+(NSArray *)makeDefaultBreakfastDataSource;
-(NSArray *)makeDefaultLauchDataSource;
-(NSArray *)makeDefaultSupperDataSource;

@end
