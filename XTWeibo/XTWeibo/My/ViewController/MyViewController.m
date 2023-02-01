//
//  MyViewController.m
//  XTWeibo
//
//  Created by zjwang on 16/9/14.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "MyViewController.h"
#import "XTNetwork.h"
#import <WebKit/WebKit.h>
#import <xlsxwriter/xlsxwriter.h>
#import "RepoDetailModel.h"
#import "LibxlsxwriterManger.h"
#import "FormatConfig.h"
#import "XTWeibo-Swift.h"
#import <SVProgressHUD.h>

@import TextFieldEffects;

@interface MyViewController ()

@property (nonatomic, strong) HoshiTextField *textField;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *excelBtn;
@property (nonatomic, strong) UIButton *exportBtn;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) NSMutableArray *excelArray;
@property (nonatomic, strong) UILabel *desLabel;
/// 开启单个库的查询
@property (nonatomic, strong) UIButton *singleButton;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self setupViews];
}

- (void)config
{
    self.excelArray = [NSMutableArray array];
}

- (void)setupViews
{
    [self.view addSubview:self.textField];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.excelBtn];
    [self.view addSubview:self.exportBtn];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.singleButton];
    [self layout];
}

- (void)layout
{
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.mas_equalTo(UIScreen.navibarHeight);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(200);
    }];

    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(10);
        make.height.mas_equalTo(80);
    }];

    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UIScreen.navibarHeight);
        make.right.equalTo(self.view);
        make.left.equalTo(self.textField.mas_right).offset(5);
        make.height.mas_equalTo(45);
    }];

    [self.excelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startBtn.mas_bottom).offset(5);
        make.right.equalTo(self.view);
        make.left.equalTo(self.textField.mas_right).offset(5);
        make.height.mas_equalTo(45);
    }];

    [self.exportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.excelBtn.mas_bottom).offset(5);
        make.right.equalTo(self.view);
        make.left.equalTo(self.textField.mas_right).offset(5);
        make.height.mas_equalTo(45);
    }];

    [self.singleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exportBtn.mas_bottom).offset(5);
        make.right.equalTo(self.view);
        make.left.equalTo(self.textField.mas_right).offset(5);
        make.height.mas_equalTo(45);
    }];
}

