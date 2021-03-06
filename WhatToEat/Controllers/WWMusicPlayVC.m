//
//  WWMusicPlayVC.m
//  WhatToEat
//
//  Created by YinShi on 16/11/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWMusicPlayVC.h"
#import "WWMusicHelper.h"
#import "TOTextInputChecker.h"
#import "NSString+Expand.h"
#import "YSAlertController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "WWAudioLibraryVC.h"
#import "CurrentPlayingList.h"

//test
#import "YSHeartView.h"

NSInteger const heartWidth = 40;
NSInteger const heartHeight = 40;

@interface WWMusicPlayVC ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *countDownTimeLabel;

@property (weak, nonatomic) IBOutlet UISlider *theProgressView;

@property (weak, nonatomic) IBOutlet UIView *autoStopView;
@property (weak, nonatomic) IBOutlet UITextField *theTF1;
@property(nonatomic) TOTextInputChecker *theChecker1;
@property(nonatomic) NSTimer *progressTimer;
@property(nonatomic) NSTimer *countDownTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceBetweenView1and2;
@property(nonatomic,assign) NSInteger totalCountDownTime ;  //定时关闭的总秒数
@property (weak, nonatomic) IBOutlet UIButton *playLoopBtn; //循环按钮
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic) NSMutableArray *m4aMusicSourceList;   //转存音乐源文件成功后, 把新的m4a格式的源文件信息保存在此数组中


@property (weak, nonatomic) IBOutlet UISwitch *theSwitch2;


@end

@implementation WWMusicPlayVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (MusicHelper.theSongBeingPlayed) {
        _timeLabel1.text = [MusicHelper currentTimeString];
        _timeLabel2.text = [MusicHelper durationString];

        if (_progressTimer.isValid) {
            [_progressTimer setFireDate:[NSDate date]];
        } else {
            _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MusicHelper prepareToPlayMusic];
    
    _timeLabel1.text = [MusicHelper currentTimeString];
    _timeLabel2.text = [MusicHelper durationString];
    
    //定时关闭
    [_autoStopView addTapRecognizer:self action:@selector(autoStopViewPressed)];
    //先让"定时关闭"的view藏起来
    _topSpaceBetweenView1and2.constant = -44.0;
    _theTF1.delegate = self.theChecker1;
    
    [self addHeartView];
    
    [self setPlayMode:MusicHelper.thePlayMode];
    
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"show_tab3_1"]) {
        WWAudioLibraryVC *destVC = segue.destinationViewController;
        destVC.dataSource = self.m4aMusicSourceList;
        
    }
    
}



#pragma mark
#pragma mark - IBAction
- (IBAction)musicBtnPressed:(UIButton *)sender {
    
    if (sender.tag == 101) {
        sender.selected = !sender.selected;

        if (sender.selected) {
            if (_progressTimer.isValid) {
                [_progressTimer setFireDate:[NSDate date]];
            } else {
                _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
                
            }
            if (_countDownTimer.isValid) {
                _countDownTimer.fireDate = [NSDate date];
            }

            
            [MusicHelper play];
            
            MusicHelper.thePlayerDidStopBlock = ^(AVAudioPlayer *thePlayer){
               
                //通过改变selected属性来改变button的图片
                sender.selected = !sender.selected;
                
                
            };
        }else{
            //暂停Timer
            [_progressTimer setFireDate:[NSDate distantFuture]];
            _countDownTimer.fireDate = [NSDate distantFuture];
            
            [MusicHelper pause];
        }
        
    } else if(sender.tag == 102) {
        NSInteger thePlayMode = MusicHelper.thePlayMode;
        
        NSInteger newInt = (thePlayMode++ % 4 ) + 1;
        
        [self setPlayMode:newInt];
        
        
        
    }else if (sender.tag == 103){
        sender.selected = !sender.selected;

        CurrentPlayingList *theCustomView = [[NSBundle mainBundle]loadNibNamed:@"CurrentPlayingList" owner:self options:nil][0];
        //theCustomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

        [AppRootWindow addSubview:theCustomView];
        
        [theCustomView showWithDataSource:AppManager.currentPlayingList];
        
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            theCustomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            [self.view layoutIfNeeded];
//            
//        } completion:^(BOOL finished) {
//            NSLog(@" animation completed");
//        }];
//        
//     
    
    }
    //后腿15秒
    else if (sender.tag == 104){
    
        
        
    }
    //前进15秒
    else if (sender.tag == 104){
        
    }
    

    
    
    
    
}


