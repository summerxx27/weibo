//
//  SDPhotoGroup.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "UIButton+WebCache.h"
#import "SDPhotoBrowser.h"

#define SDPhotoGroupImageMargin 5

@interface SDPhotoGroup () <SDPhotoBrowserDelegate>

@end

@implementation SDPhotoGroup 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
        [[SDWebImageManager sharedManager].imageCache clearDisk];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    __block int width = 0;
    __block int height = 0;
    [photoItemArray enumerateObjectsUsingBlock:^(SDPhotoItem *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.thumbnail_pic]];
//        UIImage *image = [UIImage imageWithData:data];
//        NSLog(@"w = %f,h = %f",image.size.width,image.size.height);
//         width = image.size.width;
//        height = image.size.height;
//        // 高 < 宽 宽图把左右两边裁掉
//        CGFloat scale = (height / width);
//        if (scale < 0.99 || isnan(scale)) {
//            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//            btn.imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
//        } else { // 高图只保留顶部
//            btn.imageView.contentMode = UIViewContentModeScaleToFill;
//            btn.imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
//        }
        
        NSString *large_pic = [obj.thumbnail_pic stringByReplacingCharactersInRange:NSMakeRange(22, 9) withString:@"large"];
        [btn sd_setImageWithURL:[NSURL URLWithString:large_pic] forState:UIControlStateNormal];
        btn.tag = idx;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
    long imageCount = photoItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    CGFloat h = (SCREEN_W - 73) / 3;
    if (imageCount == 1) {
        self.frame = CGRectMake(0, 0, width, height);
    }else{
        self.frame = CGRectMake(0, 0, SCREEN_W - 63, totalRowCount * (SDPhotoGroupImageMargin + h));}
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    long imageCount = self.photoItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat w = (SCREEN_W - 73) / 3;
    CGFloat h = (SCREEN_W - 73) / 3;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + SDPhotoGroupImageMargin);
        CGFloat y = rowIndex * (h + SDPhotoGroupImageMargin);
        btn.frame = CGRectMake(x, y, w, h);
    }];
}

- (void)click:(UIButton *)button
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = button.tag;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
