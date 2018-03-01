//
//  GXMediaBrowserModel.h
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXMediaBrowserCommon.h"

@interface GXMediaBrowserModel : NSObject

// 资源类型
@property (nonatomic, assign) GXAssetType assetType;

// 存储路径(这里必须是全路径)
@property (nonatomic, strong) NSString    *filePath;

// 创建时间
@property (nonatomic, strong) NSDate      *createDate;

// 缩略图
@property (nonatomic,   copy) NSString    *thumbUrl;

// 缩略图
@property (nonatomic, strong) UIImage     *thumbImage;

// URL地址
@property (nonatomic,   copy) NSURL       *photoURL;

// 原图(建议不要直接使用，大图缓存到内存会影响性能)
@property (nonatomic, strong) UIImage     *photoImage;

// 唯一识别标记
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  传入一个图片对象，可以是URL/UIImage/NSString，返回一个实例
 */
+ (instancetype)modelAnyImageObjWith:(id)imageObj;

@end