- (void) convertToMp3: (MPMediaItem *)song
{
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    
    NSLog (@"compatible presets for songAsset: %@",[AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    NSArray *ar = [AVAssetExportSession exportPresetsCompatibleWithAsset: songAsset];
    NSLog(@"%@", ar);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: songAsset
                                      presetName: AVAssetExportPresetAppleM4A];
    
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSString *songName = [NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]];
    
    NSString *exportFilePath = [documentsDirectoryPath stringByAppendingPathComponent:songName];
    
    NSError *error1;
    
    if([fileManager fileExistsAtPath:exportFilePath])
    {
        [fileManager removeItemAtPath:exportFilePath error:&error1];
    }
    
    NSURL* exportURL = [NSURL fileURLWithPath:exportFilePath] ;
    
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         NSData *data1 = [NSData dataWithContentsOfFile:exportFilePath];
         //NSLog(@"==================data1:%@",data1);
         
         int exportStatus = exporter.status;
         
         switch (exportStatus) {
                 
             case AVAssetExportSessionStatusFailed: {
                 
                 // log error to text view
                 NSError *exportError = exporter.error;
                 
                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                 
                 
                 
                 break;
             }
                 
             case AVAssetExportSessionStatusCompleted: {
                 
                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 [self.m4aMusicSourceList addObject:exporter];
                 
                 break;
             }
                 
             case AVAssetExportSessionStatusUnknown: {
                 NSLog (@"AVAssetExportSessionStatusUnknown");
                 break;
             }
             case AVAssetExportSessionStatusExporting: {
                 NSLog (@"AVAssetExportSessionStatusExporting");
                 break;
             }
                 
             case AVAssetExportSessionStatusCancelled: {
                 NSLog (@"AVAssetExportSessionStatusCancelled");
                 break;
             }
                 
             case AVAssetExportSessionStatusWaiting: {
                 NSLog (@"AVAssetExportSessionStatusWaiting");
                 break;
             }
                 
             default:
             { NSLog (@"didn't get export status");
                 break;
             }
         }
         
     }];
}


- (IBAction)progressViewValueChanged:(UISlider *)sender {
    
    NSLog(@"progressViewValueChanged = %f",sender.value);
    
    //实时显示跳转后的时间
    
    //_timeLabel1.text = sender.value * MusicHelper
    [_progressTimer invalidate];
}


- (IBAction)sliderTouched:(UISlider *)sender {
    
    NSLog(@"touch up inside = %f",sender.value);
    
    if (sender.value >= 1.0) {
        
        
        if (_playLoopBtn.selected) {    //单曲循环
            [MusicHelper stop];
            _timeLabel1.text = _timeLabel2.text;
            _playBtn.selected = NO;
            [_progressTimer invalidate];
        }else{  //一直循环
            [MusicHelper playAtSliderValue:sender.value ];
            _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
            
        }
    }else{
        [MusicHelper playAtSliderValue:sender.value ];
        
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
        
    }
    

    
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    
    //1.音量渐降
    if (sender.tag == 201) {
        if (MusicHelper.isPlaying) {
            
            if (sender.isOn) {
                if (_theSwitch2.isOn) {
                    [MusicHelper reduceVolume:YES InDuration:_totalCountDownTime];
                    
                } else {
                    [MusicHelper reduceVolume:YES InDuration:MusicHelper.duration - MusicHelper.currentTime];
                }
            }else{
                [MusicHelper reduceVolume:NO InDuration:0];
            }
        }else{
            
            if (sender.isOn) {
                
                MusicHelper.reduceVolumeWhenPlaying = YES;
            }else{
                MusicHelper.reduceVolumeWhenPlaying = NO;
            }
        }
        
    }
    //2.定时关闭
    else if (sender.tag == 202){
        if (sender.isOn) {
            _countDownTimeLabel.text = @"00:00";
            [UIView animateWithDuration:0.4 animations:^{
                _topSpaceBetweenView1and2.constant = 0;
                [self.view layoutIfNeeded];
            }];
        } else {
            
            if (_countDownTimer.isValid) {
                
                YSAlertController *alertController = [[YSAlertController alloc]init];
                [alertController showAlertViewOnVC:self title:@"有倒计时未完成,确定退出?" subTitle:nil cancelBtnTitle:@"取消" otherBtnTitle:@"确定" confirm:^{
                    
                    [_countDownTimer invalidate];
                    
                    [UIView animateWithDuration:0.4 animations:^{
                        _topSpaceBetweenView1and2.constant = -44;
                        [self.view layoutIfNeeded];
                    }];
                    
                } cancel:^{
                    [sender setOn:YES];
                    
                }];
                
            } else {
                
                [UIView animateWithDuration:0.4 animations:^{
                    _topSpaceBetweenView1and2.constant = -44;
                    [self.view layoutIfNeeded];
                }];
            }
            
            
        }
    }
    

}


