//
//  WWHelper.m
//  WhatToEat
//
//  Created by YinShi on 16/11/2.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWHelper.h"

@implementation WWHelper


+(WWHelper *)sharedHelper {
    static dispatch_once_t pred;
    __strong static WWHelper *sharedHelper = nil;
    dispatch_once(&pred, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}


-(NSString *)convertFoodType:(NSNumber *)typeNumber{
    /*
     WWBreakfastFoodTypeStapleFood = 1,  //主食
     WWBreakfastFoodTypeVegetable,       //蔬菜
     WWBreakfastFoodTypeFriut,           //水果
     WWBreakfastFoodTypeMeat = 4,            //肉类
     WWBreakfastFoodTypeDrink,           //汤饮
     WWBreakfastFoodTypeSnack,           //小吃
     
     */
    switch (typeNumber.integerValue) {
        case 1:
            return @"主食";
            break;
        case 2:
            return @"蔬菜";
            break;
        case 3:
            return @"水果";
            break;
        case 4:
            return @"肉类";
            break;
        case 5:
            return @"汤饮";
            break;
        case 6:
            return @"小吃";
            break;
            
        default:
            return @"undefinedFoodType";
            break;
    }

}
@end
