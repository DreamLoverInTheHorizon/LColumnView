//
//  LColumnView.m
//  LColumn
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "LColumnView.h"
#import "ColumnCell.h"
#import "ColumnModel.h"
//  轮播图
#import "ZXCycleScrollView.h"
#import "Masonry.h"


#define MSW self.frame.size.width

static NSString *const cellIdentifier = @"ColumnCell";

@interface LColumnView () <ZXCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)ZXCycleScrollView *cycleView;
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation LColumnView

#pragma mark -- LazyLoad
/* *
 *  轮播随便找的，不喜欢用的可以用其他替换
 */
- (ZXCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [ZXCycleScrollView  initWithFrame:CGRectMake(0, 0, MSW, 300) withMargnPadding:0 withImgWidth:MSW dataArray:nil] ;
        _cycleView.delegate = self;
        _cycleView.otherPageControlColor = [UIColor blueColor];
        _cycleView.curPageControlColor = [UIColor whiteColor];
        _cycleView.autoScroll = YES;
    }
    return _cycleView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemSize = MSW / 4;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _itemSize = CGSizeMake(itemSize, itemSize);
        flowLayout.itemSize = _itemSize;
        //    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //    layout.footerReferenceSize = CGSizeMake(MSW, 120);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ColumnCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _collectionView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setCollectionView];
    }
    return self;
}
//  子视图
- (void)setCollectionView {
    self.backgroundColor = [UIColor whiteColor];
    //  轮播
    [self addSubview:self.cycleView];
    //  分类模块
    [self addSubview:self.collectionView];
}
- (void)setColumnType:(LColumnType)columnType {
    _columnType = columnType;
    [self setNeedsLayout];
}
#pragma mark --  数据
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [_collectionView reloadData];
}
- (void)setImagesArr:(NSArray *)imagesArr {
    _imagesArr = imagesArr;
    _cycleView.sourceDataArr = imagesArr;
}

#pragma mark -- UICollectionViewDelegate/DataSource
//  设置分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _itemSize;
}
//  item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

//  item数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellReuseIdentify = cellIdentifier;
    ColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentify forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    return cell;
}
//  点击栏目回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didSelectColumnAtIndex:)]) {
        [self.delegate collectionView:_collectionView didSelectColumnAtIndex:indexPath.row];
    }
}
//  点击轮播图回调
- (void)zxCycleScrollView:(ZXCycleScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBannerAtIndex:)]) {
        [self.delegate didSelectBannerAtIndex:index];
    }
}

#pragma mark -- frame调整
//  调整itemSize
- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    [_collectionView reloadData];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_columnType == LColumnTypeDefualt) {
        [_cycleView removeFromSuperview];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
    }else if (_columnType == LColumnTypeBanner) {
        [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(BannerHeight);
        }];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self->_cycleView.mas_bottom).offset(0);
            make.height.mas_equalTo(self.frame.size.height - BannerHeight);
        }];
    }
}
@end
