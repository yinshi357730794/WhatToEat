//
//  WWMusicHelper.h
//  WhatToEat
//
//  Created by YinShi on 16/11/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#define MusicHelper [WWMusicHelper sharedHelper]


@interface WWMusicHelper : NSObject 

+(WWMusicHelper *)sharedHelper ;

@property(nonatomic,assign) CGFloat currentProgressValue;

@property(nonatomic,assign) NSInteger numberOfLoops;

@property(nonatomic,strong) MPMediaItem *theSongBeingPlayed;    //正在播放的那一首歌


- (void)prepareToPlayMusic;
- (void)play;
- (BOOL)playAtSliderValue:(CGFloat)value;
- (BOOL)playMusicAtURL:(NSURL *)musicURL;   //播放指定路径下的URL

-(void)pause;
-(void)stop;

-(NSString *)currentTime;
-(NSString *)duration;


@end
