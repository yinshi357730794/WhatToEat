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



@end

@implementation WWMusicPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MusicHelper prepareToPlayMusic];
    
    
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
    
    [_autoStopView addTapRecognizer:self action:@selector(autoStopViewPressed)];
    
    _theTF1.delegate = self.theChecker1;
    
    //先让设置倒计时的view藏起来
    _topSpaceBetweenView1and2.constant = -44.0;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)musicBtnPressed:(UIButton *)sender {
         sender.selected = !sender.selected;
    
    if (sender.tag == 101) {
        if (sender.selected) {
            [MusicHelper play];
            
        }else{
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
        _timeLabel1.text = [MusicHelper currentTime];
        
        _timeLabel2.text = [MusicHelper duration];
        
        NSLog(@"进度条: %f", MusicHelper.currentProgressValue);
        
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







@end
