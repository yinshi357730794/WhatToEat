//
//  WWAudioLibraryVC.m
//  WhatToEat
//
//  Created by YinShi on 16/12/7.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWAudioLibraryVC.h"
#import <AVFoundation/AVFoundation.h>


@interface WWAudioLibraryVC () <UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>
@property(nonatomic)AVAudioPlayer *avAudioPlayer;
@property(nonatomic)AVAssetExportSession *exportor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)NSArray *musicNameList;


@end

@implementation WWAudioLibraryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (NSInteger i = 0 ; i < self.dataSource.count; i ++) {
        _exportor = self.dataSource[i];
        
        //提取名字:
        NSLog(@"===================小分割线=====================");
        NSLog(@"presetName = %@",_exportor.presetName);
        NSLog(@"asset = %@",_exportor.asset);
        NSLog(@"outputFileType = %@",_exportor.outputFileType);
        NSLog(@"outputURL = %@",_exportor.outputURL);
        NSLog(@"===================小分割线=====================");
        //提取URL
    }
    
    
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 首先读取那个目录下面原来就有的.mp3或者.m4a文件, 如果有, 那么闲读出来.
     _musicNameList = [fileManager contentsOfDirectoryAtPath:documentsDirectoryPath error:nil];
    
    NSLog(@"%@",_musicNameList);
    
   // NSURL* exportURL = [NSURL fileURLWithPath:nil] ;
    
    
    
    
    
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




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _musicNameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    
    /*
    AVAssetExportSession *exportor = self.dataSource[indexPath.row];
    
    NSString * urlString = exportor.outputURL.absoluteString;
    NSString *namePart = [urlString componentsSeparatedByString:@"Documents/"][1];
    NSString *nameWithoutDotFormat = [namePart componentsSeparatedByString:@"."][0];
    //把乱码转换成汉字:
    NSString *transString = nameWithoutDotFormat.stringByRemovingPercentEncoding;
    cell.textLabel.text = transString;
    */
    
    
    NSString *name = _musicNameList[indexPath.row];
    //过滤掉后缀".m4a"
    NSString *realName = [name componentsSeparatedByString:@"."][0];
    
    cell.textLabel.text = realName;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    NSString *musicName = _musicNameList[indexPath.row];
    
    //在实际的目录中, 中文字符是百分号字符, 这里要转一下
    NSString *musicFileAbsolutePath = [documentsDirectoryPath stringByAppendingPathComponent:[musicName convertUTF8StringToPercentString]];
    
    
    [MusicHelper playMusicAtPath:[NSURL URLWithString:musicFileAbsolutePath]];
    
}













@end
