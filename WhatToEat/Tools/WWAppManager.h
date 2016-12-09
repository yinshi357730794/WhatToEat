//
//  AppManager.h
//  WhatToEat
//
//  Created by YinShi on 16/12/8.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define AppManager [WWAppManager sharedManager]

@interface WWAppManager : NSObject

+(WWAppManager *)sharedManager ;

- (void) QueryAllMusic;

@property(nonatomic,copy) NSDictionary *allMusicDict_classifiedByAlbum; //已经按专辑名称分类好的 所有歌曲


@end
