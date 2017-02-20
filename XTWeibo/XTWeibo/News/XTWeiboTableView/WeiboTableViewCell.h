//
//  WeiboTableViewCell.h
//  XTWeibo
//
//  Created by zjwang on 17/2/20.
//  Copyright © 2017年 夏天然后. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Statuses.h"

@interface WeiboTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) Statuses *statuses;
@end
