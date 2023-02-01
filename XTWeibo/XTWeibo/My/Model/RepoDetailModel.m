//
//  RepoDetailModel.m
//  XTWeibo
//
//  Created by summerxx on 2023/1/11.
//  Copyright © 2023 夏天然后. All rights reserved.
//

#import "RepoDetailModel.h"

@implementation RepoDetailModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"introduce":@"description"
    };
}

@end


@implementation License

@end
