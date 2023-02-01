//
//  RepoDetailModel.h
//  XTWeibo
//
//  Created by summerxx on 2023/1/11.
//  Copyright © 2023 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface License : NSObject

// key
@property (nonatomic, copy) NSString *key;                 // "key": "apache-2.0"
// name
@property (nonatomic, copy) NSString *name;                // "name": "Apache License 2.0"

@end


@interface RepoDetailModel : NSObject

// 开源协议
@property (nonatomic, strong) License *license;
// 语言
@property (nonatomic, copy) NSString *language;
// 全名
@property (nonatomic, copy) NSString *full_name;
// 网址
@property (nonatomic, copy) NSString *html_url;
// 描述
@property (nonatomic, copy) NSString *introduce;
// 更新时间
@property (nonatomic, copy) NSString *updated_at;
// 创建时间
@property (nonatomic, copy) NSString *created_at;
// 推送时间
@property (nonatomic, copy) NSString *pushed_at;
// fork 数量
@property (nonatomic, assign) NSInteger forks_count;
// star 数量
@property (nonatomic, assign) NSInteger stargazers_count;
// 订阅数量
@property (nonatomic, assign) NSInteger subscribers_count;
// issue 数量
@property (nonatomic, assign) NSInteger open_issues_count;
// 是否 wiki
@property (nonatomic, assign) BOOL has_wiki;
// 是否 pages
@property (nonatomic, assign) BOOL has_pages;
// 是否 archived
@property (nonatomic, assign) BOOL archived;
// 是否 disabled
@property (nonatomic, assign) BOOL disabled;
// 是否 fork
@property (nonatomic, assign) BOOL fork;
// 开源指数总和
@property (nonatomic, assign) double openrankSum;
// 活动总和
@property (nonatomic, assign) double activitySum;

@end

NS_ASSUME_NONNULL_END
