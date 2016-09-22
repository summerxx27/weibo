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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.labelName];
        [self.contentView addSubview:self.labelTime];
        [self.contentView addSubview:self.labelText];
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
        // 文本内容要显示多长
        _labelName.preferredMaxLayoutWidth = SCREEN_W - 63;
        _labelName.numberOfLines = 0;
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(SPACE);
            make.left.equalTo(self.headerImageView.mas_right).with.offset(SPACE);
            make.right.equalTo(self.contentView).with.offset(-SPACE);
        }];
        _labelName.backgroundColor = [UIColor yellowColor];
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
        _labelTime.backgroundColor = [UIColor greenColor];
        // 发布的内容
        // 视图是多宽的 进行相应的设置
        self.labelText.preferredMaxLayoutWidth = SCREEN_W - 63;
        _labelText.delegate = self;
        _labelText.numberOfLines = 0;
        [_labelText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTime.mas_bottom).with.offset(SPACE);
            make.left.right.mas_equalTo(self.labelTime);
        }];
        _labelText.backgroundColor = [UIColor lightGrayColor];
        // 自动检测链接
        _labelText.enabledTextCheckingTypes = NSTextCheckingTypeLink;
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
#pragma mark - 赋值
- (void)configCellWithModel:(CommonModel *)model user:(User *)userModel
{
    
    // 头像
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:userModel.profile_image_url] placeholderImage:nil];
    _labelName.text = [NSString stringWithFormat:@"%@ %@", userModel.name, @"我测试cell的高度是否准确, 我测试cell的高度是否准确"];
    _labelTime.text = [NSString stringWithFormat:@"%@ %@", model.created_at, @"我测试cell的高度是否准确, 我测试cell的高度是否准确"];;
    // 发布的内容
    _labelText.text = model.text;
    
    
    // 话题检测
    NSArray *results = [[XTWBStatusHelper regexTopic] matchesInString:model.text options:0 range:NSMakeRange(0, model.text.length)];
    for (NSTextCheckingResult *result in results) {
        // 话题范围
        NSLog(@"range === %@", NSStringFromRange(result.range));
        [_labelText addLinkWithTextCheckingResult:result];
    }
    // 表情检测
    NSArray *results1 = [[XTWBStatusHelper regexEmoticon] matchesInString:model.text options:0 range:NSMakeRange(0, model.text.length)];
    for (NSTextCheckingResult *result in results1) {
        NSLog(@"range === %@", NSStringFromRange(result.range));
        [_labelText addLinkWithTextCheckingResult:result];
    }
    
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
/// 点击链接的方法
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"被点击的url === %@", url);
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
    NSLog(@"被点击的话题 === %@", NSStringFromRange(result.range))

}
/// 长按链接的方法
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point
{
    NSLog(@"被长按的url === %@", url);
}
/// 可以长按的文本
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point
{
    NSLog(@"被长按的话题 === %@", NSStringFromRange(result.range))
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
