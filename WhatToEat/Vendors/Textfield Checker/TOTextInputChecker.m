//
//  TOTextInput.m
//  FrameworkTest
//
//  Created by Ted on 13-11-13.
//  Copyright (c) 2013年 Tony. All rights reserved.
//

#import "TOTextInputChecker.h"
#import "RegexKitLite.h"
#import "UIView+CRBoost.h"
#import "objc/runtime.h"

@interface TOTextInputChecker ()
@property (nonatomic) UIButton *doneButton;
@property(nonatomic,copy) TFContentBlock theContentBlock;
@property(nonatomic,copy) TFdidEndEditing theDidEndEditingBlock;

@end


@implementation TOTextInputChecker

-(id)init{
    self = [super init];
    if(self){
        self.maxLen = 30;
        self.minLen = 0;
        self.characters = @"[a-zA-Z0-9_]";
        self.keyboardType = UIKeyboardTypeDefault;
        self.type = InputCheckTypeString | InputCheckTypeCharacters | InputCheckTypeMaxLength;
        self.text = @"";
        self.secureTextEntry = NO;
        
        self.backgroundHighlighted = nil;
        self.backgroundNomarl = nil;
        self.backgroundError = nil;
        self.backgroundErrorHighlighted = nil;
    }
    return self;
}


