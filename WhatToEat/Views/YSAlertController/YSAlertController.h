//
//  YSAlertController.h
//  CI990
//
//  Created by YinShi on 16/3/31.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BackgroundType) {
    BlurEffect,         // 毛玻璃效果
    TranslucentBlack,   // 黑色半透明
};

/**
 *    @brief  使用简单:1.alloc init 2.设置字体, 颜色什么的 3.showActionSheetOnVC:xxx方法
*/
@interface YSAlertController : NSObject

//===================Action Sheet=====================
/**
 *    @brief    //这里定制一些默认的颜色, 字体什么的
 */
-(instancetype) init;

//直接返回点击的那一行的文字: eg. 签发人
@property(nonatomic,copy) void (^actionSheetDidPressTitle)(NSString *theTitle);

//标题
@property(nonatomic,strong)UIColor *theTitleColor;
@property(nonatomic,strong)UIFont *theTitleFont;

//正文内容 + 取消按钮的颜色
@property(nonatomic,strong)UIColor *theContentTextColor;
@property(nonatomic,strong)UIFont *theContentTextFont;

//显示actionSheet(重要: 最后再调用此方法)
-(void)showActionSheetOnVC:(UIViewController *)theVC title:(NSString *)title subTitle:(NSString *)subTitle dataSource:(NSArray *)dataSource backgoundType:(BackgroundType) bgType;

/**
 *    @brief    快速生成标准的[选择角色]的界面
 */
-(void)showStandardSelectRoleTypeActionSheetOnVC:(UIViewController *)vc;

//===================Alert View=====================
//显示alertView(适配了iOS8以前的版本)
-(void)showAlertViewOnVC:(UIViewController *)viewController title:(NSString *)title subTitle:(NSString *)message cancelBtnTitle:(NSString *)cancelButtonTitle otherBtnTitle:(NSString *)otherButtonTitle confirm:(void (^)())confirm cancel:(void (^)())cancel;








@end
