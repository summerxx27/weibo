//
//  LibxlsxwriterManger.m
//  XTWeibo
//
//  Created by summerxx on 2023/1/13.
//  Copyright © 2023 夏天然后. All rights reserved.
//

#import "LibxlsxwriterManger.h"
#import <xlsxwriter/xlsxwriter.h>
#import "FormatConfig.h"
#import "RepoDetailModel.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>

@interface LibxlsxwriterManger()<WKNavigationDelegate, WKUIDelegate, UIDocumentInteractionControllerDelegate>

// xlsx 文件名
@property (nonatomic, copy) NSString *filename;

// 已加载到的行数
@property (nonatomic, assign) int rowNum;

// 测试展示
@property (nonatomic, strong) WKWebView *testWebView;

// 导出
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

// excel文件
static lxw_workbook  *workbook;

// sheet
static lxw_worksheet *worksheet;

// xlsx 一般也就两种格式, 普通文本和数字文本: text. 0.00
// 文本内容的样式
static lxw_format *textFormat;

// 数字内容的样式
static lxw_format *numberFormat;

@implementation LibxlsxwriterManger

+ (LibxlsxwriterManger *)shared
{
    static LibxlsxwriterManger *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[LibxlsxwriterManger alloc] init];
    });
    return obj;
}

- (void)createXlsxFilename:(NSString *)filename
             worksheetName:(NSString *)worksheetName
          textFormatConfig:(FormatConfig *)textFormatConfig
           numFormatConfig:(FormatConfig *)numFormatConfig
                      data:(NSArray *)data

{
    self.rowNum = 0;
    self.filename = filename;
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *completePath = [documentPath stringByAppendingPathComponent:filename];

    NSLog(@"completePath == %@", completePath);

    // 创建新xlsx文件，路径需要转成c字符串
    workbook  = workbook_new([completePath UTF8String]);

    // 创建sheet（多sheet页就add多个）
    worksheet = workbook_add_worksheet(workbook, [worksheetName cStringUsingEncoding:NSUTF8StringEncoding]);
    // 设置格式
    textFormat = workbook_add_format(workbook);
    format_set_font_size(textFormat, textFormatConfig.fontSize);
    format_set_border(textFormat, textFormatConfig.borders);
    format_set_align(textFormat, textFormatConfig.alignments);
    // 数字格式
    numberFormat = workbook_add_format(workbook);
    format_set_font_size(numberFormat, numFormatConfig.fontSize);
    format_set_border(numberFormat, numFormatConfig.borders);
    format_set_num_format(numberFormat, [numFormatConfig.numFormat UTF8String]);
    format_set_align(numberFormat, numFormatConfig.alignments);

    [self setupXlsxData:data];

    workbook_close(workbook);
}

- (void)setupXlsxData:(NSArray *)data
{
    // 表格式
    // 设置列宽, 这里不做封装, 自由修改
    worksheet_set_column(worksheet, 1, 3, 30, NULL);  // B、C两列宽度（1:起始列 2:终始列 30:列宽） 1-2 列宽
    worksheet_set_column(worksheet, 4, 19, 25, NULL); // D列宽度（3:起始列 3:终始列 25:列宽） 3-13 列宽

    worksheet_write_string(worksheet, ++self.rowNum, 1, "full_name", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 2, "html_url", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 3, "description", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 4, "forks_count", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 5, "created_at", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 6, "updated_at", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 7, "pushed_at", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 8, "stargazers_count", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 9, "subscribers_count", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 10, "open_issues_count", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 11, "fork", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 12, "has_wiki", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 13, "has_pages", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 14, "archived", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 15, "disabled", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 16, "license", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 17, "language", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 18, "openrankSum", textFormat);
    worksheet_write_string(worksheet, self.rowNum, 19, "activitySum", textFormat);

    for (int i = 0; i < data.count; i ++) {

        RepoDetailModel *model = data[i];
        NSString *fork = model.fork ? @"true" : @"false";
        NSString *has_wiki = model.has_wiki ? @"true" : @"false";
        NSString *has_pages = model.has_pages ? @"true" : @"false";
        NSString *archived = model.archived ? @"true" : @"false";
        NSString *disabled = model.disabled ? @"true" : @"false";

        worksheet_write_string(worksheet, ++self.rowNum, 1, [model.full_name cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 2, [model.html_url cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 3, [model.introduce cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_number(worksheet, self.rowNum, 4, model.forks_count, numberFormat);
        worksheet_write_string(worksheet, self.rowNum, 5, [model.created_at cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 6, [model.updated_at cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 7, [model.pushed_at cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_number(worksheet, self.rowNum, 8, model.stargazers_count, numberFormat);
        worksheet_write_number(worksheet, self.rowNum, 9, model.subscribers_count, numberFormat);
        worksheet_write_number(worksheet, self.rowNum, 10, model.open_issues_count, numberFormat);
        worksheet_write_string(worksheet, self.rowNum, 11, [fork cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 12, [has_wiki cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 13, [has_pages cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 14, [archived cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 15, [disabled cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 16,  [model.license.name cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_string(worksheet, self.rowNum, 17,  [model.language cStringUsingEncoding:NSUTF8StringEncoding], textFormat);
        worksheet_write_number(worksheet, self.rowNum, 18,  model.openrankSum, numberFormat);
        worksheet_write_number(worksheet, self.rowNum, 19,  model.activitySum, numberFormat);

        NSLog(@"i === %d, rowNum === %d", i, self.rowNum);
    }
}

#pragma mark - 测试展示
- (void)startTestDisplay
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.testWebView];
    [self.testWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(400);
    }];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:self.filename];
    NSURL *url = [NSURL fileURLWithPath:filePath]; // 注意：使用[NSURL URLWithString:filePath]无效
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_testWebView loadRequest:urlRequest];
}

#pragma mark - WKNavigationDelegate, WKUIDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面开始加载时调用");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFailNavigation === %@", error);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"当内容开始返回时调用");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面加载完成之后调用");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面加载失败时调用");
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"接收到服务器跳转请求之后调用");
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [[self topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [[self topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [[self topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (WKWebView *)testWebView
{
    if (!_testWebView) {
        _testWebView = [[WKWebView alloc] init];
        _testWebView.navigationDelegate = self;
        _testWebView.UIDelegate = self;
        _testWebView.backgroundColor = [UIColor purpleColor];
    }
    return _testWebView;
}

#pragma mark - 导出
- (void)exportFile
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:self.filename];
    // 注意：使用[NSURL URLWithString:filePath]无效
    NSURL *url = [NSURL fileURLWithPath:filePath];
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    _documentController.delegate = self;
    [_documentController presentOptionsMenuFromRect:UIScreen.mainScreen.bounds inView:[self topViewController].view animated:YES];
}

- (UIViewController *)topViewController
{
    UIViewController *topVC = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    return topVC;
}
@end
