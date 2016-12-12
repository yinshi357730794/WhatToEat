//
//  CurrentPlayingList.m
//  WhatToEat
//
//  Created by YinShi on 16/12/12.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "CurrentPlayingList.h"

@interface CurrentPlayingList ()
@property (weak, nonatomic) IBOutlet UIView *theBgView;
@property (weak, nonatomic) IBOutlet UIView *theContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theContentBottomSpace;

@end

@implementation CurrentPlayingList

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.theBgView addTapRecognizer:self action:@selector(backgroundViewPressed)];
    _theContentBottomSpace.constant = -400;
    
}



-(void)backgroundViewPressed{
    
    [self removeFromSuperview];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)show{
    
    [UIView animateWithDuration:0.5 animations:^{
        _theContentBottomSpace.constant = 0;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        NSLog(@" animation completed");
    }];
    
}




@end
