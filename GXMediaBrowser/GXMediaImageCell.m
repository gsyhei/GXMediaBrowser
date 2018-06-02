//
//  GXMediaImageCell.m
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "GXMediaImageCell.h"
#import "UIView+GXAdd.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <DACircularProgress/DACircularProgressView.h>

@interface GXMediaImageCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView           *scrollView;
@property (nonatomic, strong) UIImageView            *imageView;
@property (nonatomic, strong) DACircularProgressView *progressView;
@end

@implementation GXMediaImageCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.bounds;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
    _scrollView.zoomScale = 1.0f;
    _scrollView.bouncesZoom = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.scrollView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin
    |UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [self.scrollView addSubview:self.imageView];
    self.mediaView = self.imageView;
    
    UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    doubleTapGesture.numberOfTouchesRequired = 1;
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer * singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    singleTapGesture.numberOfTouchesRequired = 1;
    singleTapGesture.numberOfTapsRequired = 1;
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.contentView addGestureRecognizer:singleTapGesture];
}

- (void)updateFitImageView {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self fitImageViewFrameByImageSize:self.imageView.image.size centerPoint:center];
}

#pragma mark - Super overwrite

- (void)bindMediaCellModel:(GXMediaBrowserModel*)model {
    [super bindMediaCellModel:model];
    if (self.progressView) {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (model.filePath) {
        WEAK_SELF(weakSelf);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:model.filePath];
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = image;
                [weakSelf fitImageViewFrameByImageSize:weakSelf.imageView.image.size centerPoint:center];
            });
        });
    } else if (model.photoURL) {
        BOOL cached = [[SDWebImageManager sharedManager] cachedImageExistsForURL:model.photoURL];
        if (cached) {
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:model.photoURL];
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
            self.imageView.image = image;
            [self fitImageViewFrameByImageSize:self.imageView.image.size centerPoint:center];
        } else {
            WEAK_SELF(weakSelf);
            [self.imageView sd_setImageWithURL:model.photoURL placeholderImage:model.thumbImage
                                       options:SDWebImageRetryFailed|SDWebImageProgressiveDownload
                                      progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 CGFloat progress = receivedSize / (expectedSize * 1.0);
                 [weakSelf.progressView setProgress:progress];
             } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 weakSelf.progressView.alpha = 0.0;
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     if (weakSelf.progressView) {
                         [weakSelf.progressView removeFromSuperview];
                         weakSelf.progressView = nil;
                     }
                 });
             }];
        }
    } else if (model.photoImage) {
        self.imageView.image = model.photoImage;
        [self fitImageViewFrameByImageSize:self.imageView.image.size centerPoint:center];
        
    } else if (model.thumbImage) {
        self.imageView.image = model.thumbImage;
        [self fitImageViewFrameByImageSize:self.imageView.image.size centerPoint:center];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

#pragma mark - Private

- (DACircularProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 50.0, 50.0)];
        _progressView.roundedCorners = YES;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin
        |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        _progressView.userInteractionEnabled = NO;
        [self.contentView addSubview:_progressView];
        _progressView.center = self.contentView.center;
    }
    return _progressView;
}

- (void)fitImageViewFrameByImageSize:(CGSize)size centerPoint:(CGPoint)center {
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;
    if (imageWidth < self.contentView.width) {
        CGFloat scale = self.contentView.width / imageWidth;
        imageHeight = size.height * scale;
        imageWidth = self.contentView.width;
    }
    // zoom back first
    if (self.scrollView.zoomScale != 1.0f) {
        [self zoomBackWithCenterPoint:center animated:NO];
    }
    CGFloat scale_max  = 1.0f * GX_ZoomBigger;
    CGFloat scale_min = GX_ZoomSmaller;
    
    self.scrollView.maximumZoomScale = scale_max;
    self.scrollView.minimumZoomScale = scale_min;
    
    BOOL overWidth = imageWidth > self.scrollView.bounds.size.width;
    BOOL overHeight = imageHeight > self.scrollView.bounds.size.height;
    CGSize fitSize = CGSizeMake(imageWidth, imageHeight);
    
    if (overWidth && overHeight) {
        CGFloat timesThanScreenWidth = (imageWidth / self.scrollView.bounds.size.width);
        if (!((imageHeight / timesThanScreenWidth) > self.scrollView.bounds.size.height)) {
            scale_max =  timesThanScreenWidth * GX_ZoomBigger;
            fitSize.width = self.scrollView.bounds.size.width;
            fitSize.height = imageHeight / timesThanScreenWidth;
        } else {
            CGFloat timesThanScreenHeight = (imageHeight / self.scrollView.bounds.size.height);
            scale_max =  timesThanScreenHeight * GX_ZoomBigger;
            fitSize.width = imageWidth / timesThanScreenHeight;
            fitSize.height = self.scrollView.bounds.size.height;
        }
    } else if (overWidth && !overHeight) {
        CGFloat timesThanFrameWidth = (imageWidth / self.scrollView.bounds.size.width);
        scale_max =  timesThanFrameWidth * GX_ZoomBigger;
        fitSize.width = self.scrollView.bounds.size.width;
        fitSize.height = imageHeight / timesThanFrameWidth;
    } else if (overHeight && !overWidth) {
        CGFloat scale = (imageHeight / self.scrollView.bounds.size.height);
        scale_max =  scale * GX_ZoomBigger;
        fitSize.width = self.scrollView.bounds.size.width / scale;
        fitSize.height = self.scrollView.bounds.size.height;
    }
    self.imageView.frame = CGRectMake((center.x - fitSize.width/2), (center.y - fitSize.height/2), fitSize.width, fitSize.height);
    self.scrollView.contentSize = CGSizeMake(fitSize.width, fitSize.height);
    self.scrollView.maximumZoomScale = scale_max;
    self.scrollView.minimumZoomScale = scale_min;
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.numberOfTapsRequired == 2) {
        // 双击
        BOOL range_left = self.scrollView.zoomScale > (self.scrollView.maximumZoomScale * 0.9f);
        BOOL range_right = self.scrollView.zoomScale <= self.scrollView.maximumZoomScale;
        CGPoint pointCenter = [tapGesture locationInView:tapGesture.view];
        if (range_left && range_right) {
            CGRect rect = [self zoomRectForScale:self.scrollView.minimumZoomScale withCenter:pointCenter];
            [self.scrollView zoomToRect:rect animated:YES];
        } else {
            CGRect rect = [self zoomRectForScale:self.scrollView.maximumZoomScale withCenter:pointCenter];
            [self.scrollView zoomToRect:rect animated:YES];
        }
    } else if (tapGesture.numberOfTapsRequired == 1) {
        // 单击
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTapWithMediaBaseCell:)]) {
            [self.delegate didTapWithMediaBaseCell:self];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX =
    (self.bounds.size.width > self.scrollView.contentSize.width) ?
    (self.bounds.size.width - self.scrollView.contentSize.width) * 0.5f : 0.0f;
    
    CGFloat offsetY =
    (self.bounds.size.height > self.scrollView.contentSize.height)?
    (self.bounds.size.height - self.scrollView.contentSize.height) * 0.5f : 0.0f;
    
    self.imageView.center =
    CGPointMake(self.scrollView.contentSize.width * 0.5f + offsetX, self.scrollView.contentSize.height * 0.5f + offsetY);
}

#pragma mark - Zoom Action

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2);
    
    return zoomRect;
}

- (void)zoomBackWithCenterPoint:(CGPoint)center animated:(BOOL)animated {
    CGRect rect = [self zoomRectForScale:1.0f withCenter:center];
    [self.scrollView zoomToRect:rect animated:animated];
}

@end
