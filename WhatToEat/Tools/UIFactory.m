//
//  UIFactory.m
//  WhatToEat
//
//  Created by YinShi on 16/10/25.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "UIFactory.h"
#import "WWBreakfastFood.h"

@implementation UIFactory

+(NSArray *)makeDefaultBreakfastDataSource{
 
    NSMutableArray *mutArray = [NSMutableArray array];
    
    WWBreakfastFood *theBreakFast0 = [[WWBreakfastFood alloc]init];
    theBreakFast0.theFoodName = @"牛奶";
    theBreakFast0.theFoodImage = [UIImage imageNamed:@"food_milk"];
    theBreakFast0.foodTypeArray = [NSArray arrayWithBreakfastFoodTypes:WWBreakfastFoodTypeDrink,nil];
    [mutArray addObject:theBreakFast0];

    WWBreakfastFood *theBreakFast1 = [[WWBreakfastFood alloc]init];
    theBreakFast1.theFoodName = @"苹果";
    theBreakFast1.theFoodImage = [UIImage imageNamed:@"food_apple"];
    theBreakFast1.foodTypeArray = [NSArray arrayWithBreakfastFoodTypes:WWBreakfastFoodTypeFriut,nil];
    [mutArray addObject:theBreakFast1];

    
    WWBreakfastFood *theBreakFast2 = [[WWBreakfastFood alloc]init];
    theBreakFast2.theFoodName = @"燕麦片";
    theBreakFast2.theFoodImage = [UIImage imageNamed:@"food_ oatmeal"];
    theBreakFast2.foodTypeArray = [NSArray arrayWithBreakfastFoodTypes:WWBreakfastFoodTypeDrink,nil];
    [mutArray addObject:theBreakFast2];

    
    WWBreakfastFood *theBreakFast3 = [[WWBreakfastFood alloc]init];
    theBreakFast3.theFoodName = @"火腿肠";
    theBreakFast3.theFoodImage = [UIImage imageNamed:@"food_squareHam"];
    theBreakFast3.foodTypeArray = [NSArray arrayWithBreakfastFoodTypes:WWBreakfastFoodTypeMeat,WWBreakfastFoodTypeSnack,nil];
    [mutArray addObject:theBreakFast3];

    
    WWBreakfastFood *theBreakFast4 = [[WWBreakfastFood alloc]init];
    theBreakFast4.theFoodName = @"面包";
    theBreakFast4.theFoodImage = [UIImage imageNamed:@""];
    theBreakFast4.foodTypeArray = [NSArray arrayWithBreakfastFoodTypes:WWBreakfastFoodTypeStapleFood,nil];
    [mutArray addObject:theBreakFast4];

    
    WWBreakfastFood *theBreakFast5 = [[WWBreakfastFood alloc]init];
    theBreakFast5.theFoodName = @"生菜";
    theBreakFast5.theFoodImage = [UIImage imageNamed:@""];
    theBreakFast5.foodTypeArray = [NSArray arrayWithBreakfastFoodTypes:WWBreakfastFoodTypeVegetable,nil];
    [mutArray addObject:theBreakFast5];

    
    
    return mutArray.copy;
    
}

-(NSArray *)makeDefaultLauchDataSource{
 
    return nil;
}

-(NSArray *)makeDefaultSupperDataSource{
    return nil;
    
}


@end
