//
//  NSString+XTAdd.m
//  XTWeibo
//
//  Created by zjwang on 16/9/14.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "NSString+XTAdd.h"

@implementation NSString (XTAdd)
- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    NSParameterAssert(attribute);
    CGFloat width = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        width = rect.size.width;
    }
    return width;
}
- (CGFloat)heightWithStringAttribute:(NSDictionary<NSString *,id> *)attribute
{
    NSParameterAssert(attribute);
    CGFloat height = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        height = rect.size.height;
    }
    return height;
}
@end