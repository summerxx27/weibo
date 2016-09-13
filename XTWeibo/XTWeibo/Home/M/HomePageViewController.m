//
//  HomePageViewController.m
//  XTWeibo
//
//  Created by zjwang on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "HomePageViewController.h"
#import "XTNetwork.h"
@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 注册 在登陆成功回调之后再进行网络请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reqNetwork) name:REQ_NETWORK object:nil];
    //
    [self reqNetwork];
}
- (void)reqNetwork
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    NSString *url = [NSString stringWithFormat:WEIBO_STATUSES_FRIENDS, accessToken];
    NSLog(@"url  == %@", url);
    [XTNetwork XTNetworkRequestWithURL:url parameter:nil methods:GET successResult:^(id result) {
        //
        NSLog(@"result ======= %@", result);
    } failResult:^(id error) {
        //
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
