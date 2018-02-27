//
//  UIViewController+GXAdd.m
//  PTChatDemo
//
//  Created by GuoShengyong on 2017/12/25.
//  Copyright © 2017年 protruly. All rights reserved.
//

#import "UIViewController+GXAdd.h"

@implementation UIViewController (GXAdd)

+ (instancetype)xibViewController {
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)addBackBarButtonItem:(NSString*)imageName {
    [self addBackBarButtonItemWithImage:imageName action:@selector(backBarButtonItemTapped:)];
}

- (void)addBackBarButtonItemWithImage:(NSString*)image action:(SEL)action {
    UIImage *normalImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain
                                                                         target:self action:action];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)backBarButtonItemTapped:(id)sender {
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 控制器切换返回

- (void)dismissRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissToViewControllerClass:(Class)vcClass animated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *vc = self;
    while (vc.presentingViewController && [vc.presentingViewController isKindOfClass:vcClass]) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:animated completion:completion];
}

- (void)popToViewControllerClass:(Class)vcClass animated:(BOOL)animated {
    UIViewController *target = nil;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:vcClass]) {
            target = controller;
            break;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:animated]; //跳转
    }
}

@end
