//
//  NSArray+Expand.h
//  WhatToEat
//
//  Created by YinShi on 16/10/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WWFoodBaseModel.h"


typedef NS_ENUM(NSUInteger, RandomPickOption) {
    Repeatable,     //可重复
    NonRepeatable,  //不可重复
};

@interface NSArray (Expand)


/**
 *    @brief    从源数组中, 随机选择n个对象
 *    @param    count 要选几个元素 
 *    @param    option 是否可重复
 *    @return   随机选择后的数组
 */
-(NSArray*)randomPickObjectsWithCount:(NSInteger)count randomOption:(RandomPickOption)option;


/**
 *    @brief    从纯字符数组中得出拼接好的字符串, eg[@"小李",@"小张"] --> @"小李、小张"
 *    @param    pStr 拼接时,使用的标点, eg.@"、"
 *    @return   拼接好后的字符串
 */
-(NSString*)assembledStringWithPunctuation:(NSString *)pStr;

/**
 *    @brief    将数组中的自定义Class转为NSData,准备存到UD中(注意: 不是自定义的类没必要用此方法)
 *    @return   由NSData元素组成的数组
 */
-(NSArray *)prepareForUserDefaultSaving;

/**
 *    @brief    与上一个方法刚好相逆,从数组中取出NSData,然后还原回自定义类
 *    @return   由自定义类组成的数组
 */
-(NSArray *)unarchiveObjectsFromUD;


//解释数组中种类的0,1,2,3,分别是什么类型, 翻译成中午
-(NSArray *)translateFoodTypeArrayToChinese;


//把元素为WWBreakfastFoodType的数组, 转化为元素为@1,@2的数组
+(instancetype)arrayWithBreakfastFoodTypes:(WWBreakfastFoodType)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

+(instancetype)arrayWithDinnerFoodTypes:(WWDinnerFoodType)firstObj, ... NS_REQUIRES_NIL_TERMINATION;








@end
