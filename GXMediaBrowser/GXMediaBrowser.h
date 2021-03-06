//
//  GXMediaBrowser.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXMediaBrowserModel.h"
#import "GXMediaBrowserCommon.h"
#import "GXMediaAnimationDelegate.h"

@class GXMediaBrowser;
@protocol GXMediaBrowserDelegate <NSObject>
@optional
// 视频播放按钮接口
- (void)mediaBrowser:(GXMediaBrowser *)mediaBrowser atPlayModel:(GXMediaBrowserModel*)model;
@end

@interface GXMediaBrowser : UIViewController

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@property (nonatomic, strong, readonly) NSMutableArray<GXMediaBrowserModel*> *photoArray;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic,   copy) id backBarItem;

@property (nonatomic,   weak) id<GXMediaBrowserDelegate> delegate;

- (id)initWithImagePhotos:(NSArray<GXMediaBrowserModel*>*)photoArray;

- (GXMediaBrowserModel*)currentMediaModel;

- (void)deletePhotoAtCurrentIndex:(void (^)(GXMediaBrowserModel *model))deletingBlock success:(void (^)(BOOL finished))finishedBlock;

- (void)updateTitleText;// 子类可重写更新设置动态title

@end
