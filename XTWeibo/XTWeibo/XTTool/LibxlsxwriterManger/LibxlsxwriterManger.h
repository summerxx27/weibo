//
//  LibxlsxwriterManger.h
//  XTWeibo
//
//  Created by summerxx on 2023/1/13.
//  Copyright © 2023 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FormatConfig;

NS_ASSUME_NONNULL_BEGIN

@interface LibxlsxwriterManger : NSObject

/// 创建管理对象
+ (LibxlsxwriterManger *)shared;

/// 创建 xlsx
/// - Parameters:
///   - filename:  文件名字
///   - worksheetName:  sheet 名字
///   - textFormatConfig: 文本格式
///   - numFormatConfig: 数字格式
///   - data: 数据
- (void)createXlsxFilename:(NSString *)filename
             worksheetName:(NSString *)worksheetName
          textFormatConfig:(FormatConfig *)textFormatConfig
           numFormatConfig:(FormatConfig *)numFormatConfig
                      data:(NSArray *)data;

/// 测试展示
- (void)startTestDisplay;

/// 导出文件
- (void)exportFile;
@end

NS_ASSUME_NONNULL_END
