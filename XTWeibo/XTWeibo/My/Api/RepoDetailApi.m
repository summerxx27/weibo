//
//  RepoDetailApi.m
//  XTWeibo
//
//  Created by summerxx on 2023/1/12.
//  Copyright © 2023 夏天然后. All rights reserved.
//

#import "RepoDetailApi.h"
#import "XTNetwork.h"
#import "RepoDetailModel.h"

@implementation RepoDetailApi

+ (void)fetchRepoDetailWithUserName:(NSString *)userName
{
//    NSString *reposListUrl = @"https://api.github.com/users/%@/repos?per_page=100&page=1";
//    // 库详情信息
//    NSString *reposDetailUrl = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@", userName];
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//        NSString *url = [NSString stringWithFormat:reposListUrl, userName];
//        // 请求每个用户的所有库
//        [XTNetwork requestWithURL:url parameter:nil methods:GET successResult:^(id result) {
//            NSArray *data = result;
//            NSMutableArray *names = [NSMutableArray array];
//            for (int i = 0; i < data.count; i ++) {
//                NSDictionary *dic = data[i];
//                NSString *name = dic[@"name"];
//                [names addObject:name];
//            }
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//                dispatch_semaphore_t semaphore1 = dispatch_semaphore_create(0);
//
//                for (int j = 0; j < names.count; j ++) {
//
//                    NSString *detailUrl = [NSString stringWithFormat:reposDetailUrl, names[j]];
//
//                    [XTNetwork requestWithURL:detailUrl parameter:nil methods:GET successResult:^(id result) {
//
//                        NSDictionary *dic = result;
//                        RepoDetailModel *model = [RepoDetailModel yy_modelWithDictionary:dic];
//                        NSLog(@"count = %d, full_name = %@, introduce = %@", j, model.full_name, model.introduce);
//
//                        dispatch_semaphore_signal(semaphore1);
//
//                    }];
//                    dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
//
//                }
//                dispatch_semaphore_signal(semaphore);
//            });
//        }];
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    });
}
@end
