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
@property(nonatomic,assign) NSInteger totalCountDownTime ;
@property (weak, nonatomic) IBOutlet UIButton *playLoopBtn; //循环按钮
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic) NSMutableArray *m4aMusicSourceList;   //转存音乐源文件成功后, 把新的m4a格式的源文件信息保存在此数组中



@end

@implementation WWMusicPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MusicHelper prepareToPlayMusic];
    
    
    _timeLabel1.text = [MusicHelper currentTime];
    
    _timeLabel2.text = [MusicHelper duration];

    //定时关闭
    [_autoStopView addTapRecognizer:self action:@selector(autoStopViewPressed)];
    //先让"定时关闭"的view藏起来
    _topSpaceBetweenView1and2.constant = -44.0;

    
    _theTF1.delegate = self.theChecker1;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



- (IBAction)musicBtnPressed:(UIButton *)sender {
         sender.selected = !sender.selected;
    
    if (sender.tag == 101) {
        if (sender.selected) {
            if (_progressTimer.isValid) {
                [_progressTimer setFireDate:[NSDate date]];
            } else {
                _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];

            }
            
            [MusicHelper play];
            [self QueryAllMusic];
            
        }else{
            //暂停Timer
            [_progressTimer setFireDate:[NSDate distantFuture]];
            [MusicHelper pause];
        }
        
    } else if(sender.tag == 102) {
        if (sender.selected) {
            MusicHelper.numberOfLoops = 1;
            
        } else {
            MusicHelper.numberOfLoops = -1;
            
        }
        
    }
    
    
    
    
}

- (void) QueryAllMusic
{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    NSLog(@"count = %lu", (unsigned long)itemsFromGenericQuery.count);
    for (MPMediaItem *song in itemsFromGenericQuery)
    {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
        NSLog (@"Title:%@, Aritist:%@", songTitle, songArtist);
    }
    
    //将读到的好本地音乐文件, 拷贝?到本app沙盒内
    for (NSInteger i = 0 ;  i < 2; i ++) { //TODO:先测试2个
        
        if ([itemsFromGenericQuery[i] isKindOfClass:[MPMediaItem class]]) {
            MPMediaItem *item = itemsFromGenericQuery[i];
            [self convertToMp3:item];
            
        }

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
    
    NSString *exportFilePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]]];
    
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




-(void)updateTimeLabel{
    
    
    if (MusicHelper.currentProgressValue >= 1.0) {
        if (_playLoopBtn.selected) {
            [MusicHelper stop];
        }
        
    } else {
        
        //NSLog(@"进度条: %f", MusicHelper.currentProgressValue);
        
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

               _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown:) userInfo:nil repeats:YES];
                
                
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
