//
//  CRMacros.h
//  CRBoost
//
//  Created by Peter on 9/13/13.
//  Copyright (c) Sinosun Technology Co., Ltd. All rights reserved..
//

#ifndef CRMacros_h
#define CRMacros_h

#pragma mark -
#pragma mark Hardware & OS

#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc_weak) && (!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#define __weak_delegate __weak
#else
#define weak_delegate unsafe_unretained
#define __weak_delegate __unsafe_unretained
#endif

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#define CR_iOS
typedef CGRect NSRect;
typedef CGSize NSSize;
#else
#define CR_OSX
typedef NSView UIView;
#endif

#ifdef CR_iOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#endif


//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//-------------------获取设备大小-------------------------


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define FLLog(FORMAT, ...) fprintf(stderr,"\n在Function:%s中 Line:%d \nLog:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define FLdLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


#define ITTDEBUG
#define ITTLOGLEVEL_INFO     10
#define ITTLOGLEVEL_WARNING  3
#define ITTLOGLEVEL_ERROR    1

#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)  ((void)0)
#endif

#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
ITTDPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif

#define ITTAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)

//---------------------打印日志--------------------------


//----------------------系统----------------------------

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//----------------------系统----------------------------


//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil



//----------------------内存----------------------------


//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------



//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//----------------------颜色类--------------------------



//----------------------其他----------------------------

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]


//定义一个API
#define APIURL                @"http://xxxxx/"
//登陆API
#define APILogin              [APIURL stringByAppendingString:@"Login"]

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)



//单例化一个类
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}


#pragma mark -
#pragma mark foundation
//==================object==================
#define CRNull [NSNull null]
//==================string==================
#define CRString(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]
#define CRStringNum(number) CRString(@"%ld", (long)number)
#define $str(...) [NSString stringWithFormat:__VA_ARGS__]
//==================array==================
#define CRMArray(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]
//==================dictionary==================
#define CRMDictionary(key, obj) [NSMutableDictionary dictionaryWithObject:obj forKey:key]
//==================date==================
#define CRCOMPS_DATE NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
#define CRCOMPS_TIME NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit

#pragma mark -
#pragma mark notification
#define CRRegisterNotification(sel, nam) CRRegisterNotification3(sel, nam, nil)
#define CRRegisterNotification3(sel, nam, obj) CRRegisterNotification4(self, sel, nam, obj)
#define CRRegisterNotification4(obs, sel, nam, obj) [[NSNotificationCenter defaultCenter] addObserver:obs selector:SELE(sel) name:nam object:obj]
#define CRUnregisterNotification(obs) CRUnregisterNotification2(obs, nil)
#define CRUnregisterNotification2(obs, nam) CRUnregisterNotification3(obs, nam, nil)
#define CRUnregisterNotification3(obs, nam, obj) [[NSNotificationCenter defaultCenter] removeObserver:obs name:nam object:obj]
#define CRPostNotification(name) CRPostNotification2(name, nil)
#define CRPostNotification2(name, obj) CRPostNotification3(name, obj, nil)
#define CRPostNotification3(name, obj, info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info]

#pragma mark -
#pragma mark image
//==================image==================
#define CRImageNamed(name) [UIImage imageNamed:name]
#define CRImageFormated(fmt, ...) CRImageNamed(CRString(fmt, ##__VA_ARGS__))
#define CRImageFiled(path) [UIImage imageWithContentsOfFile:path]
#define CRImageViewNamed(name) [[UIImageView alloc] initWithImage:CRImageNamed(name)]
#define CRImageViewFormated(fmt, ...) [[UIImageView alloc] initWithImage:CRImageFormated(fmt, ##__VA_ARGS__)]
#define CRImageViewFiled(path) [[UIImageView alloc] initWithImage:CRImageFiled(path)]

#pragma mark -
#pragma mark device
#ifdef CR_iOS
//==================model==================
#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

#if TARGET_OS_IPHONE
// iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
// iPhone Simulator
#endif

// application status
#define CRAPP_IN_BACKGROUND (CRSharedApp.applicationState == UIApplicationStateBackground)
#define CRDisableAppIdleTimer(flag) CRSharedApp.idleTimerDisabled = (flag)

//==================network==================
#define CRDisplayNetworkIndicator(flag) [CRSharedApp setNetworkActivityIndicatorVisible:(flag)]

#pragma mark -
#pragma mark system
//==================system version==================
#define CROSVersionEqualTo(v) ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define CROSVersionGreaterThan(v) ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define CROSVersionNotLessThan(v) ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define CROSVersionLessThan(v) ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define CROSVersionNotGreaterThan(v) ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark -
#pragma mark App Default
//==================user defaults==================
#define CRUserDefaults [NSUserDefaults standardUserDefaults]
#define CRUserObj(key) [CRUserDefaults objectForKey:(key)]
#define CRUserBOOL(key) [CRUserDefaults boolForKey:(key)]
#define CRUserInteger(key) [CRUserDefaults integerForKey:(key)]
#define CRUserSetObj(obj, key) [CRUserDefaults setObject:(obj)forKey:(key)]
#define CRUserSetBOOL(boo, key) [CRUserDefaults setBool:(boo)forKey:(key)]
#define CRUserRemoveObj(key) [CRUserDefaults removeObjectForKey:(key)]

#define CRSharedApp [UIApplication sharedApplication]
#define CRAppDelegate ((AppDelegate *)[CRSharedApp delegate])
#define CRNotificationCenter [NSNotificationCenter defaultCenter]
#define CRCurrentDevice [UIDevice currentDevice]

