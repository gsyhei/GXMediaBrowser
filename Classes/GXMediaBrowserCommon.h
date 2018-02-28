//
//  GXMediaBrowserCommon.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#ifndef GXMediaBrowserCommon_h
#define GXMediaBrowserCommon_h

#import <UIKit/UIKit.h>

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

/** Gap between image */
static CGFloat    const GX_PageGap                   = 40.0;

/** ZoomableImageScrollView can zoom to how much bigger than original image */
static CGFloat    const GX_ZoomBigger                = 1.6f;

/** ZoomableImageScrollView can zoom to how much smaller than original image */
static CGFloat    const GX_ZoomSmaller               = 1.0f;

/** Animation duration */
static CGFloat    const GX_AnimationDefaultDuration  = 0.3f;
static CGFloat    const GX_AnimationSpringDuration   = 0.5f;

/** usingSpring Animation */
static CGFloat    const GX_UsingSpringWithDamping    = 0.7f;
static CGFloat    const GX_InitialSpringVelocity     = 1.0f;

/*!
 *  @brief 资源类型
 */
typedef NS_ENUM(NSInteger, GXAssetType) {
    /** 图片 */
    GXAssetTypeImage   = 0,
    /** 视频 */
    GXAssetTypeVideo   = 1,
    /** VR图片 */
    GXAssetTypeVRImage = 2,
    /** VR视频 */
    GXAssetTypeVRVideo = 3,
};

/** background color */
#define GX_BACKGROUND_COLOR RGB(249, 249, 249)

/** 适配图片全屏尺寸 */
static inline CGRect coverImageFrameToFullScreenFrame(UIImage* image) {
    if (!image) return CGRectZero;
    
    CGFloat scaleW = SCREEN_WIDTH / image.size.width;
    CGFloat scaleH = SCREEN_HEIGHT / image.size.height;
    if (scaleW < scaleH) {
        CGFloat x = 0.0;
        CGFloat w = SCREEN_WIDTH;
        CGFloat h = image.size.height * scaleW;
        CGFloat y = (SCREEN_HEIGHT - h) * 0.5;
        
        return CGRectMake(x, y, w, h);
    } else {
        CGFloat y = 0.0;
        CGFloat h = SCREEN_HEIGHT;
        CGFloat w = image.size.width * scaleH;
        CGFloat x = (SCREEN_WIDTH - w) * 0.5;;
        
        return CGRectMake(x, y, w, h);
    }
}

#endif /* GXMediaBrowserCommon_h */
