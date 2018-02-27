//
//  UIView+GXAdd.m
//  PTChatDemo
//
//  Created by GuoShengyong on 2017/12/25.
//  Copyright © 2017年 protruly. All rights reserved.
//

#import "UIView+GXAdd.h"

@implementation UIView (GXAdd)

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

+ (instancetype)sharedView:(id)owner {
    return [self sharedView:owner loadNibNamed:NSStringFromClass([self class]) index:0];
}

+ (instancetype)sharedView:(id)owner loadNibNamed:(NSString*)nibNamed index:(NSInteger)index{
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:nibNamed owner:owner options:nil] objectAtIndex:index];
    return view;
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)styleCircle {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = self.frame.size.height/2;
}

- (void)maskImage:(UIImage *)image {
    NSParameterAssert(image != nil);
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(self.frame, 0.f, 0.f);
    self.layer.mask = imageViewMask.layer;
}

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

+ (UIWindow*)currentWindow {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    if (!window) {
        window = [UIApplication sharedApplication].delegate.window;
    }
    return window;
}

- (UIViewController *)viewController {
    id nextResponder = [self nextResponder];
    if ( [nextResponder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)nextResponder;
    } else {
        return nil;
    }
}

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

- (NSData *)snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right {
    if(right == self.right){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (CGFloat)right {
    return self.left + self.width;
}

- (CGFloat)bottom {
    return self.top + self.height;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

@end

@implementation UITableViewCell (GXAdd)

- (void)setSeparatorLeadingLeft {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

@end

@implementation UITableViewHeaderFooterView (GXAdd)

+ (NSString *)viewReuseIdentifier {
    return NSStringFromClass([self class]);
}

@end

@implementation UICollectionViewCell (GXAdd)

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

@end

@implementation UICollectionReusableView (GXAdd)

+ (NSString *)viewReuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
