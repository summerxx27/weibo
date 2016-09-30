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
#import "SDPhotoItem.h"
#define cellID @"cellID"
@interface HomePageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) LoadType type;
@end

@implementation HomePageViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        // 默认下拉刷新
        self.type = NewDataStyle;
    }
    return self;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)userArray
{
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 10) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
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
    [self summerxx_RefreshHeader:self.tableView];
}
- (void)reqNetwork
{
#warning 真机可采用微博登陆的方式
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    NSString *url = [NSString stringWithFormat:WEIBO_STATUSES_FRIENDS, accessToken, (long)self.page];
    XTNSLog(@"%@", url);
    [XTNetwork XTNetworkRequestWithURL:url parameter:nil methods:GET successResult:^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *statisesArray = [result objectForKey:@"statuses"];
            switch (self.type) {
                case NewDataStyle:
                {
                    // 加载新数据清空数组
                    self.dataArray = nil;
                    self.userArray = nil;
                }
                    break;
                case LoadMoreStyle:
                {
                    
                }
                    break;
                default:
                    break;
            }
            for (NSDictionary *dic in statisesArray) {
                CommonModel *cModel = [CommonModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:cModel];
            }
        }
        if (self.dataArray.count > 0) {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failResult:^(id error) {
        [self showHint:@"请求失败"];
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
    CommonModel *model = self.dataArray[indexPath.row];
    [cell configCellWithModel:model user:model.user indexPath:indexPath];
    
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *urlString = [NSMutableArray array];
    for (NSDictionary *dic in model.pic_urls) {
        [urlString addObject:[dic objectForKey:@"thumbnail_pic"]];
    }
    [urlString enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
        SDPhotoItem *item = [[SDPhotoItem alloc] init];
        item.thumbnail_pic = src;
        [temp addObject:item];
    }];
    cell.photosGroup.photoItemArray = [temp copy];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 分享按钮
    cell.shareBlock = ^(){
        XTNSLog(@"summerxx");
        NSMutableArray *items = [NSMutableArray array];
        if (model.pic_urls.count == 0) {
            // 文字
            [items addObject:model.text];
        }else{
        // 默认情况下，UIActivityViewController 将显示所有可用于所提供内容的服务.
        for (NSInteger i = 0; i < model.pic_urls.count; i ++) {
            NSDictionary *dic = [model.pic_urls objectAtIndex:i];
            NSString *newURL = [dic objectForKey:@"thumbnail_pic"];
            NSString *large_pic = [newURL stringByReplacingCharactersInRange:NSMakeRange(22, 9) withString:@"large"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:large_pic]];
            UIImage *imagerang = [UIImage imageWithData:data];
            [items addObject:imagerang];
        }
        }
        UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
        activity.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            
            if (completed == YES) {
                UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [a show];
            }
        };
        [self presentViewController:activity animated:YES completion:NULL];
    };
//    __weak typeof(self) weakSelf = self;
//    __weak typeof(CommonTableViewCell *) weakCell = cell;
    return cell;
}
#pragma mark - 返回 Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonModel *model = self.dataArray[indexPath.row];
    CGFloat cellHeight = [CommonTableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        CommonTableViewCell *cell = (CommonTableViewCell *)sourceCell;
        [cell configCellWithModel:model user:model.user indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey: [NSString stringWithFormat:@"%@", model.id],
                 kHYBCacheStateKey : @"",
                 kHYBRecalculateForStateKey : @(NO) //
                 };
        return cache;
    }];
    return cellHeight;
}
#pragma mark - 刷新
- (void)summerxx_RefreshHeader:(UITableView *)tableView
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    tableView.mj_header = header;
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor colorWithRed:0.7683 green:0.7683 blue:0.7683 alpha:1.0];
    // 设置footer
    tableView.mj_footer = footer;
}
- (void)loadNewData
{
    _page = 1;
    self.type = NewDataStyle;
    [self reqNetwork];
}
- (void)loadMoreData
{
    _page ++;
    self.type = LoadMoreStyle;
    [self reqNetwork];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
