//
//  GXMediaBrowserLayout.m
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "GXMediaBrowserLayout.h"
#import "GXMediaBrowserCommon.h"

@implementation GXMediaBrowserLayout

- (id)initWithItemSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.itemSize = size;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumInteritemSpacing = 0.0f;
        self.minimumLineSpacing = GX_PageGap;
        self.sectionInset = UIEdgeInsetsZero;
        self.footerReferenceSize = CGSizeZero;
        self.headerReferenceSize = CGSizeZero;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)updateItemSize:(CGSize)size {
    self.itemSize = size;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = 0.0f;
    self.minimumLineSpacing = GX_PageGap;
    self.sectionInset = UIEdgeInsetsZero;
    self.footerReferenceSize = CGSizeZero;
    self.headerReferenceSize = CGSizeZero;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (CGSize)collectionViewContentSize {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat contentSize_width = (self.itemSize.width + GX_PageGap) * itemCount;
    CGSize  contentSize = CGSizeMake(contentSize_width, self.itemSize.height);
    
    return contentSize;
}

@end
