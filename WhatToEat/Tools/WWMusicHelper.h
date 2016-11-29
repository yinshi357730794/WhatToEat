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

-(void)prepareToPlayMusic;
-(void)play;
- (BOOL)playAtSliderValue:(CGFloat)value;

-(void)pause;
-(void)stop;

-(NSString *)currentTime;
-(NSString *)duration;

@property(nonatomic,assign) CGFloat currentProgressValue;

@property(nonatomic,assign) NSInteger numberOfLoops;

@end
