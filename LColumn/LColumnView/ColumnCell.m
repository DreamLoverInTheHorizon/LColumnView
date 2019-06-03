//
//  ColumnCell.m
//  LColumn
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "ColumnCell.h"
#import "UIImageView+WebCache.h"

@interface ColumnCell ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation ColumnCell
#pragma mark -- LazyLoad
- (UIImageView *)imageView {
    CGFloat cellSize = self.frame.size.width - 50;
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, cellSize, cellSize)];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 5, self.frame.size.width, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor grayColor];
    }
    return _titleLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
//  添加子视图
- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
}
//  数据绑定
- (void)setModel:(ColumnModel *)model {
    _model = model;
    //  判断是本地图片还是网络图片
    if ([model.imageUrl hasPrefix:@"http"]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    }else {
        _imageView.image = [UIImage imageNamed:model.imageUrl];
    }
    _titleLabel.text = model.title;
}
@end
