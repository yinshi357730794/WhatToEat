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
    
    NSString *artist = song.artist;
    NSString *albumTitle = song.albumTitle;
    self.theAdditionalInfo.text = [NSString stringWithFormat:@"%@ • %@",artist,albumTitle];
    

}

-(void)lightUp:(BOOL)isLightOn{
    if (isLightOn) {
        self.leftIndicator.backgroundColor = kDefaultRed;

    }else{
        self.leftIndicator.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
}

- (IBAction)btnPressed:(UIButton *)sender {
    
    if (self.moreBtnPressedBlock) {
        self.moreBtnPressedBlock();
    }
    
    
}



@end
