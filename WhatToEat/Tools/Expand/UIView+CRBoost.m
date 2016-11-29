//
//  UIView+Position.m
//  CRBoost
//
//  Created by Peter on 9/13/13.
//  Copyright (c) Sinosun Technology Co., Ltd. All rights reserved..
//

#import "UIView+CRBoost.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "CRMacros.h"

@interface UIView ()
@property(nonatomic, strong) UIView *topBanner;
@property(nonatomic, strong) KeyboardStateTask keyboardWillShowTask;
@property(nonatomic, strong) KeyboardStateTask keyboardWillHideTask;
@end

@implementation UIView (CRBoost)
//- (void)dealloc
//{
//    [self cleanupKeyboardWillShowObserver];
//    [self cleanupKeyboardWillHideObserver];
//}

#pragma mark -
#pragma mark getter
- (CGFloat)x {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)y {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (CGFloat)rightMostX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)topY { //(x, y): (0, 0)
    return CGRectGetMaxY(self.frame);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGPoint)bottomRightPoint {
    return CGPointMake(self.rightMostX, self.y);
}

- (CGPoint)topLeftPoint {
    return CGPointMake(self.x, self.topY);
}

- (CGPoint)topRightPoint {
    return CGPointMake(self.rightMostX, self.topY);
}

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (UIView *)topLayerSubviewWithTag:(NSInteger)tag {
    for (UIView *view in self.subviews) {
        if (view.tag == tag) {
            return view;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark setter
- (void)setX:(CGFloat)x {
    self.frame = (CGRect){x, self.y, self.size};
}

- (void)setY:(CGFloat)y {
    self.frame = (CGRect){self.x, y, self.size};
}

- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setWidth:(CGFloat)width {
    self.frame = (CGRect){self.origin, width, self.height};
}

- (void)setHeight:(CGFloat)height {
    self.frame = (CGRect){self.origin, self.width, height};
}

- (void)setRightMostX:(CGFloat)rightMostX {
    self.frame = (CGRect){rightMostX - self.width, self.y, self.size};
}

- (void)setTopY:(CGFloat)topY {
    self.frame = (CGRect){self.x, topY - self.height, self.size};
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect){origin, self.size};
}

- (void)setBottomRightPoint:(CGPoint)bottomRightPoint {
    self.frame = (CGRect){bottomRightPoint.x - self.width, bottomRightPoint.y, self.size};
}

- (void)setTopLeftPoint:(CGPoint)topLeftPoint {
    self.frame = (CGRect){topLeftPoint.x, topLeftPoint.y - self.height, self.size};
}

- (void)setTopRightPoint:(CGPoint)topRightPoint {
    self.frame = (CGRect){topRightPoint.x - self.width, topRightPoint.y - self.height, self.size};
}

- (void)setSize:(CGSize)size {
    self.frame = (CGRect){self.origin, size};
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    CRIfReturn(cornerRadius < 0);
    self.layer.cornerRadius = cornerRadius;
    
    if (self.topBanner && !self.clipsToBounds) {
        [self adjustTopBannerToCorner];
        //        self.clipsToBounds = YES;
    }
}

#pragma mark -
#pragma mark convenient
+ (UIView *)viewWithColor:(UIColor *)color size:(CGSize)size {
    UIView *view = [[self alloc] initWithFrame:(CGRect){0, 0, size}];
    view.backgroundColor = color;
    
    return view;
}

#pragma mark -
#pragma mark keyboard
static char keyboardWillShowTaskKey;
- (void)setupTaskOnKeybardWillShow:(KeyboardStateTask)task {
    [self cleanupKeyboardWillShowObserver];
    objc_setAssociatedObject(self, &keyboardWillShowTaskKey, task, OBJC_ASSOCIATION_COPY);
    
    CRRegisterNotification(keyboardWillShow:, UIKeyboardWillShowNotification);
}

- (KeyboardStateTask)keyboardWillShowTask {
    return objc_getAssociatedObject(self, &keyboardWillShowTaskKey);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect rectUser = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect rectKeyboard = [self convertRect:rectUser fromView:nil];
    self.keyboardWillShowTask(rectKeyboard);
    
    //    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] ;
}

static char keyboardWillHideTaskKey;
- (void)setupTaskOnKeybardWillHide:(KeyboardStateTask)task {
    [self cleanupKeyboardWillHideObserver];
    objc_setAssociatedObject(self, &keyboardWillHideTaskKey, task, OBJC_ASSOCIATION_COPY);
    
    CRRegisterNotification(keyboardWillHide:, UIKeyboardWillHideNotification);
}

- (KeyboardStateTask)keyboardWillHideTask {
    return objc_getAssociatedObject(self, &keyboardWillHideTaskKey);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect rectUser = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect rectKeyboard = [self convertRect:rectUser fromView:nil];
    self.keyboardWillHideTask(rectKeyboard);
}

- (void)cleanupKeyboardWillShowObserver {
    if (self.keyboardWillShowTask) {
        objc_setAssociatedObject(self, &keyboardWillShowTaskKey, nil, OBJC_ASSOCIATION_ASSIGN);
        CRUnregisterNotification2(self, UIKeyboardWillShowNotification);
    }
}

- (void)cleanupKeyboardWillHideObserver {
    if (self.keyboardWillHideTask) {
        objc_setAssociatedObject(self, &keyboardWillHideTaskKey, nil, OBJC_ASSOCIATION_ASSIGN);
        CRUnregisterNotification2(self, UIKeyboardWillHideNotification);
    }
}

#pragma mark -
#pragma mark top banner
static char topBannerKey;
- (void)setTopBanner:(UIView *)topBanner {
    objc_setAssociatedObject(self, &topBannerKey, topBanner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)topBanner {
    return objc_getAssociatedObject(self, &topBannerKey);
}

- (void)setupTopBannerColored:(UIColor *)color height:(CGFloat)height {
    height = MIN(height, self.height);
    self.topBanner = [UIView viewWithColor:color size:CGSizeMake(self.width, height)];
    [self insertSubview:self.topBanner atIndex:0];
    
    if (self.cornerRadius > 0.01 && !self.clipsToBounds) {
        [self adjustTopBannerToCorner];
        //        self.clipsToBounds = YES;
    }
}

- (void)adjustTopBannerToCorner {
    self.topBanner.layer.cornerRadius = self.cornerRadius;
    CGFloat radius = ceilf(self.cornerRadius);
    UIView *colorView = [UIView viewWithColor:self.topBanner.backgroundColor size:CGSizeMake(self.width, radius)];
    colorView.y = self.topBanner.height - radius;
    [self.topBanner addSubview:colorView];
}

- (void)sendTopBannerToBack {
    if (self.topBanner) {
        [self sendSubviewToBack:self.topBanner];
    }
}

#pragma mark -
#pragma mark animation
- (void)pulsateOnce {
    CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleUp.duration = 0.125;
    scaleUp.repeatCount = 1;
    scaleUp.autoreverses = YES;
    scaleUp.removedOnCompletion = YES;
    scaleUp.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    
    [self.layer addAnimation:scaleUp forKey:@"pulsate"];
}

#pragma mark -
#pragma mark gesture
- (UITapGestureRecognizer *)addTapRecognizer:(id)target action:(SEL)action {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:recognizer];
        }
    }
    
    if (!self.userInteractionEnabled)
        self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    return tapRecognizer;
}

- (void)whenTouches:(NSUInteger)numTouches tapped:(NSUInteger)numTaps handler:(CallbackTask)task {
}
- (void)whenTapped:(CallbackTask)task {
    // Adds a recognizer for one finger tapping once.
}
- (void)whenDoubleTapped:(CallbackTask)task {
}
- (void)eachSubview:(void (^)(UIView *view))task {
}
- (void)onTouchDow:(CallbackTask)task {
}
- (void)onTouchMove:(CallbackTask)task {
}
- (void)onTouchUp:(CallbackTask)task {
}

- (void)removeAllSubviews {
    while (self.subviews.count){
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end

@implementation UIView (FindFirstResponder)

-(id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView* view in self.subviews) {
        id responder = [view findFirstResponder];
        if (responder) {
            return responder;
        }
    }
    return nil;
}

- (void)resignResponder
{
    UIView *view = [self    findFirstResponder];
    [view   resignFirstResponder];
}

@end
