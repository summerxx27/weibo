//
//  AppDelegate.m
//  XTWeibo
//
//  Created by zjwang on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "NewsViewController.h"
#import "MyViewController.h"

@interface AppDelegate ()<WeiboSDKDelegate>
@property (nonatomic, strong) UITabBarController *tabVC;
@end

@implementation AppDelegate
// App Key 3686717696
// App Secret：17cf4efadde7fc29e43f972c947a1fc0
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEI_APP_KEY];
    
    _tabVC = [[UITabBarController alloc] init];
    
    // 首页
    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
    UINavigationController *homeNavVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeVC.title = @"首页";
    // 消息
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    UINavigationController *newsNavVC = [[UINavigationController alloc] initWithRootViewController:newsVC];
    newsVC.title = @"消息";
    // 我的
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *myNavVC = [[UINavigationController alloc] initWithRootViewController:myVC];
    myVC.title = @"我的";
    
    _tabVC.viewControllers = @[homeNavVC, newsNavVC, myNavVC];
    
    
    // accessToken 为空, 证明没有登陆过
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN] == nil) {
        // 根视图为登陆VC
//        self.window.rootViewController = [LoginViewController new];
        self.window.rootViewController = _tabVC;
    }else{
        self.window.rootViewController = _tabVC;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissLoginVC) name:DISS_MISS_VC object:nil];
    return YES;
}
// 登陆成功进行切换根视图
- (void)dissMissLoginVC
{
    self.window.rootViewController = _tabVC;
}
#pragma mark - 
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
#pragma mark - 
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        
        /**
         WeiboSDKResponseStatusCodeSuccess               = 0,//成功
         WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
         WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
         WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
         WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
         WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
         WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
         WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
         WeiboSDKResponseStatusCodeUnknown               = -100,
         */
        // statusCode
        NSInteger statusCode = response.statusCode;
        // userID
        NSString *userId = [(WBAuthorizeResponse *)response userID];
        // accessToken
        NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
        // userInfo
        NSDictionary *userInfo = response.userInfo;
        // requestUserInfo
        NSDictionary *requestUserInfo = response.requestUserInfo;
        // 状态码判断
        switch (statusCode) {
            case 0:
            {
                // 存储授权之后得到的基础信息
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO];
                [[NSUserDefaults standardUserDefaults] setObject:requestUserInfo forKey:REQUEST_USER_INFO];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 打印
                NSLog(@"accessToken =%@", accessToken);
                NSLog(@"userId = %@", userId);
                NSLog(@"Message = %@", message);
                // 发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:DISS_MISS_VC object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:REQ_NETWORK object:nil];
                NSLog(@"登陆成功");
            }
                break;
                
            default:
                break;
        }
        
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
