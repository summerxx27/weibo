//
//  XTWBPictureMetadata.m
//  XTWeibo
//
//  Created by zjwang on 16/9/29.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "XTWBPictureMetadata.h"

@implementation XTWBPictureMetadata
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cutType" : @"cut_type"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([_type isEqualToString:@"GIF"]) {
        _badgeType = WBPictureBadgeTypeGIF;
    } else {
        if (_width > 0 && (float)_height / _width > 3) {
            _badgeType = WBPictureBadgeTypeLong;
        }
    }
    return YES;
}
@end
