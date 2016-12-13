//
//  WWSongInPlayingListCell.m
//  WhatToEat
//
//  Created by YinShi on 16/12/13.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWSongInPlayingListCell.h"

@interface WWSongInPlayingListCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;


@end

@implementation WWSongInPlayingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)refreshWithSongInfo:(MPMediaItem *)song{
    
    self.leftLabel.text = song.title;
    
}

-(void)lightUpInPlayingList:(BOOL)isLightOn{
    
    if (isLightOn) {
        self.leftLabel.textColor =  kDefaultRed;

    }else{
        self.leftLabel.textColor =  [UIColor blackColor];

    }
    
    
}

@end
