//
//  WWSongInPlayingListCell.h
//  WhatToEat
//
//  Created by YinShi on 16/12/13.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWSongInPlayingListCell : UITableViewCell


-(void)refreshWithSongInfo:(MPMediaItem *)song;

-(void)lightUpInPlayingList:(BOOL)isLightOn;

@end
