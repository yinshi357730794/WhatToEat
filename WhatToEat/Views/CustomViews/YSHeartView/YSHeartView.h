//
//  YSHeartView.h
//  WhatToEat
//
//  Created by YinShi on 16/12/13.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSHeartView : UIView

/**
  * 比率
  */
@property (nonatomic,assign) CGFloat rate;
/**
  * 填充的颜色
  */
@property (nonatomic,strong) UIColor *fillColor;
/**
  * 线条的颜色
  */
@property (nonatomic,strong) UIColor *strokeColor;
/**
  * 线条的宽度
  */
@property (nonatomic,assign) CGFloat lineWidth;

/**
 *    @brief    填充颜色时, 边线颜色是否随之一起改变
 */
@property(nonatomic,assign) BOOL changeStrokeColorWhenFillUp;


-(void)fillUpSelf;      //填满自己
-(void)hollowOutSelf;   //让自己空心化

@end
