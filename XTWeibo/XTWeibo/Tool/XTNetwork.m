//
//  XTNetwork.m
//  XTWeibo
//
//  Created by zjwang on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "XTNetwork.h"

@implementation XTNetwork
+ (void)XTNetworkRequestWithURL:(NSString *)url parameter:(NSDictionary *)parameter methods:(MethodsType)methods successResult:(void (^)(id))successBlock failResult:(void (^)(id))failBlock
{
    NSString *encodingStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //stringByAddingPercentEscapesUsingEncoding
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == 0)
         {
             [self showHint:@"无网络连接"];
         }
         else
         {
             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
             // Request the corresponding format
             manager.requestSerializer = [AFJSONRequestSerializer serializer];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
             // Request type
             [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",@"application/x-javascript", nil]];
             MethodsType type = methods;
             switch (type) {
                     // POST
                 case POST: {
                     {
                         [manager POST:encodingStr parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
                             //
                         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             successBlock(responseObject);
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             failBlock(error);
                         }];
                     }
                     break;
                 }
                     // GET
                 case GET: {
                     {
                         [manager GET:encodingStr parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
                             //
                         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             successBlock(responseObject);
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             failBlock(error);
                         }];
                     }
                     break;
                 }
             }
         }
     }];
}
+ (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *xsHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    xsHud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    xsHud.mode = MBProgressHUDModeText;
    xsHud.labelText = hint;
    xsHud.margin = 10.f;
    xsHud.yOffset = 200.f;
    xsHud.removeFromSuperViewOnHide = YES;
    [xsHud hide:YES afterDelay:2];
}
@end
