//
//  GXWaterViewController.m
//  GXUICollectionView
//
//  Created by GuoShengyong on 2017/12/11.
//  Copyright © 2017年 cong. All rights reserved.
//

#import "GXWaterViewController.h"
#import "UIView+GXAdd.h"
#import "GXWaterCVCell.h"
#import "GXHeaderCRView.h"
#import "GXFooterCRView.h"
#import "GXMediaBrowser.h"

static NSString* GXSectionHeaderID = @"GXSectionHeaderID";
static NSString* GXSectionFooterID = @"GXSectionFooterID";
static NSString* GXSectionCellID   = @"GXSectionCellID";

@interface GXWaterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, GXMediaBrowserDelegate>
@property (strong, nonatomic) UICollectionView *waterCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSMutableArray<NSMutableArray*> *imageArr;

@property (nonatomic, strong) GXMediaAnimationDelegate *mediaAnimationDelegate;
@end

@implementation GXWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"美女不是重点";
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 8.0;
    self.flowLayout.minimumInteritemSpacing = 8.0;
    CGFloat w = (SCREEN_WIDTH - 40) / 3.0;
    self.flowLayout.itemSize = CGSizeMake(w, w);
    self.flowLayout.headerReferenceSize = CGSizeMake(self.view.width, 40);
    self.flowLayout.footerReferenceSize = CGSizeMake(self.view.width, 40);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.flowLayout.scrollDirection = self.scrollDirection;//UICollectionViewScrollDirectionHorizontal;
    
    CGFloat top = 44.0 + SCREEN_STATUSBAR_HEIGHT;
    CGRect frame = CGRectMake(0, top, self.view.width, self.view.height - top);
    self.waterCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.flowLayout];
    self.waterCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.waterCollectionView.backgroundColor = [UIColor whiteColor];
    self.waterCollectionView.delegate = self;
    self.waterCollectionView.dataSource = self;
    [self.view addSubview:self.waterCollectionView];
    
    // iOS11设置UIScrollView
    if (@available(iOS 11.0, *)) {
        [self.waterCollectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.waterCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXWaterCVCell class]) bundle:nil] forCellWithReuseIdentifier:GXSectionCellID];
    [self.waterCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHeaderCRView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GXSectionHeaderID];
    [self.waterCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXFooterCRView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:GXSectionFooterID];
    
    UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGest:)];
    [self.waterCollectionView addGestureRecognizer:longGest];
    
    _mediaAnimationDelegate = [[GXMediaAnimationDelegate alloc] init];
}

- (void)longGest:(UILongPressGestureRecognizer *)gest {
    if (@available(iOS 9.0, *)) {
        switch (gest.state) {
            case UIGestureRecognizerStateBegan: {
                NSIndexPath *touchIndexPath = [self.waterCollectionView indexPathForItemAtPoint:[gest locationInView:self.waterCollectionView]];
                if (touchIndexPath) {
                    [self.waterCollectionView beginInteractiveMovementForItemAtIndexPath:touchIndexPath];
                }
            }
                break;
            case UIGestureRecognizerStateChanged: {
                [self.waterCollectionView updateInteractiveMovementTargetPosition:[gest locationInView:gest.view]];
            }
                break;
            case UIGestureRecognizerStateEnded: {
                [self.waterCollectionView endInteractiveMovement];
            }
                break;
            default:
                break;
        }
    }
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 1; i <= 100; i++) {
            [array addObject:[NSString stringWithFormat:@"%d.jpeg", i%13]];
        }
        NSMutableArray *array2 = [array mutableCopy];
        [_imageArr addObject:array];
        [_imageArr addObject:array2];
    }
    return _imageArr;
}

//设置head foot视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GXHeaderCRView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GXSectionHeaderID forIndexPath:indexPath];
        return head;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        GXFooterCRView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GXSectionFooterID forIndexPath:indexPath];
        return foot;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    cell.contentView.alpha = 0.2;
    cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.5, 0.5), 0);

    [UIView animateKeyframesWithDuration:.5 delay:0.0 options:0 animations:^{
        /** 分步动画   第一个参数是该动画开始的百分比时间  第二个参数是该动画持续的百分比时间 */
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
            cell.contentView.alpha = 0.5;
            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.1, 1.1), 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            cell.contentView.alpha = 1.0;
            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.0, 1.0), 0);
        }];
    } completion:^(BOOL finished) {}];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.imageArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXWaterCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GXSectionCellID forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
    cell.textTitle.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath NS_AVAILABLE_IOS(9_0) {
    if(sourceIndexPath.row != destinationIndexPath.row) {
        NSString *value = self.imageArr[sourceIndexPath.section][sourceIndexPath.row];
        [self.imageArr[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
        [self.imageArr[destinationIndexPath.section] insertObject:value atIndex:destinationIndexPath.row];
        NSLog(@"from:%@  to:%@", sourceIndexPath, destinationIndexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectImageName = [self.imageArr[indexPath.section] objectAtIndex:indexPath.row];
    UIImage *selectImage = [UIImage imageNamed:selectImageName];
    
    [self.mediaAnimationDelegate configureTransition:self collectionView:self.waterCollectionView
                            transitionIndexPath:indexPath transitionImage:selectImage];
    
    NSInteger index = 0;
    NSMutableArray<GXMediaBrowserModel*> *modelArray = [NSMutableArray array];
    NSInteger sectionCount = self.imageArr.count;
    for (NSInteger i = 0; i < sectionCount; i ++) {
        NSMutableArray *sectionArray = self.imageArr[i];
        NSInteger rowCount = sectionArray.count;
        for (NSInteger j = 0; j < rowCount; j ++) {
            if (i == indexPath.section && j == indexPath.row) {
                index = modelArray.count;
            }
            NSString *imageName = sectionArray[j];
            UIImage *image = [UIImage imageNamed:imageName];
            GXMediaBrowserModel *model = [GXMediaBrowserModel modelAnyImageObjWith:image];
            model.indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [modelArray addObject:model];
        }
    }
    GXMediaBrowser *browser = [[GXMediaBrowser alloc] initWithImagePhotos:modelArray];
//    browser.delegate = self;
    browser.currentPage = index;
    browser.backBarItem = @"返回";
    
    // push方式（如果是push，self.navigationController.delegate = nil;这句必须加到当前的popToViewController前面）
//    self.navigationController.delegate = self.mediaAnimationDelegate;
//    [self.navigationController pushViewController:browser animated:YES];
    
    // 不带UINavigationController的时候应该这样写
//    browser.transitioningDelegate = self.mediaAnimationDelegate;
//    browser.modalPresentationStyle = UIModalPresentationCustom;
//    [self presentViewController:browser animated:YES completion:nil];
    
    // 带UINavigationController的时候应该这样写
    UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:browser];
    navigationC.transitioningDelegate = self.mediaAnimationDelegate;
    navigationC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:navigationC animated:YES completion:nil];
}

#pragma mark - GXMediaBrowserDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
