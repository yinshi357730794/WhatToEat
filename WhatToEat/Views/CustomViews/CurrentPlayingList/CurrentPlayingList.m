//
//  CurrentPlayingList.m
//  WhatToEat
//
//  Created by YinShi on 16/12/12.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "CurrentPlayingList.h"
#import "WWSongInPlayingListCell.h"
@interface CurrentPlayingList () <UITableViewDataSource,UITableViewDelegate>
//===================UI=====================

@property (weak, nonatomic) IBOutlet UIView *theBgView;
@property (weak, nonatomic) IBOutlet UIView *theContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theContentBottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//===================数据=====================
@property(nonatomic,copy)NSArray *tableViewDataSource;
@end

@implementation CurrentPlayingList

-(void)awakeFromNib{
    [super awakeFromNib];
    
    //_theContentBottomSpace.constant = -400;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WWSongInPlayingListCell" bundle:nil] forCellReuseIdentifier:@"WWSongInPlayingListCell"];
}




-(void)showWithDataSource:(NSArray *)dataSource{
    
    self.tableViewDataSource = dataSource;
    [self.tableView reloadData];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.theContentView.transform = CGAffineTransformMakeTranslation(0, -400);
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        NSLog(@" 播放列表已就位");
        
        UIView *topTranslucentBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.theContentView.origin.y)];
        [self addSubview:topTranslucentBgView];
        
        [topTranslucentBgView addTapRecognizer:self action:@selector(backgroundViewPressed)];
        
    }];
    
}


-(void)backgroundViewPressed{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.theContentView.transform = CGAffineTransformMakeTranslation(0, 400);
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        NSLog(@" animation completed - backgroundViewPressed");
        self.hidden = YES;
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WWSongInPlayingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWSongInPlayingListCell" forIndexPath:indexPath];
    
    MPMediaItem *song = self.tableViewDataSource[indexPath.row];
    [cell refreshWithSongInfo:song];
    
    if ([song.title isEqualToString:MusicHelper.theSongBeingPlayed.title] &&
        [song.albumTitle isEqualToString:MusicHelper.theSongBeingPlayed.albumTitle] &&
        [song.artist isEqualToString:MusicHelper.theSongBeingPlayed.artist]) {
        
        [cell lightUpInPlayingList: YES];
    }else{
        
        [cell lightUpInPlayingList: NO];

    }

    
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%d",indexPath.row);
    
    MPMediaItem *song = self.tableViewDataSource[indexPath.row];
    
    if ([MusicHelper playMusicAtURL:song.assetURL]) {
        MusicHelper.theSongBeingPlayed = song;
        [self.tableView reloadData];
    }
    
    
}










































@end
