//
//  MacroDefine.h
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

/*--------------------------------开发中常用到的宏定义--------------------------------------*/
#import "AppDelegate.h"
//系统目录
#define kDocuments  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


//----------方法简写-------
#define mAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define mWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define mKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define mUserDefaults       [NSUserDefaults standardUserDefaults]
#define mNotificationCenter [NSNotificationCenter defaultCenter]

#define mStringEncoding(str) [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

//加载图片
#define mImageByName(name)        [UIImage imageNamed:name]
#define mImageByPath(name, ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]
//NSString - NSURL
#define mUrlWithString(string)      [NSURL URLWithString:string]

//以tag读取View
#define mViewByTag(parentView, tag, Class)  (Class *)[parentView viewWithTag:tag]
//读取Xib文件的类
#define mViewByNib(Class, owner) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] lastObject]

//id对象与NSData之间转换
#define mObjectToData(object)   [NSKeyedArchiver archivedDataWithRootObject:object]
#define mDataToObject(data)     [NSKeyedUnarchiver unarchiveObjectWithData:data]

//度弧度转换
#define mDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define mRadianToDegrees(radian) (radian*180.0) / (M_PI)

//颜色转换
#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]
#define mRGBToColorAlpha(rgb,x) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:x]

//简单的以AlertView显示提示信息
#define mAlertView(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];

// ------------frame 快捷用法-------------
static inline CGFloat GG_X(UIView *view){ return view.frame.origin.x;}
static inline CGFloat GG_Y(UIView *view){ return view.frame.origin.y;}
static inline CGFloat GG_W(UIView *view){ return view.frame.size.width;}
static inline CGFloat GG_H(UIView *view){ return view.frame.size.height;}
static inline CGFloat GG_BOTTOM_Y(UIView *view){ return GG_Y(view) + GG_H(view);};
static inline CGFloat GG_RIGHT_X(UIView *view){ return GG_X(view) + GG_W(view);};


//----------页面设计相关-------

#define mNavBarHeight         44
#define mTabBarHeight         49
#define mScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight         ([UIScreen mainScreen].bounds.size.height)
#define mNavBarWithStateHeight 64
#define mCommonHeight          (mScreenHeight-mNavBarWithStateHeight)
#define mSystemFont(size)     [UIFont systemFontOfSize:RELATIVE_WIDTH(size)]

//----------设备系统相关---------
#define mRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define mIsiP5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define mIsPad    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define mIsiphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define mSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define mCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define mAPPVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define mFirstLaunch     mAPPVersion     //以系统版本来判断是否是第一次启动，包括升级后启动。
#define mFirstRun        @"firstRun"     //判断是否为第一次运行，升级后启动不算是第一次运行

//--------调试相关-------
#define mObjectIsArray(obj) ([obj isKindOfClass:[NSArray class]]?YES:NO)
#define mObjectIsDictionary(obj) ([obj isKindOfClass:[NSDictionary class]]?YES:NO)

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
#define mSafeRelease(object)     [object release];  x=nil
#endif

//调试模式下输入NSLog，发布后不再输入。
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#if mTargetOSiPhone
//iPhone Device
#endif

#if mTargetOSiPhoneSimulator
//iPhone Simulator
#endif

/**
 *  跳转延时
 */
#define DELAY_TIME 0.5


#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define WIN_SIZE [UIScreen mainScreen].bounds.size
#define WIN_WIDTH [UIScreen mainScreen].bounds.size.width
#define WIN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE6_LATER ((WIN_WIDTH >= 375 && WIN_HEIGHT >= 667) == YES ? YES:NO)

#define BASE_WIDTH  750.0
#define BASE_HEIGHT 1334.0

#define RELATIVE_WIDTH(w) WIN_WIDTH/BASE_WIDTH * w



//分割线颜色
#define halvingLineColor mRGBToColor(0xDBDBDB)
//主题色
#define blueBackGround mRGBToColor(0x007aff)
//次文字
#define grayTextcolor mRGBToColor(0xA0A0A0)
//标准红
#define redBack  mRGBToColor(0xff404A)

#define grayBackGround  mRGBToColor(0xf3f3f7)




