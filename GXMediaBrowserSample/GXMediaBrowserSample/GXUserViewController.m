//
//  GXUserViewController.m
//  GXMediaBrowserSample
//
//  Created by Gin on 2018/6/1.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "GXUserViewController.h"
#import "UIView+GXAdd.h"
#import "GXMediaBrowser.h"

@interface GXUserViewController ()<GXMediaAnimationTransitionDataSource>
@property (nonatomic, weak) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) GXMediaAnimationDelegate *mediaAnimationDelegate;
@end

@implementation GXUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"码农是不看美女的";
    [self.avatarButton styleCircle];
    _mediaAnimationDelegate = [[GXMediaAnimationDelegate alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)avatarButtonClick:(id)sender {
    
    UIImage *selectImage = self.avatarButton.currentImage;
    [self.mediaAnimationDelegate configureTransition:self collectionView:nil
                                 transitionIndexPath:nil transitionImage:selectImage];
    self.mediaAnimationDelegate.isNavigationPush = NO;
    self.mediaAnimationDelegate.dataSource = self;
    
    GXMediaBrowserModel *model = [GXMediaBrowserModel modelAnyImageObjWith:selectImage];
    NSMutableArray<GXMediaBrowserModel*> *modelArray = [NSMutableArray arrayWithObject:model];
    GXMediaBrowser *browser = [[GXMediaBrowser alloc] initWithImagePhotos:modelArray];
    // 不带UINavigationController的时候应该这样写
    browser.transitioningDelegate = self.mediaAnimationDelegate;
    browser.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:browser animated:YES completion:nil];
    
    // 带UINavigationController的时候应该这样写
//    UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:browser];
//    navigationC.transitioningDelegate = self.mediaAnimationDelegate;
//    navigationC.modalPresentationStyle = UIModalPresentationCustom;
//    [self presentViewController:navigationC animated:YES completion:nil];
    
}

#pragma mark - GXMediaAnimationTransitionDataSource

- (CGRect)popFromRect {
    return self.avatarButton.frame;
}

@end
