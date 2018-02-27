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
#import "GXCommonMacro.h"

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
