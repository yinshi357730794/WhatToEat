//
//  YSLabelList.m
//  WhatToEat
//
//  Created by YinShi on 16/11/7.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "YSLabelList.h"

@interface YSLabelList ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *theTextField;


@end

@implementation YSLabelList

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    
    return YES;
}


@end
