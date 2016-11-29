//
//  WWRollVCCell.m
//  WhatToEat
//
//  Created by YinShi on 16/10/31.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWRollVCCell.h"
#import "WWBreakfastFood.h"
#import "WWDinnerFood.h"

@interface WWRollVCCell ()

@property (weak, nonatomic) IBOutlet UILabel *theLeftTitle;
@property (weak, nonatomic) IBOutlet UIImageView *theRightImage;

@end

@implementation WWRollVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshCellWithModel:(id)foodModel{
    if ([foodModel isKindOfClass:[WWBreakfastFood class]]) {
        WWBreakfastFood *model = foodModel;
        if (model.theFoodNickName.length > 0) {
            _theLeftTitle.text = model.theFoodNickName;
        }else{
            _theLeftTitle.text = model.theFoodName;
        }
        _theRightImage.image =model.theFoodImage;
        
    } else {
        
        return;
    }
}

@end
