
//
//  WeiboTableViewCell.m
//  XTWeibo
//
//  Created by zjwang on 17/2/20.
//  Copyright © 2017年 夏天然后. All rights reserved.
//

#import "WeiboTableViewCell.h"
#import "Statuses.h"

#define SPACE 5
@implementation WeiboTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        self.picImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.labelText];
        [self.contentView addSubview:self.picImageView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.labelText.frame = CGRectMake(SPACE, SPACE, [UIScreen mainScreen].bounds.size.width, self.statuses.textHeight);
    self.labelText.numberOfLines = 0;
    self.labelText.backgroundColor = [UIColor lightGrayColor];
    self.labelText.text = _statuses.text;
    
    self.picImageView.frame = CGRectMake(SPACE, SPACE * 2 + self.statuses.textHeight, 80, 80);
    self.picImageView.backgroundColor = [UIColor purpleColor];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
