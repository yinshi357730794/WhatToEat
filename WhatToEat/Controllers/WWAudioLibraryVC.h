//
//  WWAudioLibraryVC.h
//  WhatToEat
//
//  Created by YinShi on 16/12/7.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWAudioLibraryVC : UIViewController


//拷贝后, 本app沙盒内的所有音乐源文件信息, 由上个页面传过来
@property(nonatomic) NSArray *dataSource;

@end
