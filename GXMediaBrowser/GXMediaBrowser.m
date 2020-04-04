//
//  GXMediaBrowser.m
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "GXMediaBrowser.h"
#import "GXMediaImageCell.h"
#import "GXMediaVideoCell.h"
#import "GXMediaBrowserLayout.h"
#import "UIView+GXAdd.h"

@interface GXMediaBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,GXMediaCellDelegate>
@property (nonatomic, strong) NSMutableArray<GXMediaBrowserModel*> *photoArray;
@property (nonatomic, strong) GXMediaBrowserLayout *browserLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isRoating;
@end

@implementation GXMediaBrowser

- (void)dealloc {
    _photoArray = nil;
    _browserLayout = nil;
}

- (id)initWithImagePhotos:(NSArray<GXMediaBrowserModel*>*)photoArray {
    self = [super init];
    if (self) {
        _photoArray = [NSMutableArray arrayWithArray:photoArray];
        _currentPage = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateTitleText];
    [self updateToolBarItems];
    [self scrollToCurrentIndexAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
}

- (void)createSubviews {
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = GX_BACKGROUND_COLOR;
    if (self.backBarItem) {
        if ([self.backBarItem isKindOfClass:[NSString class]]) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.backBarItem style:UIBarButtonItemStylePlain target:self action:@selector(backBarItemTapped:)];
        } else if ([self.backBarItem isKindOfClass:[UIImage class]]) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:self.backBarItem style:UIBarButtonItemStylePlain target:self action:@selector(backBarItemTapped:)];
        } else if ([self.backBarItem isKindOfClass:[UIBarButtonItem class]]) {
            self.navigationItem.leftBarButtonItem = self.backBarItem;
        }
    }

    CGRect rect = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH + GX_PageGap, SCREEN_HEIGHT);
    GXMediaBrowserLayout *layout = [[GXMediaBrowserLayout alloc] initWithItemSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    _browserLayout = layout;
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:self.collectionView atIndex:0];
    [self.collectionView registerClass:[GXMediaImageCell class] forCellWithReuseIdentifier:[GXMediaImageCell cellReuseIdentifier]];
    [self.collectionView registerClass:[GXMediaVideoCell class] forCellWithReuseIdentifier:[GXMediaVideoCell cellReuseIdentifier]];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.view addGestureRecognizer:pan];
}

- (void)backBarItemTapped:(id)sender {
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - UIContentContainer

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.isRoating = YES;

    CGRect rect = CGRectMake(0.0, 0.0, size.width + GX_PageGap, size.height);
    self.collectionView.frame = rect;
    [self.collectionView.collectionViewLayout invalidateLayout];
    self.browserLayout = nil;
    self.browserLayout = [[GXMediaBrowserLayout alloc] initWithItemSize:size];
    [self.collectionView setCollectionViewLayout:self.browserLayout animated:NO];
    [self reloadCurrentData];
    [self scrollToCurrentIndexAnimated:NO];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.isRoating = NO;
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - UIPanGestureRecognizer

- (void)panGestureRecognizer:(UIPanGestureRecognizer*)pan {
    if (self.presentingViewController) {
        [self performScaleWithPan:pan];
    }
}

- (void)performScaleWithPan:(UIPanGestureRecognizer *)pan {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentPage inSection:0];
    GXMediaBaseCell *cell = (GXMediaBaseCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell || !cell.mediaView) return;
    
    UICollectionViewCell *originalCell = [self originalFormCell];
    CGPoint point = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            if (originalCell) {
                originalCell.hidden = YES;
            }
            if ([cell isKindOfClass:[GXMediaImageCell class]]) {
                GXMediaImageCell *imageCell = (GXMediaImageCell*)cell;
                [imageCell updateFitImageView];
            }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = 1.0 - fabs(point.y) / (self.view.height/2);
            CGFloat scale = MAX(percent, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x/scale, point.y/scale);
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
            cell.mediaView.transform = CGAffineTransformConcat(translation, scaleTransform);
            self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > (cell.mediaView.height/2) || fabs(velocity.y) > 500) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [UIView animateWithDuration:GX_AnimationSpringDuration delay:0
                     usingSpringWithDamping:GX_UsingSpringWithDamping
                      initialSpringVelocity:GX_InitialSpringVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^
                 {
                     cell.mediaView.transform = CGAffineTransformIdentity;
                     self.view.backgroundColor = GX_BACKGROUND_COLOR;
                 } completion:^(BOOL finished) {
                     if (originalCell) {
                         originalCell.hidden = NO;
                     }
                 }];
            }
        }
            break;
        default:
            break;
    }
}

