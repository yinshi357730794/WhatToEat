//
//  WWBreakfastFood.m
//  WhatToEat
//
//  Created by YinShi on 16/10/31.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWBreakfastFood.h"

@implementation WWBreakfastFood


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.theFoodImage forKey:@"foodImage"];
    [aCoder encodeObject:self.theFoodName forKey:@"foodName"];
    [aCoder encodeObject:self.theFoodNickName forKey:@"foodNickName"];
    [aCoder encodeObject:self.foodTypeArray forKey:@"foodTypeArray"];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.theFoodName = [aDecoder decodeObjectForKey:@"foodName"];
        self.theFoodNickName = [aDecoder decodeObjectForKey:@"foodNickName"];
        self.theFoodImage = [aDecoder decodeObjectForKey:@"foodImage"];
        self.foodTypeArray = [aDecoder decodeObjectForKey:@"foodTypeArray"];
     }
    return self;
}


@end
