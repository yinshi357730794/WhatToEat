//
//  WWMealModel.h
//  WhatToEat
//
//  Created by YinShi on 16/10/28.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWMealModel : NSObject   //食物组合模型

@property(nonatomic,copy) NSArray *theMealStructureArray;   //自定义的早/午/晚餐结构
@property(nonatomic) NSString *theMealSetName;              //(早/午/晚餐)食物组合名称: 四菜一汤
@property(nonatomic) NSString *theMealSetNickName;          //用户自定义的食物组合别名: 石头的最爱


@end
