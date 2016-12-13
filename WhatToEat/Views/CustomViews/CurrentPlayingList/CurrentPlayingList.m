//
//  CurrentPlayingList.m
//  WhatToEat
//
//  Created by YinShi on 16/12/12.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "CurrentPlayingList.h"
#import "WWSongInPlayingListCell.h"
@interface CurrentPlayingList () <UITableViewDataSource>
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
    [self.theBgView addTapRecognizer:self action:@selector(backgroundViewPressed)];
    //_theContentBottomSpace.constant = -400;
    self.tableView.dataSource = self;
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
        NSLog(@" animation completed");
    }];
    
}


-(void)backgroundViewPressed{
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.theContentView.transform = CGAffineTransformMakeTranslation(0, 400);
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        NSLog(@" animation completed");
        self.hidden = YES;
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.tableViewDataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WWSongInPlayingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWSongInPlayingListCell" forIndexPath:indexPath];
    
    MPMediaItem *song = self.tableViewDataSource[indexPath.row];
    [cell refreshWithSongInfo:song];
    
    
    return cell;

}











































@end
