//
//  CommonTableViewCell.m
//  XTWeibo
//
//  Created by summerxx on 16/9/13.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "CommonTableViewCell.h"

@implementation CommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headerImageView];
    }
    return self;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
    }
    return _headerImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 进行约束设置
        make.top.left.equalTo(self.contentView).with.offset(20);
        make.width.height.mas_equalTo(60);
    }];
    // set
    _headerImageView.layer.cornerRadius = 60 / 2;
    _headerImageView.backgroundColor = [UIColor cyanColor];
    
//    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[_dataModel.user]] placeholderImage:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
