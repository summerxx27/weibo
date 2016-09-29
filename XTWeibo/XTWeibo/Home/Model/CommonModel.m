//
//  CommonModel.m
//  XTWeibo
//
//  Created by summerxx on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "CommonModel.h"

@implementation CommonModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pic_urls = [NSArray array];
        _loveArray = [NSMutableArray array];
    }
    return self;
}
@end
