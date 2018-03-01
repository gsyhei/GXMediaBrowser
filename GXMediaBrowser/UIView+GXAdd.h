//
//  UIView+GXAdd.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2017/12/25.
//  Copyright © 2017年 protruly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GXAdd)

/*!
 *  @brief 加载xib view
 *
 *  @param owner 所有者
 *
 *  @return  view
 */
+ (instancetype)sharedView:(id)owner;

/*!
 *  @brief 加载xib view
 *
 *  @param owner    所有者
 *  @param nibNamed xib名
 *  @param index    xib索引
 *
 *  @return view
 */
+ (instancetype)sharedView:(id)owner loadNibNamed:(NSString*)nibNamed index:(NSInteger)index;

/*!
 *  @brief 获取nib
 *
 *  @return nib
 */
+ (UINib *)nib;

/*!
 *  @brief 圆形风格view
 */
- (void)styleCircle;

/*!
 *  @brief 删除所以子view
 */
- (void)removeAllSubviews;

/*!
 *  @brief 形状裁剪（遮罩）
 *
 *  @param image 需要的遮罩图片
 */
- (void)maskImage:(UIImage *)image;

/*!
 *  @brief 快照
 *
 *  @param afterUpdates 适合scale
 *
 *  @return 快照图片
 */
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
- (UIImage *)snapshotImage;

/*!
 *  @brief 获取当前window
 *
 *  @return 当前可用window
 */
+ (UIWindow*)currentWindow;

/*!
 *  @brief 获得响应控制器
 *
 *  @return vc
 */
- (UIViewController *)viewController;

/*!
 *  @brief 设置矩形某个角的圆角边
 *
 *  @param corners 角度
 *  @param radius  半径
 */
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

/*!
 *  @brief 快照PDF
 *
 *  @return PDF data
 */
- (NSData *)snapshotPDF;

/*!
 *  @brief 设置layer阴影
 *
 *  @param color 阴影颜色
 *  @param offset 阴影偏移
 *  @param radius 阴影半径
 */
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/*!
 *  @brief frame属性添加
 */
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

@end

@interface UITableViewCell (GXAdd)

/**
 *  下划线左对齐
 */
- (void)setSeparatorLeadingLeft;

/**
 *  获取cell重用标识
 *
 *  @return cell标识
 */
+ (NSString *)cellReuseIdentifier;

@end

@interface UITableViewHeaderFooterView (GXAdd)

/**
 *  获取view重用标识
 *
 *  @return view标识
 */
+ (NSString *)viewReuseIdentifier;

@end

@interface UICollectionViewCell (GXAdd)

/**
 *  获取cell重用标识
 *
 *  @return cell标识
 */
+ (NSString *)cellReuseIdentifier;

@end

@interface UICollectionReusableView (GXAdd)

/**
 *  获取view重用标识
 *
 *  @return view标识
 */
+ (NSString *)viewReuseIdentifier;

@end
