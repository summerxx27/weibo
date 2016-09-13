//
//  CommonTableViewCell.h
//  XTWeibo
//
//  Created by summerxx on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"
@interface CommonTableViewCell : UITableViewCell
@property (nonatomic, strong) CommonModel *dataModel;
@property (nonatomic, strong) UIImageView *headerImageView; // 头像
@end
