//
//  GXMediaAnimationDelegate.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  如果为UICollectionView类型的相册预览可以不用设置这个代理
 *  如果pop/back的位置一样只需设置popFromRect
 */
@protocol GXMediaAnimationTransitionDataSource<NSObject>
@optional
@property (nonatomic, assign) CGRect popFromRect;
@property (nonatomic, assign) CGRect backToRect;
@end

NS_ASSUME_NONNULL_BEGIN
@interface GXMediaAnimationDelegate : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate>
/** push/present方式弹出视图，默认present */
@property (nonatomic, assign) BOOL isNavigationPush;
/** 如果为UICollectionView浏览，开放全局只读属性方便读取 */
@property (nonatomic,   weak, readonly) UICollectionView *collectionView;
/** 自定义过渡rect代理设置（当为UICollectionView浏览时不需要设置） */
@property (nonatomic,   weak) id<GXMediaAnimationTransitionDataSource> dataSource;

- (void)configureTransition:(nullable UIViewController*)presentingViewController
             collectionView:(nullable UICollectionView*)collectionView
        transitionIndexPath:(nullable NSIndexPath*)transitionIndexPath
            transitionImage:(UIImage*)transitionImage;
@end
NS_ASSUME_NONNULL_END
