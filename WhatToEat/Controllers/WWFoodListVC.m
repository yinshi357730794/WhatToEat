//
//  WWFoodListVC.m
//  WhatToEat
//
//  Created by YinShi on 16/10/25.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "WWFoodListVC.h"
#import "CollectionViewCell.h"

@interface WWFoodListVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView1;
@property (nonatomic,copy) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navItem2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navItem1;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WWFoodListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //UI
    if (CRUserBOOL(@"UDFavouriteListMode")) {
        self.collectionView1.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        self.collectionView1.hidden = YES;
        self.tableView.hidden = NO;
    }
    
    [self.collectionView1 registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
     
    switch (self.mealType) {
        case WWMealBreakfast:
        {
            NSArray *dataArr = CRUserObj(@"UDBreakfast");
            self.dataSource = [dataArr unarchiveObjectsFromUD].mutableCopy;
            
        }
            break;
        case WWMealLunch:
            self.dataSource = CRUserObj(@"UDLauch");
            break;
        case WWMealSupper:
            self.dataSource = CRUserObj(@"UDSupper");
            break;
            
        default:
            break;
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    [cell refreshCellWithMyFavouriteFood:self.dataSource[indexPath.row]];
    return cell;
}

- (IBAction)navItemPressed:(UIBarButtonItem *)sender {

    if (sender.tag == 101) {
        
    }else if (sender.tag == 102){
        //TODO: 这里以后要变成图片的形式
        if (self.collectionView1.hidden) {
            self.collectionView1.hidden = NO;
            self.tableView.hidden = YES;
            sender.title = @"大图";
        }else{
            self.collectionView1.hidden = YES;
            self.tableView.hidden = NO;
            sender.title = @"列表";

        }
        
        
    }
    

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
