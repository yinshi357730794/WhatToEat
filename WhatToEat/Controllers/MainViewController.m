//
//  MainViewController.m
//  WhatToEat
//
//  Created by YinShi on 16/10/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "MainViewController.h"
#import "RollVC.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainView1;
@property (weak, nonatomic) IBOutlet UIView *mainView2;
@property (weak, nonatomic) IBOutlet UIView *mainView3;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mainView1 addTapRecognizer:self action:@selector(view1Pressed:)];
    [self.mainView2 addTapRecognizer:self action:@selector(view1Pressed:)];
    [self.mainView3 addTapRecognizer:self action:@selector(view1Pressed:)];

    self.mainView1.layer.cornerRadius = 5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)view1Pressed:(UITapGestureRecognizer *)sender{
    
    [self performSegueWithIdentifier:@"show1" sender:sender];
    
    
    
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITapGestureRecognizer *theTGR = (UITapGestureRecognizer *)sender;
    RollVC *destVC =  segue.destinationViewController;
    
    switch (theTGR.view.tag) {
        case 1:
            destVC.title = @"早餐";
            destVC.mealType = WWMealBreakfast;
            break;
        case 2:
            destVC.title = @"午餐";
            destVC.mealType = WWMealLunch;

            break;
        case 3:
            destVC.title = @"晚餐";
            destVC.mealType = WWMealSupper;

            break;
        default:
            break;
    }
    
}


@end