- (UICollectionViewCell*)originalFormCell {
    GXMediaAnimationDelegate *animationDelegate = (GXMediaAnimationDelegate*)self.transitioningDelegate;
    if (!animationDelegate) {
        animationDelegate = (GXMediaAnimationDelegate*)self.navigationController.transitioningDelegate;
    }
    NSIndexPath *indexPath = [self currentMediaModel].indexPath;
    UICollectionViewCell *originCell = [animationDelegate.collectionView cellForItemAtIndexPath:indexPath];
    
    return originCell;
}

#pragma mark - Setter

- (void)setCurrentPage:(NSInteger)currentPage {
    NSUInteger photoCount = self.photoArray.count;
    if (photoCount == 0 || currentPage < 0) {
        currentPage = 0;
    }  else if (currentPage >= photoCount) {
        currentPage = self.photoArray.count - 1;
    }
    _currentPage = currentPage;
}

#pragma mark - Public

- (GXMediaBrowserModel *)currentMediaModel {
    return self.photoArray[self.currentPage];
}

- (void)deletePhotoAtCurrentIndex:(void (^)(GXMediaBrowserModel *))deletingBlock success:(void (^)(BOOL))finishedBlock {
    [self.collectionView performBatchUpdates:^{
        GXMediaBrowserModel *photoModel = [self currentMediaModel];
        if (deletingBlock) {
            deletingBlock(photoModel);
        }
        // deleting Data
        [self.photoArray removeObjectAtIndex:self.currentPage];
        // deleting Cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        if (self.photoArray.count == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if ((self.photoArray.count - 1) < self.currentPage) {
            self.currentPage = self.photoArray.count - 1;
            [self updateTitleText];
        } else {
            [self updateTitleText];
        }
        if (finishedBlock) {
            finishedBlock(finished);
        }
    }];
}

- (void)reloadCurrentData {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentPage inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark Private

- (void)updateToolBarItems {
    //    GXMediaBrowserModel *mediaModel = self.photoArray[self.currentPage];
}

- (void)updateTitleText {
    GXMediaBrowserModel *photoModel = [self currentMediaModel];
    NSString *dateStr = [photoModel.filePath lastPathComponent];
    if (dateStr) {
        self.title = dateStr;
    } else {
        self.title = [NSString stringWithFormat:@"%ld / %ld", (long)(self.currentPage+1), (long)self.photoArray.count];
    }
}

- (void)scrollToCurrentIndexByCurrentSize:(CGSize)size animated:(BOOL)animated {
    CGFloat contentOffset_x = self.currentPage * (size.width + GX_PageGap);
    CGPoint point = CGPointMake(contentOffset_x, 0);
    [self.collectionView setContentOffset:point animated:animated];
}

- (void)scrollToCurrentIndexAnimated:(BOOL)animated {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXMediaBaseCell *cell;
    GXMediaBrowserModel *mediaModel = self.photoArray[indexPath.row];
    if (mediaModel.assetType == GXAssetTypeVideo) {
        cell = (GXMediaVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[GXMediaVideoCell cellReuseIdentifier] forIndexPath:indexPath];
    } else {
        cell = (GXMediaImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[GXMediaImageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(GXMediaBaseCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    GXMediaBrowserModel *model = self.photoArray[indexPath.row];
    [cell bindMediaCellModel:model];
    [cell setDelegate:self];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select item at index=%ld", (long)indexPath.row);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isRoating) return;
    
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (index < 0) index = 0;
    if (index >= self.photoArray.count) index = self.photoArray.count - 1;
    _currentPage = index;
    [self updateTitleText];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateToolBarItems];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateToolBarItems];
}

#pragma mark - GXMediaCellDelegate

- (void)didTapWithMediaBaseCell:(GXMediaBaseCell *)cell {
    if (self.navigationController) {
        BOOL navigationHidden = !self.navigationController.navigationBarHidden;
        [self.navigationController setNavigationBarHidden:navigationHidden animated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)mediaVideoCell:(GXMediaBaseCell *)cell didPlayButton:(UIButton *)button {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    GXMediaBrowserModel *model = self.photoArray[indexPath.row];
    if (model.assetType != GXAssetTypeVideo) {
        NSLog(@"播放媒体不正确");
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaBrowser:atPlayModel:)]) {
        [self.delegate mediaBrowser:self atPlayModel:model];
    }
}

@end
