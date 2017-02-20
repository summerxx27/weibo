//
//  NSString+XTAdd.h
//  XTWeibo
//
//  Created by zjwang on 16/9/14.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XTAdd)
- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;
- (CGFloat)heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;
- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;

@end
