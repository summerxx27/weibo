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

typedef void(^shareBlock)();
typedef void(^loveBlock)(NSIndexPath *index);
@interface CommonTableViewCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (nonatomic, strong) SDPhotoGroup *photosGroup;
//@property (nonatomic, strong) CommonModel *dataModel;
//@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIImageView *headerImageView;             // 头像
@property (nonatomic, strong) UILabel *labelName;                       // 昵称
@property (nonatomic, strong) UILabel *labelTime;                       // 时间
@property (nonatomic, strong) TTTAttributedLabel *labelText;            // 文本
@property (nonatomic, strong) UIButton *btnShare;                       // 分享按钮
@property (nonatomic, strong) UIButton *btnComment;                     // 评论
@property (nonatomic, strong) UIButton *btnLove;                        // 点赞
@property (nonatomic, strong) TTTAttributedLabel *LabelLoveText;        // 点赞容器
@property (nonatomic, copy) shareBlock shareBlock;                      // 分享Block
@property (nonatomic, copy) loveBlock loveBlock;                        // 点赞Block
- (void)configCellWithModel:(CommonModel *)model user:(User *)userModel indexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) NSIndexPath *indexPath;                   // 记录cell的IndexPath
@property (nonatomic, assign) BOOL isExpand;
@end
