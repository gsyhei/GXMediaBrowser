//
//  GXMediaAnimationDelegate.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXMediaBrowserCommon.h"

NS_ASSUME_NONNULL_BEGIN
@interface GXMediaAnimationDelegate : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate>
/** push/present方式弹出视图，默认present */
@property (nonatomic, assign) BOOL isNavigationPush;
@property (nonatomic,   weak, readonly) UICollectionView *collectionView;

- (void)configureTransition:(nullable UIViewController*)presentingViewController
             collectionView:(nullable UICollectionView*)collectionView
        transitionIndexPath:(nullable NSIndexPath*)transitionIndexPath
            transitionImage:(UIImage*)transitionImage;

@end
NS_ASSUME_NONNULL_END
