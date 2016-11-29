//
//  WWFoodBaseModel.m
//  WhatToEat
//
//  Created by YinShi on 16/10/25.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWFoodBaseModel.h"

@implementation WWFoodBaseModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.theFoodImage forKey:@"foodImage"];
    [aCoder encodeObject:self.theFoodName forKey:@"foodName"];
    [aCoder encodeObject:self.theFoodNickName forKey:@"foodNickName"];

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.theFoodName = [aDecoder decodeObjectForKey:@"foodName"];
        self.theFoodNickName = [aDecoder decodeObjectForKey:@"foodNickName"];
        self.theFoodImage = [aDecoder decodeObjectForKey:@"foodImage"];
    }
    return self;
}


@end
