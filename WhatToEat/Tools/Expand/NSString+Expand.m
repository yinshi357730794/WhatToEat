//
//  NSString+Expand.m
//  WhatToEat
//
//  Created by YinShi on 16/10/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "NSString+Expand.h"

@implementation NSString (Expand)


+(NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval{
    
    NSString *timeStr = @"";
    NSInteger second = timeInterval;
    
    
    if (second > 3600) {
        timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",second/3600,(second%3600)/60,second%60];
    } else {
        timeStr =[NSString stringWithFormat:@"%02d:%02d",(second%3600)/60,second%60];
    }
    
    return timeStr;
    
    
}

-(NSString *)convertUTF8StringToPercentString{
    
    //把汉字转成百分号字符:
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    return encodedString;

}

-(NSString *)convertPercentStringToUTF8String{
    return  self.stringByRemovingPercentEncoding;

}

@end
