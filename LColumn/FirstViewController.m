//
//  FirstViewController.m
//  LColumn
//
//  Created by apple on 2019/5/31.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "FirstViewController.h"
#import "LColumnView/LColumnView.h"
#import "ColumnModel.h"
#import <MJExtension/MJExtension.h>


@interface FirstViewController () <LColumnViewDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat viewWidth = self.view.frame.size.width;
    // 商城标签
    CGFloat cellHegiht = viewWidth / 2;
    //  模拟数据
    NSArray *dataArr = @[@{@"title":@"兑换区",@"imageUrl":@"business"},
                         @{@"title":@"电商区",@"imageUrl":@"temai"},
                         @{@"title":@"促销区",@"imageUrl":@"techan"},
                         @{@"title":@"签到",@"imageUrl":@"sale"},
                         @{@"title":@"热销区",@"imageUrl":@"sheq"},
                         @{@"title":@"推荐区",@"imageUrl":@"fanchang"},
                         @{@"title":@"拍卖区",@"imageUrl":@"paimai"},
                         @{@"title":@"积分区",@"imageUrl":@"jifen"}
                         ];
    NSArray *imageArray = @[@"http://shop.beijinglvsan.com/LKT/images/1558514570797.png", @"http://shop.beijinglvsan.com/LKT/images/1558514588623.png", @"http://shop.beijinglvsan.com/LKT/images/1541599397768.jpeg"];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *data in dataArr) {
        [modelArr addObject:[ColumnModel mj_objectWithKeyValues:data]];
    }
    //  不带轮播图
    LColumnView *columnView = [[LColumnView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, cellHegiht)];
//    columnView.columnType = LColumnTypeDefualt;
    columnView.delegate = self;
    columnView.imagesArr = imageArray;
    columnView.itemSize = CGSizeMake(viewWidth / 4, viewWidth / 4);
    columnView.dataArr = modelArr;
    [self.view addSubview:columnView];
}
#pragma mark -- LColumnViewDelegate
- (void)didSelectBannerAtIndex:(NSInteger)index {
    NSLog(@" 点击第%ld个轮播图", index);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectColumnAtIndex:(NSInteger)index {
    NSLog(@" 点击 colllection%@第%ld个栏目", collectionView, index);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
