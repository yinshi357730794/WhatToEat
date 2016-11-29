//
//  AddMyFvrtFoodVC.m
//  WhatToEat
//
//  Created by YinShi on 16/10/25.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "AddMyFvrtFoodVC.h"
#import "WWCellWithRightImage.h"
#import "WWCellWithRightLabel.h"
#import "WWCellWithContentLabel.h"
#import "WWEditFoodImageVC.h"


@interface AddMyFvrtFoodVC ()<UITableViewDataSource,UITableViewDelegate>
 @property (weak, nonatomic) IBOutlet UITableView *theTableView;


@end

@implementation AddMyFvrtFoodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.theTableView registerNib:[UINib nibWithNibName:@"WWCellWithRightImage" bundle:nil] forCellReuseIdentifier:@"WWCellWithRightImage"];
    [self.theTableView registerNib:[UINib nibWithNibName:@"WWCellWithRightLabel" bundle:nil] forCellReuseIdentifier:@"WWCellWithRightLabel"];
    [self.theTableView registerNib:[UINib nibWithNibName:@"WWCellWithContentLabel" bundle:nil] forCellReuseIdentifier:@"WWCellWithContentLabel"];
    self.theTableView.tableFooterView = [UIView new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WWCellWithRightImage *cell = [tableView dequeueReusableCellWithIdentifier:@"WWCellWithRightImage"];
        
        
        return cell;
    }
    else if (indexPath.row == 1){
        WWCellWithRightLabel *cell = [tableView dequeueReusableCellWithIdentifier:@"WWCellWithRightLabel"];
        return cell;
        
    }
    else if (indexPath.row == 2){
        WWCellWithContentLabel *cell = [tableView dequeueReusableCellWithIdentifier:@"WWCellWithContentLabel"];
        return cell;

    }
    else{
        WWCellWithContentLabel *cell = [tableView dequeueReusableCellWithIdentifier:@"WWCellWithContentLabel"];
        return cell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 88;
    }else if (indexPath.row == 3) {
        return 100;
    }else{
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"show_edit1" sender:self];
        
    }
}







#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WWEditFoodImageVC *destVC = segue.destinationViewController;
    destVC.theMainImageView.image = nil;
    
}


@end
