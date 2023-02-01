//
//  NewsViewController.m
//  XTWeibo
//
//  Created by zjwang on 16/9/14.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "NewsViewController.h"
#import "XTNetwork.h"
#import "Statuses.h"
#import "NSString+XTAdd.h"
#import "WeiboTableViewCell.h"
@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation NewsViewController {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // https://api.weibo.com/2/statuses/friends_timeline.json?access_token=2.00yOHsNEegFVBEa4756136060YytgK&since_id=0&max_id=0&count=20&base_app=0&feature=0&trim_user=0&page=1
    _datas = [NSMutableArray array];
    [self loadWeiboData];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[WeiboTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Statuses *statuses = _datas[indexPath.row];
    return statuses.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.statuses = _datas[indexPath.row];
    return cell;
}
- (void)loadWeiboData {
    [XTNetwork XTNetworkRequestWithURL:@"https://api.weibo.com/2/statuses/friends_timeline.json?access_token=2.00yOHsNEegFVBEa4756136060YytgK&since_id=0&max_id=0&count=20&base_app=0&feature=0&trim_user=0&page=1" parameter:nil methods:GET successResult:^(id result) {
        
        NSDictionary *jsonDictionary = (NSDictionary *)result;
        NSArray *statusesArray = jsonDictionary[@"statuses"];
        for (NSDictionary *dic in statusesArray) {
            Statuses *statuses = [Statuses yy_modelWithDictionary:dic];
            float height = [statuses.text sizeWithConstrainedToWidth:[UIScreen mainScreen].bounds.size.width fromFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17] lineSpace:5].height;
            statuses.textHeight = height;
            statuses.cellHeight = height + 80 + 10; // 上下 + 10
            [_datas addObject:statuses];
            
            if (_datas.count > 0) {
                [_tableView reloadData];
            }
        }
    } failResult:^(id error) { }];
}
@end
