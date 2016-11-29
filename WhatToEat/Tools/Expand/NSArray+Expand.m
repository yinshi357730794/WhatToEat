//
//  NSArray+Expand.m
//  WhatToEat
//
//  Created by YinShi on 16/10/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "NSArray+Expand.h"


@implementation NSArray (Expand)

/**
 *    @brief    从源数组中, 随机选择n个对象
 *    @param    count 要选几个元素 option:是否可重复
 *    @return   随机选择后的数组
 */
-(NSArray*)randomPickObjectsWithCount:(NSInteger)count randomOption:(RandomPickOption)option{
    if (self.count == 0) {
        return nil;
    }
    
    if (self.count == count) {
        return self;    //如果要选的个数和自身个数相等, 那直接返回自己
    }
    
    if (option == Repeatable) {
        //1.随机选择可重复元素
        
        return nil;
        
    } else {
        //2.随机选择不可重复元素
        
        //随机数从这里边产生
        NSMutableArray *startArray;
        if ([self isMemberOfClass:[NSMutableArray class]]) {
            startArray = self.mutableCopy;
        } else {
            startArray = [NSMutableArray arrayWithArray: self];
        }
        //随机数产生结果
        NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
        //随机数个数
        NSInteger m = count;
        for (NSInteger i=0; i < m; i++) {
            //TODO:为什么self有1个元素, 但是startArray却是0个元素?
            NSInteger t = arc4random() % startArray.count;
            resultArray[i]=startArray[t];
            startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
            [startArray removeLastObject];
        }
        return resultArray;
        
    }
    
}

-(NSString *)assembledStringWithPunctuation:(NSString *)pStr{

    NSString *finalString = [NSString string];
    
    for (NSInteger i = 0 ;  i < self.count; i ++) {
        id obj = self[i];
        
        if (![obj isKindOfClass:[NSString class]]) {    //如果数组中有不是String, 先跳过
            continue;
        }
        NSString *substring = self[i];
        finalString = [finalString stringByAppendingString:[substring stringByAppendingString:pStr]];
        
    }
    return finalString;
    
}


-(NSArray *)prepareForUserDefaultSaving{
    //将自定义Class转成NSData,再存入UD中
    NSMutableArray *arr_data = [NSMutableArray array];

    for (NSInteger i = 0 ;  i < self.count;  i++) {
    
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self[i]];
            [arr_data addObject:data];
        
    }
    return arr_data.copy;
    
}

-(NSArray *)unarchiveObjectsFromUD{
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSInteger i = 0 ;  i < self.count;  i++) {
        id obj = [NSKeyedUnarchiver unarchiveObjectWithData:self[i]];
        [mutArr addObject:obj];
    }
    return mutArr.copy;
    
}


-(NSArray *)translateFoodTypeArrayToChinese{
    
    /*
     WWBreakfastFoodTypeStapleFood = 0,   //主食
     WWBreakfastFoodTypeVegetable,    //蔬菜
     WWBreakfastFoodTypeFriut,        //水果
     WWBreakfastFoodTypeMeat,         //肉类
     WWBreakfastFoodTypeSoup,         //汤
     WWBreakfastFoodTypeDrink,        //饮料
     WWBreakfastFoodTypeSnack,        //小吃

     */
    NSMutableArray * finalArray = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < self.count; i ++) {
        if (![self[i] isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        NSDictionary *dict = self[i];
        //把dict的allKeys拍一下序,因为是乱序的, 先按照0,1,2,3,从小到大排
        NSArray *allKeysArray = dict.allKeys;
        
        NSNumber *typeNumber =  dict[@"type"];
        switch (typeNumber.integerValue) {
            case 1:
                [finalArray addObject:@"主食"];
                break;
            case 2:
                [finalArray addObject:@"蔬菜"];
                break;
            case 3:
                [finalArray addObject:@"水果"];
                break;
            case 4:
                [finalArray addObject:@"肉类"];
                break;
            case 5:
                [finalArray addObject:@"汤"];
                break;
            case 6:
                [finalArray addObject:@"饮料"];
                break;
            case 7:
                [finalArray addObject:@"小吃"];
                break;

            default:
                break;
        }
    }
    
    return finalArray.copy;
}



+(instancetype)arrayWithBreakfastFoodTypes:(WWBreakfastFoodType)firstObj, ...{
    
    NSMutableArray * finalArr = [NSMutableArray array];
    
    
    va_list argList;  //定义一个 va_list 指针来访问参数表
    va_start(argList, firstObj);  //初始化 va_list，让它指向第一个变参(firstObj) 这里是第一个参数
    if(firstObj){
        switch (firstObj) {
             case 1:
                [finalArr addObject:@1];
                break;
            case 2:
                [finalArr addObject:@2];
                break;
            case 3:
                [finalArr addObject:@3];
                break;
            case 4:
                [finalArr addObject:@4];
                break;
            case 5:
                [finalArr addObject:@5];
                break;
            case 6:
                [finalArr addObject:@6];
                break;
  
            default:
                break;
        }

        
        WWBreakfastFoodType otherObject;
        while ((otherObject = va_arg(argList, WWBreakfastFoodType))) {
            //调用 va_arg 依次取出 参数，它会自带指向下一个参数
            
            switch (otherObject) {
                case 1:
                    [finalArr addObject:@1];
                    break;
                case 2:
                    [finalArr addObject:@2];
                    break;
                case 3:
                    [finalArr addObject:@3];
                    break;
                case 4:
                    [finalArr addObject:@4];
                    break;
                case 5:
                    [finalArr addObject:@5];
                    break;
                case 6:
                    [finalArr addObject:@6];
                    break;
  
                default:
                    break;
            }
            
        }
        va_end(argList); // 收尾，记得关闭关闭 va_list

    
    }

     
    return finalArr.copy;
}


+(instancetype)arrayWithDinnerFoodTypes:(WWDinnerFoodType)firstObj, ...{
    
    return nil;
}





@end


