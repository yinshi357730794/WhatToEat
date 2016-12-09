//
//  WWMusicHelper.m
//  WhatToEat
//
//  Created by YinShi on 16/11/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWMusicHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface WWMusicHelper ()<AVAudioPlayerDelegate>
@property(nonatomic)AVAudioPlayer *avAudioPlayer;

@end

@implementation WWMusicHelper 



+(WWMusicHelper *)sharedHelper {
    static dispatch_once_t pred;
    __strong static WWMusicHelper *sharedHelper = nil;
    dispatch_once(&pred, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

-(CGFloat)currentProgressValue{
    return _avAudioPlayer.currentTime / _avAudioPlayer.duration;
    
}

-(void)setNumberOfLoops:(NSInteger)numberOfLoops{
    if (numberOfLoops != _avAudioPlayer.numberOfLoops) {
        _avAudioPlayer.numberOfLoops = numberOfLoops;
    }
}



-(void)prepareToPlayMusic{
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"2身体扫描" ofType:@"mp3"];
    NSURL *musicURL = [NSURL fileURLWithPath: pathStr];
    _avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:musicURL error:nil];
    _avAudioPlayer.delegate = self;
    
    //设置音乐播放次数  -1为一直循环,1为支循环1次
    _avAudioPlayer.numberOfLoops = 1;

    //预播放
    [_avAudioPlayer prepareToPlay];
    
    //设置session为了让app切换到后台也继续播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];

}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

    NSLog(@"%@",player);
    
}

-(void)play{
    [_avAudioPlayer play];
}


- (BOOL)playAtSliderValue:(CGFloat)value{
    NSTimeInterval time = value * _avAudioPlayer.duration;
    _avAudioPlayer.currentTime =  time;
    [_avAudioPlayer play];
    return YES;
    //return  [_avAudioPlayer playAtTime:time];
}

-(BOOL)playMusicAtURL:(NSURL *)musicURL{
    if (_avAudioPlayer.isPlaying) {
        [_avAudioPlayer stop];

    }
    
    _avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:musicURL error:nil];
    _avAudioPlayer.delegate = self;
    
    //设置音乐播放次数  -1为一直循环,1为支循环1次
    _avAudioPlayer.numberOfLoops = 1;
    
    //预播放
    [_avAudioPlayer prepareToPlay];
    
    [_avAudioPlayer play];

    
    if (_avAudioPlayer.isPlaying) {
        return YES;
    }else{
        return NO;
    }
    
    
}

-(void)pause{
    [_avAudioPlayer pause];
    
}

-(void)stop{

    [_avAudioPlayer stop];
}


-(NSString *)currentTime{
    NSTimeInterval time =  _avAudioPlayer.currentTime;
    
    NSInteger currentTimeInteger = time;
    
    NSInteger minutesInt = currentTimeInteger/60;
    NSInteger secondInt = currentTimeInteger % 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)minutesInt,(long)secondInt];
    
    //NSLog(@"%@",timeStr);
    
    return timeStr;
}

-(NSString *)duration{
    NSTimeInterval time = _avAudioPlayer.duration;
    NSInteger timeTotleSecond = time;
    NSInteger minutes =  timeTotleSecond/60;
    
    CGFloat second = _avAudioPlayer.duration - minutes * 60;
    NSInteger finalSecond =  round(second);
    NSString *durationStr = [NSString stringWithFormat:@"%d:%d",  minutes, finalSecond];
    
    
    return durationStr;
}

@end
