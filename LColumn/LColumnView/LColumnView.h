//
//  LColumnView.h
//  LColumn
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LColumnType) {
    LColumnTypeDefualt = 0,             //  默认类型
    LColumnTypeBanner                   //  带轮播图
};

@protocol LColumnViewDelegate <NSObject>
@optional
/* *
 *  点击轮播图
 */
- (void)didSelectBannerAtIndex:(NSInteger)index;
/* *
 *  点击栏目
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectColumnAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LColumnView : UIView
//  设置栏目类型
@property (nonatomic, assign)LColumnType columnType;
//  代理
@property (nonatomic, weak)id <LColumnViewDelegate> delegate;
//  调整itemSize
@property (nonatomic)CGSize itemSize;
//  数据
@property (nonatomic, strong)NSArray *dataArr;
//  轮播图
@property (nonatomic, strong)NSArray *imagesArr;

@end

NS_ASSUME_NONNULL_END
