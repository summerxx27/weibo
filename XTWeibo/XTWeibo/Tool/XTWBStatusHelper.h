//
//  XTWBStatusHelper.h
//  XTWeibo
//
//  Created by zjwang on 16/9/21.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTWBStatusHelper : NSObject

/// 话题正则 例如 #暖暖环游世界#
+ (NSRegularExpression *)regexTopic;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 从path创建图片 (有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

/// /// 表情字典 key:[偷笑] value:ImagePath
+ (NSDictionary *)emoticonDic;

@end