- (void)startClick
{
    NSString *repoStr = self.textField.text;
    if (repoStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入要查询的用户名!!!"];
        return;
    }
    NSArray *users = [repoStr componentsSeparatedByString:@" "];
//    NSArray *users = @[
//        @"mosn", // 23
//        @"Tongsuo-Project",
//        @"sofastack", // 39
//        @"ant-design", // 100+
//        @"occlum", //27
//        @"seata",  //17
//        @"macacajs", // 53
//        @"sql-machine-learning", // 12
//        @"dvajs", //17
//        @"ant-galaxy",  // 17
//        @"antchain-openapi-sdk-go", // 223
//        @"karasjs", // 23
//        @"dragonflyoss", //22
//        @"opensumi", // 21
//        @"secretflow", // 8
//        @"KusionStack", // 28
//        @"CeresDB", // 14
//        @"oceanbase", //39
//        @"kata-containers", // 24
//        @"mpaas-demo", // 40
//        @"alipay", // 46
//        @"eggjs", // 168
//        @"umijs", // 112
//        @"antvis", // 104
//        @"antchain-openapi-sdk-php" // 255
//        @"TuGraph-db", // 9
//        @"layotto", // 12
//        @"TRaaSStack", // 8
//        @"couler-proj"
//        @"ray-project"
//    ];

    // 用户下的所有库
    NSString *reposListUrl = @"https://api.github.com/users/%@/repos?per_page=100&page=1";
    // 库详情信息
    NSString *reposDetailUrl = @"https://api.github.com/repos/%@/%@";
    // openrank
    NSString *openrankUrl = @"https://oss.x-lab.info/open_digger/github/%@/openrank.json";
    // activity
    NSString *activityUrl = @"https://oss.x-lab.info/open_digger/github/%@/activity.json";

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        for (int i = 0; i < users.count; i ++) {
            NSString *url = [NSString stringWithFormat:reposListUrl, users[i]];
            // 请求每个用户的所有库
            [XTNetwork requestWithURL:url parameter:nil methods:GET successResult:^(id result) {

                NSArray *data = result;
                NSMutableArray *names = [NSMutableArray array];
                for (int i = 0; i < data.count; i ++) {
                    NSDictionary *dic = data[i];
                    NSString *name = dic[@"name"];
                    [names addObject:name];
                }

                dispatch_async(dispatch_get_global_queue(0, 0), ^{

                    dispatch_semaphore_t semaphore1 = dispatch_semaphore_create(0);

                    for (int j = 0; j < names.count; j ++) {

                        NSString *detailUrl = [NSString stringWithFormat:reposDetailUrl, users[i], names[j]];
                        // 请求每个库的详细信息
                        [XTNetwork requestWithURL:detailUrl parameter:nil methods:GET successResult:^(id result) {

                            NSDictionary *dic = result;
                            RepoDetailModel *model = [RepoDetailModel yy_modelWithDictionary:dic];
                            NSLog(@"进度 = %d, full_name = %@, introduce = %@", j, model.full_name, model.introduce);
                            self.tipsLabel.text = [NSString stringWithFormat:@"进度 = %d/%lu, %@", j + 1, (unsigned long)names.count, model.full_name];
                            NSString *url = [NSString stringWithFormat:openrankUrl, model.full_name];
                            NSLog(@"url = %@", url);
                            NSString *url2 = [NSString stringWithFormat:activityUrl, model.full_name];
                            // 请求每个库的每个月的 open 指数
                            [XTNetwork XTNetworkRequestWithURL:url parameter:nil methods:GET successResult:^(id result) {
                                ///
                                NSArray *values = [(NSDictionary *)result allValues];
                                CGFloat sum = 0.0;
                                for (NSNumber *value in values) {
                                    sum = sum + value.doubleValue;
                                }
                                model.openrankSum = sum;
                                // 请求每个库的每个月的 activity 指数
                                [XTNetwork XTNetworkRequestWithURL:url2 parameter:nil methods:GET successResult:^(id result) {

                                    NSArray *values = [(NSDictionary *)result allValues];
                                    CGFloat sumx = 0.0;
                                    for (NSNumber *value in values) {
                                        sumx = sumx + value.doubleValue;
                                    }
                                    model.activitySum = sumx;
                                    [self.excelArray addObject:model];
                                    dispatch_semaphore_signal(semaphore1);

                                } failResult:^(id error) {
                                    ///
                                    [self.excelArray addObject:model];
                                    dispatch_semaphore_signal(semaphore1);

                                }];

                            } failResult:^(id error) {
                                [self.excelArray addObject:model];
                                dispatch_semaphore_signal(semaphore1);
                            }];


                        }];
                        dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
                    }
                    dispatch_semaphore_signal(semaphore);
                });
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}

- (void)generateClick
{
    FormatConfig *format1 = [FormatConfig new];
    format1.fontSize = 10;
    format1.borders = LXW_BORDER_THIN;
    format1.alignments = LXW_ALIGN_RIGHT;

    FormatConfig *format2 = [FormatConfig new];
    format2.fontSize = 10;
    format2.borders = LXW_BORDER_THIN;
    format2.alignments = LXW_ALIGN_RIGHT;
    format2.numFormat = @"0";

    [[LibxlsxwriterManger shared] createXlsxFilename:@"summerxx.xlsx"
                                       worksheetName:@"sheet1夏天"
                                    textFormatConfig:format1 numFormatConfig:format2 data:self.excelArray];
    // 简单展示
    [[LibxlsxwriterManger shared] startTestDisplay];

}

- (void)exportClick
{
    [[LibxlsxwriterManger shared] exportFile];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

- (HoshiTextField *)textField
{
    if (!_textField) {
        _textField = [[HoshiTextField alloc] init];
        _textField.layer.borderColor = UIColor.cyanColor.CGColor;
        _textField.layer.borderWidth = 2;
        _textField.placeholder = @"多用户如:mosn sofastack 单库如: mosn/mosn";
        _textField.placeholderFontScale = 1;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholderColor = UIColor.redColor;
    }
    return _textField;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"进度";
        _tipsLabel.layer.borderColor = UIColor.cyanColor.CGColor;
        _tipsLabel.layer.borderWidth = 2;
        _tipsLabel.numberOfLines = 2;
        _tipsLabel.textColor = UIColor.redColor;
    }
    return _tipsLabel;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [[UIButton alloc] init];
        [_startBtn setTitle:@"开始查询" forState:UIControlStateNormal];
        _startBtn.backgroundColor = [UIColor orangeColor];
        _startBtn.layer.cornerRadius = 22.5;
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)excelBtn
{
    if (!_excelBtn) {
        _excelBtn = [[UIButton alloc] init];
        [_excelBtn setTitle:@"生成excel" forState:UIControlStateNormal];
        _excelBtn.backgroundColor = [UIColor orangeColor];
        _excelBtn.layer.cornerRadius = 22.5;
        [_excelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_excelBtn addTarget:self action:@selector(generateClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _excelBtn;
}

- (UIButton *)exportBtn
{
    if (!_exportBtn) {
        _exportBtn = [[UIButton alloc] init];
        [_exportBtn setTitle:@"导出excel" forState:UIControlStateNormal];
        _exportBtn.backgroundColor = [UIColor orangeColor];
        _exportBtn.layer.cornerRadius = 22.5;
        [_exportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exportBtn addTarget:self action:@selector(exportClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportBtn;
}

#pragma mark -

- (UIButton *)singleButton
{
    if (!_singleButton) {
        _singleButton = [[UIButton alloc] init];
        [_singleButton setTitle:@"单个库查询" forState:UIControlStateNormal];
        _singleButton.backgroundColor = [UIColor orangeColor];
        _singleButton.layer.cornerRadius = 22.5;
        [_singleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_singleButton addTarget:self action:@selector(singleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _singleButton;
}

- (void)singleAction
{
    if (self.excelArray.count != 0) {
        [self.excelArray removeAllObjects];
    }

    NSString *fullName = self.textField.text;
    if (fullName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入要查询的用户名/库名"];
        return;
    }

    // 库详情信息
    NSString *reposDetailUrl = [NSString stringWithFormat:@"https://api.github.com/repos/%@", fullName];
    // openrank
    NSString *openrankUrl = [NSString stringWithFormat:@"https://oss.x-lab.info/open_digger/github/%@/openrank.json", fullName];
    // activity
    NSString *activityUrl = [NSString stringWithFormat:@"https://oss.x-lab.info/open_digger/github/%@/activity.json", fullName];

    // 请求每个库的详细信息
    [XTNetwork requestWithURL:reposDetailUrl parameter:nil methods:GET successResult:^(id result) {

        NSDictionary *dic = result;
        RepoDetailModel *model = [RepoDetailModel yy_modelWithDictionary:dic];
        // 请求每个库的每个月的 open 指数
        [XTNetwork XTNetworkRequestWithURL:openrankUrl parameter:nil methods:GET successResult:^(id result) {
            ///
            NSArray *values = [(NSDictionary *)result allValues];
            CGFloat sum = 0.0;
            for (NSNumber *value in values) {
                sum = sum + value.doubleValue;
            }
            model.openrankSum = sum;
            // 请求每个库的每个月的 activity 指数
            [XTNetwork XTNetworkRequestWithURL:activityUrl parameter:nil methods:GET successResult:^(id result) {

                NSArray *values = [(NSDictionary *)result allValues];
                CGFloat sumx = 0.0;
                for (NSNumber *value in values) {
                    sumx = sumx + value.doubleValue;
                }
                model.activitySum = sumx;
                [self.excelArray addObject:model];

                self.tipsLabel.text = [NSString stringWithFormat:@"进度 = 完成"];

            } failResult:^(id error) {

                [self.excelArray addObject:model];
            }];

        } failResult:^(id error) {
            [self.excelArray addObject:model];

        }];


    }];
}
@end
