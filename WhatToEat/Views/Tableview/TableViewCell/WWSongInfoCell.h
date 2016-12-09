//
//  WWSongInfoCell.h
//  WhatToEat
//
//  Created by YinShi on 16/12/9.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>




@interface WWSongInfoCell : UITableViewCell

typedef void(^MoreBtnPressedBlock) ();
@property(nonatomic,copy) MoreBtnPressedBlock moreBtnPressedBlock;

-(void)lightUp:(BOOL)isLightOn; //当前正在播放的歌曲, 要电量最左侧的灯, 为了美观
-(void)refreshCellWithSongInfo:(MPMediaItem *)song;




@end
