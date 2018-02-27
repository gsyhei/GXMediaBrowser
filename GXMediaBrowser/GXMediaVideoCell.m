//
//  GXMediaVideoCell.m
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "GXMediaVideoCell.h"
#import "UIView+GXAdd.h"
#import <AVFoundation/AVFoundation.h>

@interface GXMediaVideoCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation GXMediaVideoCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 0, self.width, self.width);
    _imageView.center = self.contentView.center;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.imageView];
    self.mediaView = self.imageView;
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"album_icon_middleplay.png"] forState:UIControlStateNormal];
    _playButton.frame = CGRectMake(0, 0, 60, 60);
    _playButton.center = self.contentView.center;
    _playButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
    [self.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_playButton];
    
    UITapGestureRecognizer * singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.contentView addGestureRecognizer:singleTapGesture];
}

- (void)playButtonClick:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaVideoCell:didPlayButton:)]) {
        [self.delegate mediaVideoCell:self didPlayButton:sender];
    }
}

#pragma mark - Super overwrite

- (void)bindMediaCellModel:(GXMediaBrowserModel*)model {
    [super bindMediaCellModel:model];
    if (model.filePath) {
        WEAK_SELF(weakSelf);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [self thumbnailImageForVideo:[NSURL fileURLWithPath:model.filePath] atTime:0];
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = image;
                weakSelf.imageView.frame = coverImageFrameToFullScreenFrame(image);
            });
        });
    } else if (model.photoImage) {
        self.imageView.image = model.photoImage;
        self.imageView.frame =  coverImageFrameToFullScreenFrame(model.photoImage);
        
    } else if (model.thumbImage) {
        self.imageView.image = model.thumbImage;
        self.imageView.frame = coverImageFrameToFullScreenFrame(model.thumbImage);
    }
}

- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapWithMediaBaseCell:)]) {
        [self.delegate didTapWithMediaBaseCell:self];
    }
}

@end