/**
 *  密码检查
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)passwordChecker{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeDefault;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | InputCheckTypeNotNull|InputCheckTypeCharacters;
    check.characters = @"[0-9a-zA-Z_]";
    check.maxLen = 11;
    check.minLen = 6;
    check.secureTextEntry = YES;
    
    return check;
}

//纯数字密码检查
+(TOTextInputChecker *)numberPasswordCheckerWithMaxLen:(NSInteger)maxLen minLen:(NSInteger)minLen{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeNumberPad;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | InputCheckTypeNotNull|InputCheckTypeCharacters;
    check.characters = @"[0-9]";
    check.maxLen = maxLen;
    check.minLen = minLen;
    check.secureTextEntry = YES;
    
    return check;
}



+(TOTextInputChecker *)IntegerCheckerWithMaxLen:(NSInteger)maxLen minLen:(NSInteger)minLen{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeNumberPad;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | InputCheckTypeNotNull|InputCheckTypeCharacters;
    check.characters = @"[0-9]";
    check.maxLen = maxLen;
    check.minLen = minLen;
    
    return check;
}



/**
 *  手机号码检测
 *
 *  @param notNull 是否允许为空
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)telChecker:(BOOL) notNull{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeNumberPad;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | (notNull ? InputCheckTypeNotNull : 0);
    check.characters = @"[0-9]";
    check.regex = @"[1-9][0-9]{10}";
    check.maxLen = 11;
    check.minLen = 11;
    return check;
}
/**
 *  邮箱地址检查
 *
 *  @param notNull 是否允许为空
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)mailChecker:(BOOL)notNull{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeEmailAddress;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | (notNull ? InputCheckTypeNotNull : 0);
    check.characters = @"[0-9a-zA-Z_.@]";
    check.regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    return check;
}

+(TOTextInputChecker *)characterCheckerMaxLen:(NSInteger)maxLen{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeDefault;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | InputCheckTypeNotNull|InputCheckTypeCharacters;
    check.characters = @"[A-Za-z0-9_\\-\u4e00-\u9fa5]+";
    check.maxLen = maxLen;
    check.minLen = 0;
    
    
    return check;
}




/**
 *  浮点型检查
 *
 *  @param min 最小值
 *  @param max 最大值
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)floatChecker:(float)min max:(float)max{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeDecimalPad;
    check.type = InputCheckTypeFloat | InputCheckTypeNotNull;
    check.characters = @"[0-9.]";
    
    check.maxLen = max;
    check.minLen = min;
    return check;
}
/**
 *  整型检查
 *
 *  @param min 最小值
 *  @param max 最大值
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)intChecker:(float)min max:(float)max{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeNumberPad;
    check.type = InputCheckTypeInt | InputCheckTypeNotNull;
    check.characters = @"[0-9.]";
    check.maxLen = max;
    check.minLen = min;
    return check;
    
    
}

/**
 *  金额检查
 *
 *  @param min 最小值
 *  @param max 最大值
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)moneyChecker:(float)min maxValue:(double)max{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeDecimalPad;
    check.type = InputCheckTypeMoney | InputCheckTypeNotNull;
    check.characters = @"[0-9.]";
    check.maxLen = max;
    check.minLen = min;
    return check;
}


+(TOTextInputChecker *)cardNumberChecker:(float)min maxLength:(int)max{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeNumberPad;
    check.type = InputCheckTypeString | InputCheckTypeNotNull;
    check.characters = @"[0-9]";
    check.maxLen = max;
    check.minLen = min;
    return check;
}



//实时返回输入内容的CallBack
static char CURRENT_CONTENT_BLOCK_KEY;
-(void)currentContentCallBack:(TFContentBlock)currentContent{
    if (currentContent) {
        objc_setAssociatedObject(self, &CURRENT_CONTENT_BLOCK_KEY, currentContent, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
}

static char DID_END_EDITING_BLOCK_KEY;
-(void)didEndEditing:(TFdidEndEditing)finalContentBlock{
    if (finalContentBlock) {
        objc_setAssociatedObject(self, &DID_END_EDITING_BLOCK_KEY, finalContentBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
}




-(BOOL)shouldChangeString:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    return [self maxLengthCheck:input inRange:range replacementString:string] && [self charactersCheck:input inRange:range replacementString:string];
}



#pragma mark setters
-(void)setMaxLen:(double)maxLen{
    self.type |= InputCheckTypeMaxLength;
    _maxLen = maxLen;
}

-(void)setMinLen:(CGFloat)minLen{
    self.type |= InputCheckTypeMinLength;
    _minLen = minLen;
}

-(void)setCharacters:(NSString *)characters{
    self.type |= InputCheckTypeCharacters;
    _characters = characters;
}

-(void)setRegex:(NSString *)regex{
    self.type |= InputCheckTypeRegex;
    _regex = regex;
}

//字符集检测
-(BOOL)charactersCheck:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if(!(self.type & InputCheckTypeCharacters)){
        
        return YES;
    }
    if(self.characters==nil || self.characters.length==0 || string.length==0){
        
        return YES;
    }
    
    
    
    return [string isMatchedByRegex:self.characters];
    
}
//字符串最大检测
-(BOOL)maxLengthCheck:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (!(self.type & InputCheckTypeMaxLength)) {
        return YES;
    }
    //最大字符数
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    
    if ([string length]==0) {
        
        return YES;
    }
    else {
        if ([lang isEqualToString:@"zh-Hans"] && [string isMatchedByRegex:@"[a-zA-Z]"] && [string length]==1) { //如果输入键盘为中文 并且输入的为字母，长度为1（中文输入条上全英文） 就算达到上限也是可以输入的
            
            return YES;
            
        }
        else{
            
            if ([[input text] length]+[string length]-range.length > self.maxLen){
                
                if (self.theCheckMaxBlock) {
                    self.theCheckMaxBlock(YES);
                }
                return NO;
            }
            else {
                if (self.theCheckMaxBlock) {
                    self.theCheckMaxBlock(NO);
                }
                
                return YES;
            }
        }
    }
}

//金额最大检测
-(BOOL)shouldChangeMoney:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (![self charactersCheck:input inRange:range replacementString:string]) {
        return NO;
    }
    
    NSArray * temp = [string arrayOfCaptureComponentsMatchedByRegex:@"[.]"];
    if (temp.count>1) {
        return NO;
    }
    if (temp.count>0) {
        if ([[input text] arrayOfCaptureComponentsMatchedByRegex:@"[.]"].count>0) {
            return NO;
        }
    }
    
    
    NSMutableString * str = [NSMutableString stringWithString:[input text]];
    [str  replaceCharactersInRange:range withString:string];
    
    
    NSRange r = [str rangeOfString:@"."];
    int loc = r.location;
    int pos = str.length - 3;
    if ((loc != NSNotFound) && (loc < pos)) {
        return NO;
    }
    
    double floatValue = str.doubleValue;
    //Debug --> NSLog(@"%f",self.maxLen);
    if (floatValue > self.maxLen) {
        if ([str containsString:@"."]) {
            self.text = [NSString stringWithFormat:@"%0.2f",floatValue];
        }else{
            NSString *overFlowStr = [NSString stringWithFormat:@"%.0f",floatValue];
            self.text =  [overFlowStr substringToIndex:overFlowStr.length-1];
        }
        //越界的策略: 如果超过, 不变就是了!!
        //floatValue = self.maxLen;
        
        [input setText:self.text];
        return  NO;
    }else if (str.length==0) {
        //注意: 这里之前是: self.text = @"0"; 然后return NO
        self.text = @"";
        [input setText:self.text];
        return YES;
    }else if ([[input text] isEqualToString:@"0"]) {
        if ([string rangeOfString:@"."].location == 0) {
            self.text = [NSString stringWithFormat:@"0%@",string];
            [input setText:self.text];
        }else{
            self.text = string;
            [input setText:self.text];
        }
        return NO;
    }else if ([str rangeOfString:@"."].location == 0) {
        self.text = [NSString stringWithFormat:@"0%@",str];
        [input setText:self.text];
        return NO;
    }else{
        
        return YES;
    }
}

-(BOOL)shouldChangeFloat:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (![self charactersCheck:input inRange:range replacementString:string]) {
        return NO;
    }
    
    NSArray * temp = [string arrayOfCaptureComponentsMatchedByRegex:@"[.]"];
    if (temp.count>1) {
        return NO;
    }
    if (temp.count>0) {
        if ([[input text] arrayOfCaptureComponentsMatchedByRegex:@"[.]"].count>0) {
            return NO;
        }
    }
    
    
    NSMutableString * str = [NSMutableString stringWithString:[input text]];
    [str  replaceCharactersInRange:range withString:string];
    
    double floatValue = str.doubleValue;
    if (floatValue > self.maxLen) {
        floatValue = self.maxLen;
        
        self.text = [NSString stringWithFormat:@"%f",floatValue];
        [input setText:self.text];
        return  NO;
    }else if (str.length==0) {
        self.text = @"0";
        [input setText:self.text];
        return NO;
    }else if ([[input text] isEqualToString:@"0"]) {
        if ([string rangeOfString:@"."].location == 0) {
            self.text = [NSString stringWithFormat:@"0%@",string];
            [input setText:self.text];
        }else{
            self.text = string;
            [input setText:self.text];
        }
        return NO;
    }else if ([str rangeOfString:@"."].location == 0) {
        self.text = [NSString stringWithFormat:@"0%@",str];
        [input setText:self.text];
        return NO;
    }else{
        
        return YES;
    }
}
-(BOOL)shouldChangeInt:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (![self charactersCheck:input inRange:range replacementString:string]) {
        return NO;
    }
    NSMutableString * str = [NSMutableString stringWithString:[input text]];
    [str  replaceCharactersInRange:range withString:string];
    
    int intValue = str.intValue;
    intValue = MIN(intValue, self.maxLen);
    
    self.text = [NSString stringWithFormat:@"%d",intValue];
    [input setText:self.text];
    return  NO;
}

-(BOOL)shouldChangeCardNumber:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (![self charactersCheck:input inRange:range replacementString:string]) {
        return NO;
    }
    NSMutableString * str = [NSMutableString stringWithString:[input text]];
    [str  replaceCharactersInRange:range withString:string];
    NSLog(@"插入位置%d-%d", range.location,range.length);
    int intValue = str.intValue;
    NSLog(@"%@--%d",string, intValue);
    
    self.text = [NSString stringWithFormat:@"%d",intValue];
    [input setText:self.text];
    
    return NO;
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    textField.keyboardType = self.keyboardType;
    
    if (_keyboardType == UIKeyboardTypeNumberPad || _keyboardType == UIKeyboardTypeDecimalPad) {
        UIToolbar *keyboardToolBarView = [[UIToolbar alloc] init];
        [keyboardToolBarView sizeToFit];
        //左边的space
        UIBarButtonItem *flexibleButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        //右边的space, 固定为15
        UIBarButtonItem *fixedButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedButtonItem.width = 15;
        //[确定]按钮
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(doneButtonClicked:)];
        [keyboardToolBarView setItems:[NSArray arrayWithObjects:flexibleButtonItem,doneButton,fixedButtonItem, nil]];
        textField.inputAccessoryView = keyboardToolBarView;
    }
    
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.secureTextEntry = self.secureTextEntry;
    if ([self.text isEqualToString:@"0.00"]) {
        self.text = @"";
    }
    //textField.text = self.text;
    //Debug -->NSLog(@"textFieldDidBeginEditing中\ntextField.text = %@",textField.text);
}

- (void)doneButtonClicked:(UIButton*)sender{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL result = YES;
    //这里只是检查输入是否合法,允不允许改变
    switch (self.type & 0x0f) {
        case InputCheckTypeString:
            result = [self shouldChangeString:textField inRange:range replacementString:string];
            break;
        case InputCheckTypeFloat:
            result = [self shouldChangeFloat:textField inRange:range replacementString:string];
            break;
        case InputCheckTypeInt:
            result = [self shouldChangeInt:textField inRange:range replacementString:string];
            break;
        case InputCheckTypeMoney:
            result = [self shouldChangeMoney:textField inRange:range replacementString:string];
            break;
        case InputCheckTypeCardNumber:
            result = [self shouldChangeCardNumber:textField inRange:range replacementString:string];
            
        default:
            break;
    }
    
    //输入合法, 允许用户改变:
    if (result) {
        
        NSMutableString * finalInputString = [NSMutableString stringWithString:textField.text];
        if (finalInputString.length) {
            if ([finalInputString isEqualToString:@"无金额"]) {
                textField.text = @"";
                finalInputString = string.mutableCopy;
            }else{
                [finalInputString  replaceCharactersInRange:range withString:string];
            }
            
        }else{
            finalInputString = @"".mutableCopy;
        }
        
        //NSLog(@"改写前,self.text = %@ ",self.text);
        self.text = finalInputString;
        //NSLog(@"改写后,self.text = %@ ",self.text);
        
        if (self.theContentBlock) {
            self.theContentBlock(finalInputString);
        }
        
        
    }
    return result;
}




- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.text = textField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.backgroundNomarl) {
        if (self.backgroundError && [self finalCheck] != InputCheckErrorNone) {
            [textField setBackground:[UIImage imageNamed:self.backgroundError]];
        }else{
            [textField setBackground:[UIImage imageNamed:self.backgroundNomarl]];
        }
    }
    
    
    switch (self.type & 0x0f) {
        case InputCheckTypeFloat:
            textField.text = [NSString stringWithFormat:@"%f",textField.text.doubleValue];
            self.text = textField.text;
            break;
        case InputCheckTypeInt:
            textField.text = [NSString stringWithFormat:@"%d",textField.text.intValue];
            self.text = textField.text;
            
            if (self.theDidEndEditingBlock) {
                self.theDidEndEditingBlock(textField.text);
            }

            
            break;
            
        case InputCheckTypeMoney: //金额如果为空, 那么会变成0.00
            /*
             干脆啥都不做还更好, 主动给text加上2个0, 总是在越界的时候返回不精准的值
             //兼容double越界的情况
             if ([textField.text compare:@"99999999999999.99" options:NSLiteralSearch]==NSOrderedAscending) {
             textField.text = [NSString stringWithFormat:@"%0.2f",textField.text.doubleValue];
             
             } else {
             textField.text = @"99999999999999.99";
             
             }
             */
            self.text = textField.text;
            if (self.text.floatValue ==0 || self.text.length == 0) {
                if (self.theContentBlock) {
                    self.theContentBlock(@"0.00");
                }
            }
            break;
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:textField];
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    if (self.theContentBlock) {
        self.theContentBlock(nil);
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(enum InputCheckError)finalCheck{
    
    
    if(self.type & InputCheckTypeNotNull){
        if(self.text.length == 0){
            return InputCheckErrorNull;
        }
    }else if(self.text == nil || self.text.length == 0){
        return InputCheckErrorNone;
    }
    
    if (self.type &  InputCheckTypeMinLength) {
        
        if (self.type & 0xf) {
            if([self.text floatValue] < self.minLen){
                return InputCheckErrorSmall;
            }
            
        }else{
            if(self.text.length < self.minLen){
                if (self.minLen == self.maxLen) {
                    return InputCheckErrorOnlyLength;
                }else{
                    return InputCheckErrorShot;
                }
                
            }
        }
    }
    
    if (self.type & InputCheckTypeRegex) {
        if (![self.text isMatchedByRegex:self.regex]) {
            return InputCheckErrorRegex;
        }
    }
    
    return InputCheckErrorNone;
    
}

-(id)copy{
    TOTextInputChecker * result = [[self.class alloc] init];
    result.type = self.type;
    result.maxLen = self.maxLen;
    result.minLen = self.minLen;
    result.characters = self.characters;
    result.text = self.text;
    result.keyboardType = self.keyboardType;
    result.regex = self.regex;
    result.backgroundHighlighted = self.backgroundHighlighted;
    result.backgroundNomarl = self.backgroundNomarl;
    result.backgroundError = self.backgroundError;
    result.backgroundErrorHighlighted = self.backgroundErrorHighlighted;
    result.secureTextEntry = self.secureTextEntry;
    return result;
}

-(TFContentBlock)theContentBlock{
    if (!_theContentBlock) {
        TFContentBlock contentBlock = objc_getAssociatedObject(self, &CURRENT_CONTENT_BLOCK_KEY);
        _theContentBlock = contentBlock;
    }
    return _theContentBlock;
}

-(TFdidEndEditing)theDidEndEditingBlock{
    if (!_theDidEndEditingBlock) {
        TFdidEndEditing theBlock = objc_getAssociatedObject(self, &DID_END_EDITING_BLOCK_KEY);
        _theDidEndEditingBlock = theBlock;
    }
    return _theDidEndEditingBlock;
}



@end
