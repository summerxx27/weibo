//
//  CommonModel.h
//  XTWeibo
//
//  Created by summerxx on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonModel : NSObject
@property (nonatomic, copy) NSString *created_at;           // 微博创建时间
@property (nonatomic, copy) NSString *id;                   // 微博id
@property (nonatomic, copy) NSString *text;                 // 文本
@property (nonatomic, copy) NSArray *pic_urls;              // 图片url

@property (nonatomic, strong) NSMutableArray *loveArray;

@property (nonatomic, assign) BOOL shouldUpdateCache;

@end


