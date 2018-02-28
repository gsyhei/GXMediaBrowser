//
//  GXMediaAnimationDelegate.m
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "GXMediaAnimationDelegate.h"
#import "GXMediaBrowserCommon.h"
#import "GXMediaBrowser.h"
#import "GXMediaBaseCell.h"

@interface GXMediaAnimationDelegate ()
@property (nonatomic,   weak) UIViewController *presentingViewController;
@property (nonatomic,   weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) BOOL isPresentAnimationing;
@property (nonatomic, assign) BOOL interacting;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@end

@implementation GXMediaAnimationDelegate

- (void)configureTransition:(UIViewController*)presentingViewController
             collectionView:(UICollectionView*)collectionView
        transitionIndexPath:(NSIndexPath*)transitionIndexPath
            transitionImage:(UIImage*)transitionImage
{
    if (presentingViewController) {
        self.presentingViewController = presentingViewController;
        UIScreenEdgePanGestureRecognizer *panEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureHandler:)];
        panEdgeGesture.edges = UIRectEdgeLeft;
        [presentingViewController.view addGestureRecognizer:panEdgeGesture];
    }
    self.collectionView = collectionView;
    self.indexPath = transitionIndexPath;
    self.selectedImage = transitionImage;
}

- (void)screenEdgePanGestureHandler:(UIScreenEdgePanGestureRecognizer*)gesture {
    UIViewController *toView = self.presentingViewController;
    CGFloat progress = [gesture translationInView:toView.view].x / (toView.view.bounds.size.width);
    progress = MIN(1.0, MAX(0.0, progress));
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.interacting = YES;
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        if (self.isNavigationPush) {
            [toView.navigationController popViewControllerAnimated:YES];
        } else {
            [toView dismissViewControllerAnimated:YES completion:NULL];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.interactivePopTransition updateInteractiveTransition:progress];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        self.interacting = NO;
        if (progress > 0.5 ||  gesture.state == UIGestureRecognizerStateCancelled) {
            [self.interactivePopTransition finishInteractiveTransition];
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresentAnimationing = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresentAnimationing = NO;
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interacting ? self.interactivePopTransition : nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interacting ? self.interactivePopTransition : nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.isPresentAnimationing ? [self presentViewAnimation:transitionContext] : [self dismissViewAnimation:transitionContext];
}

#pragma mark - Private

- (void)presentViewAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 过渡view
    UIView *destinationView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // 容器view
    UIView* containerView = [transitionContext containerView];
    if (!destinationView) return;
    // 过渡view添加到容器view上
    [containerView addSubview:destinationView];
    
    // 目标控制器
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 判断是否为UINavigationController
    GXMediaBrowser *destinationController;
    if ([toViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationC = (UINavigationController*)toViewController;
        destinationController = [navigationC.viewControllers firstObject];
    } else {
        destinationController = (GXMediaBrowser*)toViewController;
    }
    destinationController.collectionView.hidden = YES;
    
    
    /*********************普通视图弹出*******************/
    if (!self.collectionView || !self.indexPath) {
        // 新建一个imageview添加到目标view之上,做为动画view
        UIImageView *annimateViwe = [[UIImageView alloc] initWithImage:self.selectedImage];
        annimateViwe.contentMode = UIViewContentModeScaleAspectFill;
        annimateViwe.clipsToBounds = YES;
        // 被选中的view的rect（默认show和hide都是同一个固定的rect）
        CGRect originFrame = [destinationController.delegate rectBackCellWithMediaBrowser:destinationController];
        annimateViwe.frame = originFrame;
        [containerView addSubview:annimateViwe];
        CGRect endFrame = coverImageFrameToFullScreenFrame(self.selectedImage);
        destinationView.alpha = 0.0;
        // 过渡动画执行
        [UIView animateWithDuration:GX_AnimationSpringDuration delay:0
             usingSpringWithDamping:GX_UsingSpringWithDamping
              initialSpringVelocity:GX_InitialSpringVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^
         {
             annimateViwe.frame = endFrame;
             destinationView.alpha = 1.0;
         } completion:^(BOOL finished) {
             destinationController.collectionView.hidden = NO;
             [UIView animateWithDuration:GX_AnimationDefaultDuration animations:^{
                 annimateViwe.alpha = 0.0;
             } completion:^(BOOL finished) {
                 [annimateViwe removeFromSuperview];
                 [transitionContext completeTransition:YES];
             }];
         }];
        return;
    }
    /************************************************/
    
    
    // 当前选中的cell
    UICollectionViewCell *selectctedCell = [self.collectionView cellForItemAtIndexPath:self.indexPath];
    // 新建一个imageview添加到目标view之上,做为动画view
    UIImageView *annimateViwe = [[UIImageView alloc] initWithImage:self.selectedImage];
    annimateViwe.contentMode = UIViewContentModeScaleAspectFill;
    annimateViwe.clipsToBounds = YES;
    // 被选中的cell到目标view上的座标转换
    CGRect originFrame = [self.collectionView convertRect:selectctedCell.frame toView:[UIApplication sharedApplication].keyWindow];
    annimateViwe.frame = originFrame;
    [containerView addSubview:annimateViwe];
    CGRect endFrame = coverImageFrameToFullScreenFrame(self.selectedImage);
    destinationView.alpha = 0.0;
    // 过渡动画执行
    [UIView animateWithDuration:GX_AnimationSpringDuration delay:0
         usingSpringWithDamping:GX_UsingSpringWithDamping
          initialSpringVelocity:GX_InitialSpringVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         annimateViwe.frame = endFrame;
         destinationView.alpha = 1.0;
     } completion:^(BOOL finished) {
         destinationController.collectionView.hidden = NO;
         [UIView animateWithDuration:GX_AnimationDefaultDuration animations:^{
             annimateViwe.alpha = 0.0;
         } completion:^(BOOL finished) {
             [annimateViwe removeFromSuperview];
             [transitionContext completeTransition:YES];
         }];
     }];
}

