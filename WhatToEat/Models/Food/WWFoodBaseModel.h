//
//  WWFoodBaseModel.h
//  WhatToEat
//
//  Created by YinShi on 16/10/25.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WWMealType) {   //Food的大类
    WWMealBreakfast,
    WWMealLunch,
    WWMealSupper,
};


/*
 16年10月31:食物类别暂时先定义为单一性的, 即, 一种食物只能属于一种类别, 不可能即是主食, 又是肉类
 */
typedef NS_ENUM(NSUInteger, WWBreakfastFoodType) {   // 食物类型
    WWBreakfastFoodTypeStapleFood = 1,  //主食
    WWBreakfastFoodTypeVegetable,       //蔬菜
    WWBreakfastFoodTypeFriut,           //水果
    WWBreakfastFoodTypeMeat = 4,        //肉类
    WWBreakfastFoodTypeDrink,           //汤饮
    WWBreakfastFoodTypeSnack,           //小吃
};



//和早餐差别在于: 早餐中是"汤饮", 正餐中"汤"和"饮料"是分开的
typedef NS_ENUM(NSUInteger, WWDinnerFoodType) {  //正餐(午餐/晚餐)食物类型
    WWDinnerFoodTypeStapleFood,   //主食
    WWDinnerFoodTypeVegetable,    //素菜
    WWDinnerFoodTypeFriut,        //水果
    WWDinnerFoodTypeMeat,         //肉菜
    WWDinnerFoodTypeSoup,         //汤
    WWDinnerFoodTypeDrink,        //饮料
    WWDinnerFoodTypeSnack,        //小吃
};


 

@interface WWFoodBaseModel : NSObject <NSCoding>

@property(nonatomic,copy)NSString *theFoodName;     //食物真实的名字
@property(nonatomic,copy)NSString *theFoodNickName; //自己起的事物的昵称
@property(nonatomic,strong) UIImage *theFoodImage;
@property(nonatomic) WWMealType theMeal;                //该食物是属于哪顿饭的?

@property(nonatomic,copy) NSArray * foodTypeArray;   //食物类型数组 @{@"小吃",@"肉类"}




@end
