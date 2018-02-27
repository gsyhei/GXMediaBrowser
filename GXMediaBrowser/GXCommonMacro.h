//
//  GXCommonMacro.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2017/12/25.
//  Copyright © 2017年 protruly. All rights reserved.
//

#ifndef GXCommonMacro_h
#define GXCommonMacro_h

// 屏幕尺寸
#define SCREEN_BOUNDS                [[UIScreen mainScreen] bounds]
// 屏幕高度
#define SCREEN_HEIGHT                [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH                 [[UIScreen mainScreen] bounds].size.width
// 屏幕比例
#define SCREEN_SCALE                 [UIScreen mainScreen].scale
// 状态栏高度
#define SCREEN_STATUSBAR_HEIGHT      [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define SCREEN_NAVIGATIONBAR_HEIGHT  self.navigationController.navigationBar.frame.size.height
// 导航栏和状态栏的高度
#define SCREEN_TOP_HEIGHT            (SCREEN_STATUSBAR_HEIGHT + SCREEN_NAVIGATIONBAR_HEIGHT)
// 底部Tabbar高度
#define SCREEN_TABBAR_HEIGHT         self.tabBarController.tabBar.frame.size.height

// 颜色RGBA
#define RGBA(r,g,b,a)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
// 颜色RGB
#define RGB(r,g,b)                   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
// 颜色16进制
#define UIColorFromRGBA(rgbValue,alphaValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

// 快速定义一个weakSelf 用于block
#define WEAK_SELF(weakSelf)          __weak __typeof(&*self)weakSelf = self
// IOS版本判断(例：v = @"10.0")
#define IOS_OR_LATER(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
// iPhoneX按尺寸判断
#define IS_IPHONE_X                  (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f)

#endif /* GXCommonMacro_h */
