//
//  WWSongInfoCell.m
//  WhatToEat
//
//  Created by YinShi on 16/12/9.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWSongInfoCell.h"

@interface WWSongInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *leftIndicator;

@property (weak, nonatomic) IBOutlet UILabel *theSongName;
@property (weak, nonatomic) IBOutlet UILabel *theAdditionalInfo;


@end


@implementation WWSongInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshCellWithSongInfo:(MPMediaItem *)song{
    self.theSongName.text = song.title;
    
    self.theAdditionalInfo.text = song.artist;
    

}

- (IBAction)btnPressed:(UIButton *)sender {
}



@end
