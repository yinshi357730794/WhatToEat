//
//  TOTextInput.h
//  FrameworkTest
//
//  Created by Ted on 13-11-13.
//  Copyright (c) 2013年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputError.h"

typedef NS_ENUM(NSUInteger, InputCheckType) {
    //非兼容模式
    InputCheckTypeString = 0x00,
    InputCheckTypeFloat = 0x01,
    InputCheckTypeInt = 0x02,
    InputCheckTypeMoney = 0x04,
    InputCheckTypeCardNumber = 0x05,
    
    /*兼容模式*/
    //字符模式下表示字符长度,数字长度下表示最大值
    InputCheckTypeMaxLength = 0x10,
    InputCheckTypeMinLength = 0x20,
    InputCheckTypeNotNull = 0x40,
    //输入字符集限制模式
    InputCheckTypeCharacters = 0x80,
    //文本合法性检测
    InputCheckTypeRegex = 0x100,

};




@interface TOTextInputChecker : NSObject<UITextFieldDelegate>


/**
 *    @brief    实时返回TextField内容的CallBack
 */
typedef void(^TFContentBlock)(NSString* theContent);
-(void)currentContentCallBack:(TFContentBlock)block;


/**
 *    @brief    点击键盘上方doneButton后回调, 相当于tf的shouldReturn回调
 */
typedef void(^TFdidEndEditing)(NSString* theContent);
-(void)didEndEditing:(TFdidEndEditing)finalContentBlock;

/**
 *    @brief    判断是否达到最大值
 *    @param    YES:达到最大值 NO:没有达到
 */
typedef void(^TFContentAchieveMax)(BOOL isMax);
@property(nonatomic,copy) TFContentAchieveMax theCheckMaxBlock;


@property (nonatomic) InputCheckType type;
@property (nonatomic, strong)   NSString * characters;
@property (nonatomic, strong)   NSString * regex;
@property (nonatomic) UIKeyboardType keyboardType;


@property (nonatomic)   double  maxLen; //这边我调高了精度, 因为我们
@property (nonatomic)   CGFloat  minLen;

@property (nonatomic)   NSString *  text;
@property (nonatomic)   BOOL secureTextEntry;

//背景图片
@property (nonatomic,strong) NSString * backgroundNomarl;
@property (nonatomic,strong) NSString * backgroundHighlighted;
@property (nonatomic,strong) NSString * backgroundError;
@property (nonatomic,strong) NSString * backgroundErrorHighlighted;


-(id)copy;

-(BOOL)shouldChangeString:(id)input inRange:(NSRange)range replacementString:(NSString *)string;
-(BOOL)shouldChangeMoney:(id)input inRange:(NSRange)range replacementString:(NSString *)string;
-(BOOL)shouldChangeFloat:(id)input inRange:(NSRange)range replacementString:(NSString *)string;
-(BOOL)shouldChangeInt:(id)input inRange:(NSRange)range replacementString:(NSString *)string;


-(enum InputCheckError)finalCheck;
/**
 *    @brief    常贵密码
 */
+(TOTextInputChecker *)passwordChecker;

/**
 *    @brief    //纯数字的密码, 规定密码长度的最大, 最小值
 */
+(TOTextInputChecker *)numberPasswordCheckerWithMaxLen:(NSInteger)maxLen minLen:(NSInteger)minLen;

+(TOTextInputChecker *)telChecker:(BOOL)notNull;
+(TOTextInputChecker *)mailChecker:(BOOL)notNull;

/**
 *    @brief    字符检查
 *    @param    maxLen:字符个数, eg.8 表示最多输入8个汉字
 */
+(TOTextInputChecker *)characterCheckerMaxLen:(NSInteger)maxLen;


+(TOTextInputChecker *)floatChecker:(float)min max:(float)max;
+(TOTextInputChecker *)intChecker:(float)min max:(float)max;
/**
 *    @brief    金额检查
 *    @param    max: 金额最大值(注意不是位数,是值, 比如:9999.99)
 */
+(TOTextInputChecker *)moneyChecker:(float)min maxValue:(double)max;
/**
 *    @brief    卡号检查 , 达到最大长度后,输入内容不会自动调整为最大值
 *    @param    max:最大长度(eg:4, 那最大就是9999)  min:最小长度
 */
+(TOTextInputChecker *)cardNumberChecker:(float)min maxLength:(int)max;


+(TOTextInputChecker *)IntegerCheckerWithMaxLen:(NSInteger)maxLen minLen:(NSInteger)minLen;


@end

#define PASSWORD_CHECKER [TOTextInputChecker passwordChecker]
#define TEL_CHECKER_NOT_NULL [TOTextInputChecker telChecker:YES]
#define TEL_CHECKER [TOTextInputChecker telChecker:NO]

#define MONEY_CHECKER  [TOTextInputChecker moneyChecker:0 max:100000000]


