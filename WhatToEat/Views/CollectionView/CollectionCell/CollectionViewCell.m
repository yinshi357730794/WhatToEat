//
//  CollectionViewCell.m
//  WhatToEat
//
//  Created by YinShi on 16/10/25.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *theBgImg;
@property (weak, nonatomic) IBOutlet UILabel *theContentLabel;

@end

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

-(void)refreshCellWithMyFavouriteFood:(WWFoodBaseModel *)theFood{
    
    //如果有背景图, 那设置背景图
    if (theFood.theFoodImage) {
        self.theBgImg.image = theFood.theFoodImage;
    }
    
    //如果有昵称/备注, 那么显示昵称/备注
    if (theFood.theFoodNickName.length > 0 ) {
        self.theContentLabel.text = theFood.theFoodNickName;
        
    }else{
        self.theContentLabel.text = theFood.theFoodName;
    }
    
}

@end
