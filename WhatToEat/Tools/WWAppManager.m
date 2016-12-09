//
//  AppManager.m
//  WhatToEat
//
//  Created by YinShi on 16/12/8.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWAppManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>



@implementation WWAppManager


+(WWAppManager *)sharedManager {
    static dispatch_once_t pred;
    __strong static WWAppManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}



- (void) QueryAllMusic
{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    
    /*
     //打印一下所有歌曲的信息, 方便后续操作
    NSLog(@"count = %lu", (unsigned long)itemsFromGenericQuery.count);
    
    for (MPMediaItem *song in itemsFromGenericQuery)
    {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
        NSString *songAlbumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
        NSString *songURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
        
        NSLog (@"Title:%@, Aritist:%@, songAlbumTitle: %@,URL: %@", songTitle, songArtist,songAlbumTitle,songURL);
    }
     
      //将读到的好本地音乐文件, 拷贝?到本app沙盒内
     for (NSInteger i = 0 ;  i < 2; i ++) { //TODO:先测试2个
     
     if ([itemsFromGenericQuery[i] isKindOfClass:[MPMediaItem class]]) {
     MPMediaItem *item = itemsFromGenericQuery[i];
     [self convertToMp3:item];
     
     }
     
     }
     */
    NSMutableDictionary *totalDict = [NSMutableDictionary dictionary];
    //NSMutableArray *totalArray = [NSMutableArray array];
    NSMutableArray *baseAblumNameArray = [NSMutableArray array];    //保存所有不同的专辑名称
    [itemsFromGenericQuery enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       //根据不同的专辑, 分成不同的数组, 然后再装到totalDict字典中, 那么totalDict字典就是所有以专辑分好类的所有歌曲的字典了
        MPMediaItem *song = obj;
        //根据专辑分类具体过程1:
        NSString *songAlbumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
        if (songAlbumTitle ) {
           
            if (![baseAblumNameArray containsObject: songAlbumTitle]) {
               
                [baseAblumNameArray addObject:songAlbumTitle];
                
                NSMutableArray *songArray =  [NSMutableArray array];
                [songArray addObject:song];
                //建立以专辑名为Key的字典, Obj是数组
                [totalDict setObject:songArray forKey:songAlbumTitle];

            } else {
                //如果baseAblumNameArray里面有, 说明这个专辑名之前已经建立了,直接添加即可
                NSMutableArray *songArray = totalDict[songAlbumTitle];
                [songArray addObject:song];
            }
            

        }
        
        
        //如果专辑名称
        
    }];
    
    self.allMusicDict_classifiedByAlbum = totalDict;
    
    
    
}


@end
