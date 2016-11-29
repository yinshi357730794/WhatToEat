//
//  YSAlertController.m
//  CI990
//
//  Created by YinShi on 16/3/31.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "YSAlertController.h"
#import "MSAlertController.h"

typedef void (^confirm)();
typedef void (^cancle)();

#define IOS8Later [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0


@interface YSAlertController ()<UIAlertViewDelegate>{
    confirm confirmParam;
    cancle  cancleParam;
}

@property(nonatomic) NSString * theTitle;
@property(nonatomic) NSString * theSubTitle;
@property(nonatomic) NSArray* dataSource;
@property(nonatomic) MSAlertController *mainAlertController;
@property(nonatomic,copy)MSAlertAction *btn;
@end

@implementation YSAlertController

-(instancetype)init{
    self = [super init];
    if (self) {
        //这里定制成app内统一的黑色, 在其它项目中, 可能不是这个颜色哦
//        self.theTitleColor = kDefaultBlackTxtColor;
//        self.theContentTextColor = kDefaultBlackTxtColor;
        

    };
    return self;
}




-(void)setTheTitleColor:(UIColor *)theTitleColor{
    if (_theTitleColor != theTitleColor) {
        _theTitleColor = theTitleColor;
    }
}

-(void)setTheTitleFont:(UIFont *)theTitleFont{
    if (_theTitleFont != theTitleFont) {
        _theTitleFont = theTitleFont;
    }
}

-(void)setTheContentTextColor:(UIColor *)theContentTextColor{
    if (_theContentTextColor != theContentTextColor) {
        _theContentTextColor = theContentTextColor;
    }
}


-(void)showActionSheetOnVC:(UIViewController *)theVC title:(NSString *)title subTitle:(NSString *)subTitle dataSource:(NSArray *)dataSource backgoundType:(BackgroundType) bgType{
    
    _mainAlertController = [MSAlertController alertControllerWithTitle:title message:subTitle preferredStyle:MSAlertControllerStyleActionSheet];
    if (_theTitleFont) {
        _mainAlertController.titleFont = _theTitleFont;
    }
    
    if (_theTitleColor) {
        _mainAlertController.titleColor = _theTitleColor;
    }
    
    if (bgType == BlurEffect) {
        //MSAlertControler默认设置
    }else{
        _mainAlertController.enabledBlurEffect = NO;
        _mainAlertController.alpha = 1.0;
        _mainAlertController.backgroundColor = kDefaultTranslucentBGColor;
        
    }
    
    //title的字体, 特别设置一下
    _mainAlertController.message = subTitle;
    
    //添加ActionSheet的每一行,以及message
     for (NSString *string in dataSource) {
         
        _btn = [MSAlertAction actionWithTitle:string style:MSAlertActionStyleDefault handler:^(MSAlertAction *action) {
            if (self.actionSheetDidPressTitle) {
                self.actionSheetDidPressTitle(action.title);
            }
        }];
         _btn.font = [UIFont systemFontOfSize:17];
         if (_theContentTextColor) {
             _btn.titleColor = _theContentTextColor;
         }
        [_mainAlertController addAction:_btn];
         
    }
    
    MSAlertAction *lastButton = [MSAlertAction actionWithTitle:@"取消" style:MSAlertActionStyleCancel handler:^(MSAlertAction *action) {
        if (self.actionSheetDidPressTitle) {
            self.actionSheetDidPressTitle(action.title);
        }
    }];
    [_mainAlertController addAction:lastButton];
     if (_theContentTextColor) {
        lastButton.titleColor = _theContentTextColor;
    }
    
    [theVC presentViewController:_mainAlertController animated:YES completion:nil];

}

-(void)showStandardSelectRoleTypeActionSheetOnVC:(UIViewController *)vc{
 
    self.theTitleColor = kDefaultBlackTxtColor;
    self.theTitleFont = [UIFont boldSystemFontOfSize:19];
    self.theContentTextColor = kDefaultBlackTxtColor;
    
    [self showActionSheetOnVC:vc title:@"更换角色" subTitle:nil dataSource:@[@"签发人",@"审核人",@"授权人",@"主管"] backgoundType:TranslucentBlack];
    

}


-(void)showAlertViewOnVC:(UIViewController *)viewController title:(NSString *)title subTitle:(NSString *)message cancelBtnTitle:(NSString *)cancelButtonTitle otherBtnTitle:(NSString *)otherButtonTitle confirm:(void (^)())confirm cancel:(void (^)())cancel{
    confirmParam = confirm;
    cancleParam = cancel;
    
    if (IOS8Later) {
        _mainAlertController = [MSAlertController alertControllerWithTitle:title message:message preferredStyle:MSAlertControllerStyleAlert];
        
        // Create the actions.
        MSAlertAction *cancelAction = [MSAlertAction actionWithTitle:cancelButtonTitle style:MSAlertActionStyleCancel handler:^(MSAlertAction *action) {
            cancel();
        }];
        
        MSAlertAction *otherAction = [MSAlertAction actionWithTitle:otherButtonTitle style:MSAlertActionStyleDefault handler:^(MSAlertAction *action) {
            confirm();
        }];
        
        // Add the actions.
        [_mainAlertController addAction:cancelAction];
        [_mainAlertController addAction:otherAction];
        [viewController presentViewController:_mainAlertController animated:YES completion:nil];
        
    }else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:otherButtonTitle otherButtonTitles:cancelButtonTitle,nil];
        [TitleAlert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        confirmParam();
    }
    else{
        cancleParam();
    }
}


@end