#define MainBundle [NSBundle mainBundle]
#define CRMainScreen [UIScreen mainScreen]
#define CRCurrentLanguage [NSLocale preferredLanguages][0]
#define CRScreenScaleFactor [CRMainScreen scale]
#define CRFileMgr [NSFileManager defaultManager]

#define AppRootWindow  [(AppDelegate *)([UIApplication sharedApplication].delegate) window]

#define AppCurrentUser     [SSAppManager sharedManager].loginUser
#define AppCurrentDSSUser     [SSAppManager sharedManager].loginDSSUser //已登录的授权棒用户
#define AppAuthorListener     [SSAppManager sharedManager].listener


#pragma mark -
#pragma mark GCD
//==================block==================
#define CRBackgroundGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define CRMainGCD(block) dispatch_async(dispatch_get_main_queue(), block)
#define CRWeekRef(obj) __weak typeof(obj) __##obj = obj
#define CRBlockRef(obj) __block typeof(obj) __##obj = obj
typedef void (^CallbackTask)(void);

//==================selector==================
#define CRIfReturn(con)                                                                                                                                                                                \
if (con)                                                                                                                                                                                           \
return
#define SELE(sel) @selector(sel)

//==================singleton==================
#ifndef CRSingleton
#define CRSingleton(classname, method)                                                                                                                                                                 \
+(classname *)shared##method {                                                                                                                                                                     \
static dispatch_once_t pred;                                                                                                                                                                   \
__strong static classname *shared##classname = nil;                                                                                                                                            \
dispatch_once(&pred, ^{                                                                                                                                                                        \
shared##classname = [[self alloc] init];                                                                                                                                                   \
});                                                                                                                                                                                            \
return shared##classname;                                                                                                                                                                      \
}
#endif

#define CRManager(classname) CRSingleton(classname, Manager)
#define CRProcess(classname) CRSingleton(classname, Process)

#pragma mark -
#pragma mark color
//==================color==================
#define CRCOLOR_CLEAR [UIColor clearColor]
#define CRCOLOR_WHITE [UIColor whiteColor]
#define CRCOLOR_BLACK [UIColor blackColor]
#define CRCOLOR_RED [UIColor redColor]
#define CRColorPattern(name) [UIColor colorWithPatternImage:UIIMAGE_NAMED(name)]

//导航栏默认颜色
#define CRDefaultNavigationBarColor  CRRGB(2, 179, 99)


// r, g, b range from 0 - 1.0
#define CRRGB_F(r, g, b) CRRGBA_F(r, g, b, 1.0)
#define CRRGBA_F(r, g, b, a) [UIColor colorWithRed:(r)green:(g)blue:(b)alpha:(a)]
// r, g, b range from 0 - 255
#define CRRGB(r, g, b) CRRGBA(r, g, b, 1.0)
#define CRRGBA(r, g, b, a) CRRGBA_F((r) / 255.f, (g) / 255.f, (b) / 255.f, a)
// rgbValue is a Hex vaule without prefix 0x
#define CRRGB_X(rgb) CRRGBA_X(rgb, 1.0)
#define CRRGBA_X(rgb, a) CRRGBA((float)((0x##rgb & 0xFF0000) >> 16), (float)((0x##rgb & 0xFF00) >> 8), (float)(0x##rgb & 0xFF), (a))

//#pragma mark -
//#pragma mark log
////==================log==================
//#ifndef __OPTIMIZE__
//#   define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#   define NSLog(...)
//#endif

#ifdef DEBUG // debug
#define CRLog(fmt, ...) NSLog((@"%@->%@ <Line %d>: " fmt), NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, ##__VA_ARGS__)

#define _ptp(point) DLOG(@"CGPoint: {%.0f, %.0f}", (point).x, (point).y)
#define _pts(size) DLOG(@"CGSize: {%.0f, %.0f}", (size).width, (size).height)
#define _ptr(rect) DLOG(@"CGRect: {{%.1f, %.1f}, {%.1f, %.1f}}", (rect).origin.x, (rect).origin.y, (rect).size.width, (rect).size.height)
#define _pto(obj) DLOG(@"object %s: %@", #obj, [(obj)description])
#define _ptb(boo) DLOG(@"boolean value %s: %@", #boo, boo ? @"YES" : @"NO")
#define _pti(i) DLOG(@"integer value %s: %ld", #i, (long)i)
#define _ptm NSLog(@"\nmark called %s, at line %d", __PRETTY_FUNCTION__, __LINE__)
#define _if(con)                                                                                                                                                                                       \
if (con)                                                                                                                                                                                           \
NSLog(@"\ncondition matched %s, at line %d", __PRETTY_FUNCTION__, __LINE__)

#define ULOG(fmt, ...)                                                                                                                                                                                 \
{                                                                                                                                                                                                  \
NSString *title = [NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__];                                                                                               \
NSString *msg = [NSString stringWithFormat:fmt, ##__VA_ARGS__];                                                                                                                                \
TSAlertView *alert = [[TSAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];                                                         \
[alert show];                                                                                                                                                                                  \
}


#define showAlert(title,detail)  \
UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:detail delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];    \
[alert show]; \


#else // release
#define CRLog(...)
#define ULOG(...)
#define _ptp(point)
#define _pts(size)
#define _ptr(rect)
#define _ptb(boo)
#define _pti(i)
#define _pto(obj)
#define _ptm
#define _if(con)

#define showAlert(title,detail)

#endif

#endif
