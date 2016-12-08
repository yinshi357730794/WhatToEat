//
//  UIView+Position.h
//  CRBoost
//
//  Created by Peter on 9/13/13.
//  Copyright (c) Sinosun Technology Co., Ltd. All rights reserved..
//

#import <UIKit/UIKit.h>

typedef void (^KeyboardStateTask)(CGRect rect);

@interface UIView (CRBoost)

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

@property(nonatomic, assign) CGFloat rightMostX;
@property(nonatomic, assign) CGFloat topY;
@property(nonatomic, assign) CGPoint origin;
@property(nonatomic, assign) CGPoint bottomRightPoint;
@property(nonatomic, assign) CGPoint topLeftPoint;
@property(nonatomic, assign) CGPoint topRightPoint;
@property(nonatomic, assign) CGSize size;

@property(nonatomic, assign) CGFloat cornerRadius;

+ (UIView *)viewWithColor:(UIColor *)color size:(CGSize)size;

- (UIView *)topLayerSubviewWithTag:(NSInteger)tag;

- (void)pulsateOnce;

// keyboard
- (void)setupTaskOnKeybardWillShow:(KeyboardStateTask)task;
- (void)setupTaskOnKeybardWillHide:(KeyboardStateTask)task;
- (void)cleanupKeyboardWillShowObserver;
- (void)cleanupKeyboardWillHideObserver;

// gesture
- (UITapGestureRecognizer *)addTapRecognizer:(id)target action:(SEL)action;

/**
 * add a top banner to the view, same width as self
 *
 * @param height the height of the top banner
 * @discussion be careful when use this method, the top banner should be at the bottom of the view hierarchy
 */
- (void)setupTopBannerColored:(UIColor *)color height:(CGFloat)height;
/**
 * should call this method after sendSubviewToBack: excuted when the top banner exists.
 */
- (void)sendTopBannerToBack;

- (void)removeAllSubviews;

@end

@interface UIView (FindFirstResponder)

-(id)findFirstResponder;

- (void)resignResponder;

@end
