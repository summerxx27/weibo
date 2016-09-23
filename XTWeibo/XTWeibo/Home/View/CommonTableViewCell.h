//
//  CommonTableViewCell.h
//  XTWeibo
//
//  Created by summerxx on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"
#import "User.h"
// 图片浏览
#import "SDPhotoGroup.h"
@interface CommonTableViewCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (nonatomic, strong) SDPhotoGroup *photosGroup;
//@property (nonatomic, strong) CommonModel *dataModel;
//@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIImageView *headerImageView;             // 头像
@property (nonatomic, strong) UILabel *labelName;                       // 昵称
@property (nonatomic, strong) UILabel *labelTime;                       // 时间
@property (nonatomic, strong) TTTAttributedLabel *labelText;            // 文本
@property (nonatomic, strong) UIButton *btnShare;                       // 分享按钮

- (void)configCellWithModel:(CommonModel *)model user:(User *)userModel;

@end
