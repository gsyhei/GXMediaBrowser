//
//  UIViewController+GXAdd.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2017/12/25.
//  Copyright © 2017年 protruly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GXAdd)

/**
 加载xib viewController

 @return viewController
 */
+ (instancetype)xibViewController;

/**
 屏幕强制旋转

 @param orientation 旋转方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 添加返回按钮

 @param image 按钮图片
 */
- (void)addBackBarButtonItem:(NSString*)image;
- (void)addBackBarButtonItemWithImage:(NSString*)image action:(SEL)action;

/**
 dismiss到rootViewController

 @param animated 是否执行动画
 @param completion 结束回调
 */
- (void)dismissRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 dismiss到vcClass

 @param vcClass 需要dismiss回到的VC
 @param animated 是否执行动画
 @param completion 结束回调
 */
- (void)dismissToViewControllerClass:(Class)vcClass animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 pop到vcClass

 @param vcClass 需要pop回到的VC
 @param animated 是否执行动画
 */
- (void)popToViewControllerClass:(Class)vcClass animated:(BOOL)animated;

@end
