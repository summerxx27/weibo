//
//  FormatConfig.h
//  XTWeibo
//
//  Created by summerxx on 2023/1/13.
//  Copyright © 2023 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xlsxwriter/xlsxwriter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormatConfig : NSObject

// 字体大小
@property (nonatomic, assign) NSInteger fontSize;

// 边框
@property (nonatomic, assign) enum lxw_format_borders borders;

// 对齐
@property (nonatomic, assign) enum lxw_format_alignments alignments;

// 数字格式 如: 0, 0.00, 0.000
@property (nonatomic, copy) NSString *numFormat;

// 是否加粗
@property (nonatomic, assign) BOOL isBold;

// 文字颜色
@property (nonatomic, assign) enum lxw_defined_colors textColor;

@end

NS_ASSUME_NONNULL_END
