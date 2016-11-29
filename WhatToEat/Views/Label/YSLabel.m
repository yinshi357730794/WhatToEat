//
//  YSLabel.m
//  CI990
//
//  Created by YinShi on 16/3/8.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "YSLabel.h"

@implementation YSLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    NSInteger numberCount  = 0;
    NSInteger numberCount2 = 0;
    for (NSInteger i = 0; i< self.text.length; i++) {
        if ([self.text characterAtIndex:i] == 49) {
            numberCount ++;
        }else if ([self.text characterAtIndex:i] == 57){
            numberCount2++;
        }
        
    }
    //如果字符中有超过16个1 || 小于 16个9 , 那么按照1行显示
    if (numberCount >=16  || numberCount2 <= 16) {
        return [super textRectForBounds:bounds limitedToNumberOfLines:1];

    } else {
        return [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];

    }
}


-(void) drawTextInRect:(CGRect)inFrame {
    CGRect draw = [self textRectForBounds:inFrame limitedToNumberOfLines:[self numberOfLines]];
    
    draw.origin = CGPointZero;
    
    [super drawTextInRect:draw];
}


@end
