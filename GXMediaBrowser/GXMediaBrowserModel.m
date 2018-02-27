//
//  GXMediaBrowserModel.m
//  PTChatDemo
//
//  Created by GuoShengyong on 2018/1/29.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "GXMediaBrowserModel.h"

@implementation GXMediaBrowserModel

#pragma mark - 传入一个图片对象，可以是URL/UIImage/NSString，返回一个实例
+ (instancetype)modelAnyImageObjWith:(id)imageObj {
    GXMediaBrowserModel *photo = [[self alloc] init];
    [photo setPhotoObject:imageObj];
    
    return photo;
}

- (void)setPhotoObject:(id)photoObject {
    if (!photoObject || [photoObject isKindOfClass:[NSNull class]]) {
    } else if ([photoObject isKindOfClass:[NSURL class]]) {
        self.photoURL = photoObject;
    } else if ([photoObject isKindOfClass:[UIImage class]]) {
        self.photoImage = photoObject;
    } else if ([photoObject isKindOfClass:[NSString class]]) {
        self.photoURL = [NSURL URLWithString:photoObject];
    } else {
        NSAssert(true, @"您传入图片数据的类型不对");
    }
}

- (UIImage *)thumbImage {
    if (!_thumbImage) {
        if (_photoImage){
            _thumbImage = _photoImage;
        }
    }
    return _thumbImage;
}

@end
