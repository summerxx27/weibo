//
//  XTWBStatusHelper.m
//  XTWeibo
//
//  Created by zjwang on 16/9/21.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "XTWBStatusHelper.h"

@implementation XTWBStatusHelper

+ (NSRegularExpression *)regexTopic {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}


+ (UIImage *)ImageCropping:(NSData *)data
{
    // 获取源图
    UIImage *sImage = [UIImage imageWithData:data];
    // 获取源图上下文
    CGFloat width = sImage.size.width;
    CGFloat height = sImage.size.height;
    // 画大图
    [[UIColor whiteColor] set];
    CGContextRef ctX = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctX, width * 0.5, height * 0.5, width * 0.5, 0, M_PI * 2, 0);
    CGContextFillPath(ctX);
    // 画小图
    CGFloat smallImage = sImage.size.width * 0.5;
    CGContextAddArc(ctX, width * 0.5, height * 0.5, smallImage, 0, M_PI * 2, 0);
    CGContextFillPath(ctX);
    // 画图
    [sImage drawInRect:CGRectMake(2, 2, sImage.size.width, sImage.size.height)];
    // 获取新图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

@end
