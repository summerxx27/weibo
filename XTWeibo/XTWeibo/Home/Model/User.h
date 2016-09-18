//
//  User.h
//  XTWeibo
//
//  Created by zjwang on 16/9/14.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, copy) NSString *name;                 // 用户名称
@property (nonatomic, copy) NSString *description;          // 用户描述
@property (nonatomic, copy) NSString *profile_image_url;    // 头像url
@property (nonatomic, copy) NSString *city;                 // city
@end
