//
//  UIViewController+XTAdd.h
//  XTWeibo
//
//  Created by zjwang on 16/9/23.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XTAdd)
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (void)showDetailHint:(NSString *)hint yOffset:(float)yOffset;

- (void)summerxx_RereshHeader:(UITableView *)tableView;
@end
