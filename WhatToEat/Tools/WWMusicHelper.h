//
//  WWMusicHelper.h
//  WhatToEat
//
//  Created by YinShi on 16/11/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MusicHelper [WWMusicHelper sharedHelper]


@interface WWMusicHelper : NSObject 

+(WWMusicHelper *)sharedHelper ;

@property(nonatomic,assign) CGFloat currentProgressValue;

@property(nonatomic,assign) NSInteger numberOfLoops;


-(void)prepareToPlayMusic;
-(void)play;
- (BOOL)playAtSliderValue:(CGFloat)value;
-(void)playMusicAtPath:(NSURL *)musicURL;   //播放指定路径下的URL

-(void)pause;
-(void)stop;

-(NSString *)currentTime;
-(NSString *)duration;
@end
