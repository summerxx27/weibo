//
//  CommonTableViewCell.m
//  XTWeibo
//
//  Created by summerxx on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "XTWBStatusHelper.h"
#define SPACE 10

@implementation CommonTableViewCell
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
        _labelText = [TTTAttributedLabel new];
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
- (UIButton *)btnShare
{
    if (!_btnShare) {
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btnShare;
}
- (UIButton *)btnLove
{
    if (!_btnLove) {
        _btnLove = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btnLove;
}
- (TTTAttributedLabel *)LabelLoveText
{
    if (!_LabelLoveText) {
        _LabelLoveText = [TTTAttributedLabel new];
    }
    return _LabelLoveText;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.labelName];
        [self.contentView addSubview:self.labelTime];
        [self.contentView addSubview:self.labelText];
        [self.contentView addSubview:self.photosGroup];
        [self.contentView addSubview:self.btnShare];
        [self.contentView addSubview:self.btnLove];
        [self.contentView addSubview:self.LabelLoveText];
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
        // 文本内容要显示多长
        _labelName.preferredMaxLayoutWidth = SCREEN_W - 63;
        _labelName.numberOfLines = 0;
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(SPACE);
            make.left.equalTo(self.headerImageView.mas_right).with.offset(SPACE);
            make.right.equalTo(self.contentView).with.offset(-SPACE);
        }];
        _labelName.font = [UIFont fontWithName:@"Avenir-Heavy" size:17];
        // 时间
        _labelTime.preferredMaxLayoutWidth = SCREEN_W - 63;
        _labelTime.numberOfLines = 0;
        [_labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelName.mas_bottom).with.offset(SPACE); // 空隙 为 10(SPACE)
            make.left.right.equalTo(self.labelName);
        }];
        _labelTime.font = [UIFont fontWithName:@"Avenir-Heavy" size:10];
        _labelTime.textColor = [UIColor lightGrayColor];
        // 发布的内容
        // 视图是多宽的 进行相应的设置
        self.labelText.preferredMaxLayoutWidth = SCREEN_W - 63;
        _labelText.delegate = self;
        _labelText.numberOfLines = 0;
        _labelText.textColor = [UIColor grayColor];
        [_labelText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTime.mas_bottom).with.offset(SPACE);
            make.left.right.mas_equalTo(self.labelTime);
        }];
        // 自动检测链接
        _labelText.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        // 图片浏览器
        [_photosGroup mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self.labelText.mas_bottom).with.offset(SPACE);
            make.left.equalTo(self.labelText);
            make.width.mas_equalTo(SCREEN_W - 63);
        }];
        // 分享按钮
        [_btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self.photosGroup.mas_bottom).with.offset(SPACE);
            make.left.mas_equalTo(self.labelText);
            make.width.mas_equalTo((SCREEN_W - 73) / 2);
            make.height.mas_equalTo(@22);
        }];
        _btnShare.backgroundColor = [UIColor lightGrayColor];
        [_btnShare setTitle:@"一键分享" forState:UIControlStateNormal];
        [_btnShare addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        [_btnLove mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photosGroup.mas_bottom).with.offset(SPACE);
            make.left.equalTo(self.btnShare.mas_right).with.offset(SPACE);
            make.width.height.mas_equalTo(self.btnShare);
        }];
        _btnLove.backgroundColor = [UIColor lightGrayColor];
        [_btnLove setTitle:@"点赞" forState:UIControlStateNormal];
        [_btnLove addTarget:self action:@selector(loveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
#pragma mark - 赋值
- (void)configCellWithModel:(CommonModel *)model user:(User *)userModel indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    // 头像
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:userModel.profile_image_url] placeholderImage:nil];
    _labelName.text = userModel.name;
    _labelTime.text = model.created_at;
    // 发布的内容
    _labelText.text = model.text;
    // 话题检测
    NSArray *results = [[XTWBStatusHelper regexTopic] matchesInString:model.text options:0 range:NSMakeRange(0, model.text.length)];
    for (NSTextCheckingResult *result in results) {
        // 话题范围
        [_labelText addLinkWithTextCheckingResult:result];
    }
    // 表情检测
    NSArray *results1 = [[XTWBStatusHelper regexEmoticon] matchesInString:model.text options:0 range:NSMakeRange(0, model.text.length)];
    for (NSTextCheckingResult *result in results1) {
        [_labelText addLinkWithTextCheckingResult:result];
    }
    // 计算Photo的height
    CGFloat pg_Height = 0.0;
    if (model.pic_urls.count > 1 && model.pic_urls.count <= 3) {
        pg_Height = (SCREEN_W - 73) / 3;
        [self updateConstraintsPhotoView:pg_Height];
    }else if(model.pic_urls.count > 3 && model.pic_urls.count <= 6)
    {
        pg_Height = (SCREEN_W - 73) / 3 * 2 + 5;
        [self updateConstraintsPhotoView:pg_Height];
    }else if (model.pic_urls.count > 6 && model.pic_urls.count <= 9)
    {
        pg_Height = (SCREEN_W - 73) + 10;
        [self updateConstraintsPhotoView:pg_Height];
    }else if (model.pic_urls.count == 1)
    {
        // 单张图片 为 4/7
        pg_Height = (SCREEN_W - 73) / 3;
        [self updateConstraintsPhotoView:pg_Height];
    }
    else
    {
        // 当没有图片的时候 重新布局~
        [_photosGroup mas_remakeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self.labelText.mas_bottom).with.offset(0);
            make.height.mas_equalTo(@0.0);
        }];
    }
}
- (void)updateConstraintsPhotoView:(CGFloat)pv_height
{
    // 更新约束
    [_photosGroup mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelText.mas_bottom).with.offset(SPACE);
        make.left.right.mas_equalTo(self.labelText);
        make.height.mas_equalTo(pv_height);
    }];
}
/// 点击链接的方法
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
//    XTNSLog(@"被点击的url === %@", url);
}

/// 点击长按数据
- (void)attributedLabel:(TTTAttributedLabel *)label
  didSelectLinkWithDate:(NSDate *)date
{
    
}

/// 点击文本链接
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
//    XTNSLog(@"被点击的话题 === %@", NSStringFromRange(result.range))

}
/// 长按链接的方法
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point
{
//    XTNSLog(@"被长按的url === %@", url)
}
/// 可以长按的文本
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point
{
//    XTNSLog(@"被长按的话题 === %@", NSStringFromRange(result.range))
}
#pragma mark - Share
- (void)shareClick:(UIButton *)sender
{
//    XTNSLog(@"summerxx ---- click")
    self.shareBlock();
}
#pragma mark - Love
- (void)loveClick:(UIButton *)sender
{
    self.loveBlock(_indexPath);
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
