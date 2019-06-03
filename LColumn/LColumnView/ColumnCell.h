//
//  ColumnCell.h
//  LColumn
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColumnModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColumnCell : UICollectionViewCell

//  栏目标题、图片信息
@property (nonatomic, strong)ColumnModel *model;

@end

NS_ASSUME_NONNULL_END
