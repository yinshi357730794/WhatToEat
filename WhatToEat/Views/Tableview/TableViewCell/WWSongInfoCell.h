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

-(void)refreshCellWithSongInfo:(MPMediaItem *)song;

@end
