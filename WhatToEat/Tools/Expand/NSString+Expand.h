//
//  NSString+Expand.h
//  WhatToEat
//
//  Created by YinShi on 16/10/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Expand)

//+(NSString *)stringFromFoodType:(NSNumber *)foodTypeNumber;

+(NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval;


//UTF8转百分号字符
-(NSString *)convertUTF8StringToPercentString;
//上述过程反过来
-(NSString *)convertPercentStringToUTF8String;



@end
