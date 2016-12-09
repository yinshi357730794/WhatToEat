//
//  WWAudioLibraryVC2.m
//  WhatToEat
//
//  Created by YinShi on 16/12/9.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWAudioLibraryVC2.h"
#import "WWSongInfoCell.h"

@interface WWAudioLibraryVC2 ()
@end

@implementation WWAudioLibraryVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"WWSongInfoCell" bundle:nil] forCellReuseIdentifier:@"WWSongInfoCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WWSongInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWSongInfoCell" forIndexPath:indexPath];
 
    [cell lightUp:NO];
    
    MPMediaItem *song = self.dataSource[indexPath.row];
    
    [cell refreshCellWithSongInfo:song];
    
    if ([song.title isEqualToString:MusicHelper.theSongBeingPlayed.title] &&
        [song.albumTitle isEqualToString:MusicHelper.theSongBeingPlayed.albumTitle] &&
        [song.artist isEqualToString:MusicHelper.theSongBeingPlayed.artist]) {
        [cell lightUp: YES];
    }
    
    cell.moreBtnPressedBlock = ^{
        
        YSAlertController *alert = [[YSAlertController alloc]init];
        [alert showActionSheetOnVC:self title:song.title subTitle:nil dataSource:@[@"加入播放列表"] backgoundType:TranslucentBlack];
        
        
    };
 
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MPMediaItem *song = self.dataSource[indexPath.row];
    
    if ([MusicHelper playMusicAtURL:song.assetURL]) {
        MusicHelper.theSongBeingPlayed = song;
        [self.tableView reloadData];
    }
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
