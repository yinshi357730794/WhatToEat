//
//  WWHelper.h
//  WhatToEat
//
//  Created by YinShi on 16/11/2.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define APPHelper [WWHelper sharedHelper]

@interface WWHelper : NSObject

+(WWHelper *)sharedHelper;

//把(NSNumber *)foodType改成转换成中文
-(NSString *)convertFoodType:(NSNumber *)typeNumber;


@end



