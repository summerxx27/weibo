//
//  CommonModel.h
//  XTWeibo
//
//  Created by summerxx on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, copy) NSString *name;                 // 用户名称

@property (nonatomic, copy) NSString *description;          // 用户描述
@property (nonatomic, copy) NSString *text;                 // 文本
@property (nonatomic, copy) NSString *profile_image_url;    // 头像url
//@property (nonatomic, copy) NSString *cover_image_url;      // 头像url
//@property (nonatomic, copy) NSString *followers_count;      // 粉丝
//@property (nonatomic, copy) NSString *friends_count;        // 关注

@end

@interface CommonModel : NSObject
@property (nonatomic, copy) NSString *created_at;           // 微博创建时间

@property (nonatomic, copy) NSString *id;                   // 微博id
@property (nonatomic, copy) NSString *text;                 // 文本
@property (nonatomic, copy) NSArray *pic_urls;              // 图片url

@property (nonatomic, strong) User *user;
@end


