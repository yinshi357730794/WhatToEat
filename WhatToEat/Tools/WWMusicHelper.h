//
//  WWMusicHelper.h
//  WhatToEat
//
//  Created by YinShi on 16/11/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


#define MusicHelper [WWMusicHelper sharedHelper]

typedef NS_ENUM(NSUInteger, PlayMode) {
    PlayMode_Single = 1 ,         //单曲循环
    PlayMode_Order,             //顺序播放, 不循环
    PlayMode_Circulation,       //循环播放
    PlayMode_Random,            //随机播放, 不循环

};




@interface WWMusicHelper : NSObject 

+(WWMusicHelper *)sharedHelper ;

@property(nonatomic,assign) CGFloat currentProgressValue;

@property(nonatomic,assign) NSInteger numberOfLoops;

@property(nonatomic,strong) MPMediaItem *theSongBeingPlayed;    //正在播放的那一首歌

@property(nonatomic,assign) PlayMode thePlayMode;

typedef void (^PlayerDidStopBlock) (AVAudioPlayer *thePlayer);
@property(nonatomic,copy) PlayerDidStopBlock thePlayerDidStopBlock;

- (void)prepareToPlayMusic;
- (void)play;
- (BOOL)playAtSliderValue:(CGFloat)value;
- (BOOL)playMusicAtURL:(NSURL *)musicURL;   //播放指定路径下的URL

-(void)pause;
-(void)stop;

-(NSString *)currentTime;
-(NSString *)duration;


@end
