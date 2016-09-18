//
//  CommonTableViewCell.m
//  XTWeibo
//
//  Created by summerxx on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "CommonTableViewCell.h"
#define SPACE 10
@implementation CommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.labelName];
        [self.contentView addSubview:self.labelTime];
        [self.contentView addSubview:self.labelText];
        // 图片浏览器
        [self.contentView addSubview:self.photosGroup];
        
        // Masonry布局
        // 头像
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            // 进行约束设置
            make.top.left.equalTo(self.contentView).with.offset(SPACE);
            make.width.height.mas_equalTo(33);
        }];
        _headerImageView.layer.cornerRadius = 33 / 2;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.layer.borderWidth = 1;
        _headerImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        // 昵称
        _labelName.preferredMaxLayoutWidth = SCREEN_W - 73;
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(SPACE);
            make.left.equalTo(self.headerImageView.mas_right).with.offset(SPACE);
            make.right.equalTo(self.contentView).with.offset(-SPACE);
            make.height.mas_equalTo(20);
        }];
        _labelName.backgroundColor = [UIColor yellowColor];
        _labelName.font = [UIFont fontWithName:@"Avenir-Heavy" size:17];
        // 时间
        [_labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelName.mas_bottom).with.offset(SPACE); // 空隙 为 10(SPACE)
            make.left.right.equalTo(self.labelName);
            make.height.mas_equalTo(10);
            
        }];
        _labelTime.font = [UIFont fontWithName:@"Avenir-Heavy" size:10];
        _labelTime.textColor = [UIColor lightGrayColor];
        _labelTime.backgroundColor = [UIColor greenColor];
        // 发布的内容
        // 文本显示多宽
        self.labelText.preferredMaxLayoutWidth = SCREEN_W - 30;
        [_labelText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTime.mas_bottom).with.offset(SPACE);
            make.left.right.mas_equalTo(self.labelTime);
        }];
        _labelText.backgroundColor = [UIColor lightGrayColor];
        _labelText.numberOfLines = 0;
        // 图片浏览器
        [_photosGroup mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self.labelText.mas_bottom).with.offset(SPACE);
            make.left.equalTo(self.labelText);
            make.width.mas_equalTo(SCREEN_W - 63);
        }];
    }
    return self;
}
#pragma mark - 初始化
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
    }
    return _headerImageView;
}
- (UILabel *)labelName
{
    if (!_labelName) {
        _labelName = [[UILabel alloc] init];
    }
    return _labelName;
}
- (UILabel *)labelTime
{
    if (!_labelTime) {
        _labelTime = [[UILabel alloc] init];
    }
    return _labelTime;
}
- (UILabel *)labelText
{
    if (!_labelText) {
        _labelText = [[UILabel alloc] init];
    }
    return _labelText;
}
- (SDPhotoGroup *)photosGroup
{
    if (!_photosGroup) {
        _photosGroup = [[SDPhotoGroup alloc] init];
    }
    return _photosGroup;
}
#pragma mark - 赋值
- (void)configCellWithModel:(CommonModel *)model user:(User *)userModel
{
    
    // 
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:userModel.profile_image_url] placeholderImage:nil];
    _labelName.text = userModel.name;
    _labelTime.text = model.created_at;
    _labelText.text = model.text;
    // 计算Photo的height
    CGFloat pg_Height = 0.0;
    if (model.pic_urls.count > 1 && model.pic_urls.count <= 3) {
        pg_Height = (SCREEN_W - 73) / 3 + 5;
    }else if(model.pic_urls.count > 3 && model.pic_urls.count <= 6)
    {
        pg_Height = (SCREEN_W - 73) / 3 * 2 + 10;
    }else if (model.pic_urls.count > 6 && model.pic_urls.count <= 9)
    {
        pg_Height = (SCREEN_W - 73) + 15;
    }else if (model.pic_urls.count == 1)
    {
        // 单张图片 为 4/7
        pg_Height = (SCREEN_W - 63) * 4 / 7 + 5;
    }
    else
    {
        pg_Height = 0.0;
    }
    // 更新约束
    [_photosGroup mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(pg_Height);
    }];
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
