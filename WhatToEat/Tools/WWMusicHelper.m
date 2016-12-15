//
//  WWMusicHelper.m
//  WhatToEat
//
//  Created by YinShi on 16/11/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWMusicHelper.h"

@interface WWMusicHelper ()<AVAudioPlayerDelegate>
@property(nonatomic)AVAudioPlayer *avAudioPlayer;
@property(nonatomic,strong) NSTimer *timer_playProgress;    //播放进度计时器
@property(nonatomic,strong) NSTimer *timer_volumeReduce;    //渐渐减弱音量的timer
@property(nonatomic,assign) NSInteger timeFrequency;
@property(nonatomic,assign) CGFloat originalVolume;         //原始音量大小
@property(nonatomic,assign) CGFloat newVolume;              //最新的音量大小
@property(nonatomic,assign) CGFloat eachReduction;          //每次减少的音量

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
    
    if (_avAudioPlayer.currentTime ==  _avAudioPlayer.duration) {
        NSLog(@"播完了!!!!!!!!!!播完了!!!!!!!!!!播完了!!!!!!!!!!");
    }
    
    return _avAudioPlayer.currentTime / _avAudioPlayer.duration;
    
}

#pragma mark
#pragma mark - Setters & Getters
-(void)setNumberOfLoops:(NSInteger)numberOfLoops{
    if (numberOfLoops != _avAudioPlayer.numberOfLoops) {
        _avAudioPlayer.numberOfLoops = numberOfLoops;
    }
}

-(void)setThePlayMode:(PlayMode)thePlayMode{
    if (_thePlayMode != thePlayMode) {
        _thePlayMode = thePlayMode;
        
        /*
         PlayMode_Single = 0 ,         //单曲循环
         PlayMode_Order,             //顺序播放, 不循环
         PlayMode_Circulation,       //循环播放
         PlayMode_Random,            //随机播放, 不循环

         */
        switch (_thePlayMode) {
            case 1:
                CRUserSetObj(@1, @"UDPlayMode");
                break;
            case 2:
                CRUserSetObj(@2, @"UDPlayMode");
                break;
            case 3:
                CRUserSetObj(@3, @"UDPlayMode");
                break;
            case 4:
                CRUserSetObj(@4, @"UDPlayMode");
                break;

        }
        NSNumber *number = CRUserObj(@"UDPlayMode");
        NSLog(@"UDPlayMode已经被修改为: %d",number.integerValue);
    }
    
}


-(BOOL)isPlaying{
    
    return _avAudioPlayer.isPlaying;
}

#pragma mark
#pragma mark - Func

-(void)prepareToPlayMusic{
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"2身体扫描" ofType:@"mp3"];
    NSURL *musicURL = [NSURL fileURLWithPath: pathStr];
    _avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:musicURL error:nil];
    _avAudioPlayer.delegate = self;
    
    //设置音乐播放次数  -1为一直循环,1为支循环1次
    //_avAudioPlayer.numberOfLoops = 1;
    
    //预播放
    [_avAudioPlayer prepareToPlay];
    
    //设置session为了让app切换到后台也继续播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

    NSLog(@"AVAudioPlayerDelegate 协议启动, audioPlayerDidFinishPlaying");
    
    switch (self.thePlayMode) {
        case 1: //单曲循环
            
            break;
        case 2: //顺序播放
            if(AppManager.currentPlayingList){
                
            }else{
                [self stop];
            }
            break;
        case 3: //循环
            if(AppManager.currentPlayingList){
                
            }else{
                [player play];
            }
            break;
        case 4: //随机
            if(AppManager.currentPlayingList){
                
            }else{
                
            }
            break;
    
        default:
            break;
    }
    
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    NSLog(@"AVAudioPlayerDelegate 协议启动, audioPlayerDecodeErrorDidOccur");


}


-(void)play{
  

    if (self.reduceVolumeWhenPlaying) {
        [self reduceVolume:YES InDuration:self.duration];
    }
    [_avAudioPlayer play];

    //_playProgressTimer = [NSTimer scheduledTimerWithTimeInterval:<#(NSTimeInterval)#> target:<#(nonnull id)#> selector:<#(nonnull SEL)#> userInfo:<#(nullable id)#> repeats:<#(BOOL)#>]
    
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
    
    [self play];

    
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
    if (self.thePlayerDidStopBlock) {
        self.thePlayerDidStopBlock(_avAudioPlayer);
    }
}

-(NSTimeInterval)currentTime{
    return _avAudioPlayer.currentTime;
}

-(NSString *)currentTimeString{
    NSTimeInterval time =  _avAudioPlayer.currentTime;
    
    NSInteger currentTimeInteger = time;
    
    NSInteger minutesInt = currentTimeInteger/60;
    NSInteger secondInt = currentTimeInteger % 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)minutesInt,(long)secondInt];
    
    //NSLog(@"%@",timeStr);
    
    return timeStr;
}

-(NSTimeInterval)duration{
    return _avAudioPlayer.duration;
}
-(NSString *)durationString{
    NSTimeInterval time = _avAudioPlayer.duration;
    NSInteger timeTotleSecond = time;
    NSInteger minutes =  timeTotleSecond/60;
    
    CGFloat second = _avAudioPlayer.duration - minutes * 60;
    NSInteger finalSecond =  round(second);
    NSString *durationStr = [NSString stringWithFormat:@"%d:%d",  minutes, finalSecond];
    
    
    return durationStr;
}



-(void)reduceVolume:(BOOL)confirmed InDuration:(NSTimeInterval)duration{
    
    if (confirmed) {
        NSLog(@"开始降低音量, 当前音量是: %f",_avAudioPlayer.volume);
        _timer_volumeReduce = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timerFunc_reduceVolume) userInfo:nil repeats:YES];
       
        //每30秒减低音量一次, 歌曲总共300秒, 则timeFrequency = 10次
        _timeFrequency =  duration / 30;
        _originalVolume =  _avAudioPlayer.volume;
        _newVolume =  _originalVolume;
        _eachReduction =  _originalVolume / _timeFrequency;  //每次降低的音量

    }else{
        [_timer_volumeReduce invalidate];
        
    }
    

}

-(void)timerFunc_reduceVolume{
    _newVolume = _newVolume - _eachReduction;
    _avAudioPlayer.volume = _newVolume;
    NSLog(@"当前音量是: %f",_avAudioPlayer.volume);
    if (_avAudioPlayer.volume == 0) {
        [_avAudioPlayer stop];
    }

}






















@end
