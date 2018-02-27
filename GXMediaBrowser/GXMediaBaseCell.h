//
//  GXMediaBaseCell.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXMediaBrowserCommon.h"
#import "GXMediaBrowserModel.h"

@class GXMediaBaseCell;
@protocol GXMediaCellDelegate <NSObject>
@optional
- (void)mediaVideoCell:(GXMediaBaseCell*)cell didPlayButton:(UIButton*)button;
- (void)didTapWithMediaBaseCell:(GXMediaBaseCell*)cell;
@end

@interface GXMediaBaseCell : UICollectionViewCell

@property (nonatomic,   weak) UIView *mediaView;

@property (nonatomic,   weak) GXMediaBrowserModel *mediaBrowserModel;

@property (nonatomic,   weak) id<GXMediaCellDelegate> delegate;
/**
 绑定model
 @param model 媒体数据模型
 */
- (void)bindMediaCellModel:(GXMediaBrowserModel*)model;


@end