- (void)dismissViewAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 过渡view
    UIView *transitionView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView  = [transitionContext containerView];
    
    // 目标控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 判断是否为UINavigationController
    GXMediaBrowser *destinationController;
    if ([fromViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationC = (UINavigationController*)fromViewController;
        destinationController = [navigationC.viewControllers firstObject];
    } else {
        destinationController = (GXMediaBrowser*)fromViewController;
    };
    // 取出当前显示的collectionview
    UICollectionView *presentView = destinationController.collectionView;
    // 取出控制器当前显示的cell
    GXMediaBaseCell *dismissCell = [presentView.visibleCells firstObject];
    if (!dismissCell) {
        [transitionContext completeTransition:YES];
        return;
    }
    // 新建过渡动画imageview
    UIView *annimateViwe = dismissCell.mediaView;
    for (UIView *view in dismissCell.contentView.subviews) {
        if (view == annimateViwe) continue;
        view.hidden = YES;
    }
    annimateViwe.contentMode = UIViewContentModeScaleAspectFill;
    annimateViwe.clipsToBounds = YES;
    [containerView addSubview:annimateViwe];
    
    
    /*********************普通视图弹出*******************/
    if (!self.collectionView && !self.indexPath) {
        // 被选中的view的rect（默认show和hide都是同一个固定的rect）
        CGRect originFrame = [destinationController.delegate rectBackCellWithMediaBrowser:destinationController];
        // 过渡动画执行
        [UIView animateWithDuration:GX_AnimationSpringDuration delay:0
             usingSpringWithDamping:GX_UsingSpringWithDamping
              initialSpringVelocity:GX_InitialSpringVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^
         {
             annimateViwe.frame = originFrame;
             transitionView.alpha = 0.0;
         } completion:^(BOOL finished) {
             [annimateViwe removeFromSuperview];
             [transitionContext completeTransition:YES];
         }];
        return;
    }
    /************************************************/
    

    // 动画最后停止的frame
    NSIndexPath *indexPath = [destinationController currentMediaModel].indexPath;
    // 取出要返回的控制器view
    UICollectionView *originView = self.collectionView;
    UICollectionViewCell *originCell = [originView cellForItemAtIndexPath:indexPath];
    if (!originCell) {
        [originView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [originView layoutIfNeeded];
        originCell = [originView cellForItemAtIndexPath:indexPath];
    }
    originCell.hidden = YES;
    CGRect cellInFrame = [self.collectionView convertRect:originCell.frame toView:self.collectionView];
    CGRect originFrame = [self.collectionView convertRect:cellInFrame toView:[UIApplication sharedApplication].keyWindow];
    // 过渡动画执行
    [UIView animateWithDuration:GX_AnimationSpringDuration delay:0
         usingSpringWithDamping:GX_UsingSpringWithDamping
          initialSpringVelocity:GX_InitialSpringVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         annimateViwe.frame = originFrame;
         transitionView.alpha = 0.0;
     } completion:^(BOOL finished) {
         originCell.hidden = NO;
         [annimateViwe removeFromSuperview];
         [transitionContext completeTransition:YES];
     }];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.interacting ? self.interactivePopTransition : nil;
}

- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    //push的时候用我们自己定义的customPush
    if (operation == UINavigationControllerOperationPush) {
        self.isPresentAnimationing = YES;
        return self;
    } else if (operation == UINavigationControllerOperationPop) {
        self.isPresentAnimationing = NO;
        return self;
    }
    return nil;
}

@end
