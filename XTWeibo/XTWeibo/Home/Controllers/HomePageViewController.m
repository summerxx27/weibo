//
//  HomePageViewController.m
//  XTWeibo
//
//  Created by zjwang on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "HomePageViewController.h"
#import "XTNetwork.h"
#import "CommonTableViewCell.h"
#import "CommonModel.h"

#define cellID @"cellID"
@interface HomePageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HomePageViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 150;
        [_tableView registerClass:[CommonTableViewCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 注册 在登陆成功回调之后再进行网络请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reqNetwork) name:REQ_NETWORK object:nil];
    // tableView Add
    [self.view addSubview:self.tableView];
    // Net
    [self reqNetwork];
}
- (void)reqNetwork
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    NSString *url = [NSString stringWithFormat:WEIBO_STATUSES_FRIENDS, accessToken];
    [XTNetwork XTNetworkRequestWithURL:url parameter:nil methods:GET successResult:^(id result) {
        //
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *statisesArray = [result objectForKey:@"statuses"];
            // JSON array -> model array
            for (NSDictionary *dic in statisesArray) {
                CommonModel *cModel = [CommonModel mj_objectWithKeyValues:dic];
                
                [self.dataArray addObject:cModel];
            }
        }
        
        if (self.dataArray.count > 0) {
            [self.tableView reloadData];
        }
    } failResult:^(id error) {
        //
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.dataModel = self.dataArray[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