#pragma mark
#pragma mark - Custom Func

-(void)updateTimeLabel{
    if (MusicHelper.currentProgressValue >= 1.0) {  //1.如果播完了
        
        if (_playLoopBtn.selected) {
           // [MusicHelper stop];
        }
        
    } else {    //2.还没播完
        
        //NSLog(@"进度条: %f", MusicHelper.currentProgressValue);
        _timeLabel1.text = [MusicHelper currentTimeString];
        _timeLabel2.text = [MusicHelper durationString];
        
        _theProgressView.value = MusicHelper.currentProgressValue;
    }
    
}

-(void)autoStopViewPressed{
    
    
    
}

-(void)timeUp:(NSTimer *)sender{
    NSTimeInterval timeIntercal =  sender.timeInterval;
    [MusicHelper stop];
}

-(void)startCountDown:(NSTimer *)sender{
    

    if (_totalCountDownTime) {
        _totalCountDownTime --;
        _countDownTimeLabel.text = [NSString stringWithTimeInterval:_totalCountDownTime];
    } else {
        [MusicHelper stop];
        [_countDownTimer invalidate];
    }
}

-(void)setPlayMode:(NSInteger)theCurrentPlayMode{
    
    switch (theCurrentPlayMode) {
        case 1:
            [_playLoopBtn setImage:ImageNamed(@"msc_mode_single") forState:UIControlStateNormal];
            break;
        case 2:
            [_playLoopBtn setImage:ImageNamed(@"msc_mode_order") forState:UIControlStateNormal];
            break;
        case 3:
            [_playLoopBtn setImage:ImageNamed(@"msc_mode_loop") forState:UIControlStateNormal];
            break;
        case 4:
            [_playLoopBtn setImage:ImageNamed(@"msc_mode_random") forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    MusicHelper.thePlayMode = theCurrentPlayMode;
    
}

-(void)addHeartView{
    YSHeartView *heartView = [[YSHeartView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - heartWidth)/2, (self.view.frame.size.height-heartHeight)/2, heartWidth, heartHeight)];
    
    heartView.rate = 0.5;
    heartView.lineWidth = 2;
    heartView.strokeColor = [UIColor lightGrayColor];
    heartView.fillColor = [UIColor redColor];
    heartView.changeStrokeColorWhenFillUp = YES;
    heartView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:heartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark - lazy Instantiation
-(TOTextInputChecker *)theChecker1{
    if (!_theChecker1) {
        _theChecker1 = [TOTextInputChecker intChecker:0 max:999];
        
        [_theChecker1 didEndEditing:^(NSString *theContent) {
            NSLog(@"%@",theContent);
            
            _totalCountDownTime = theContent.integerValue * 60;
            
            
            if (_totalCountDownTime) {
                _countDownTimeLabel.hidden = NO;
                _countDownTimeLabel.text = [NSString stringWithTimeInterval:_totalCountDownTime];

                if (MusicHelper.isPlaying) {
                    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown:) userInfo:nil repeats:YES];

                } else {
                    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown:) userInfo:nil repeats:YES];
                    _countDownTimer.fireDate = [NSDate distantFuture];

                }
                
                
            }
            
         }];
        
        
    }
    return _theChecker1;
}

-(NSMutableArray *)m4aMusicSourceList{
    if (!_m4aMusicSourceList) {
        _m4aMusicSourceList = [NSMutableArray array];
        
    }
    return _m4aMusicSourceList;
}







@end
