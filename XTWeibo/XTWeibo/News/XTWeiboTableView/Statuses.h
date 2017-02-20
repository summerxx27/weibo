//
//  Statuses.h
//  XTWeibo
//
//  Created by zjwang on 17/2/20.
//  Copyright © 2017年 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statuses : NSObject
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *pic_urls;
@property (nonatomic, assign) float textHeight;
@property (nonatomic, assign) float cellHeight;
@end
