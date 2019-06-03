//
//  ZXCycleScrollView.m
//  Created by 虞振兴 on 2017/11/7.
//  Copyright © 2017年 yuzx. All rights reserved.
//

#import "ZXCycleScrollView.h"
#import "UIImageView+WebCache.h"

#define ZXMainScrollViewWidth self.mainScrollView.frame.size.width
#define ZXMainScrollViewHeight self.mainScrollView.frame.size.height

@interface ZXCycleScrollView ()
@property (nonatomic,assign) CGFloat imgWidth;//图片宽度
@property (nonatomic,assign) CGFloat itemMargnPadding;//间距 2张图片间的间距  默认0
@property (nonatomic,assign) NSInteger imgCount;//数量
@property (nonatomic,weak) NSTimer *timer;
@end

@implementation ZXCycleScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imgWidth = ZXMainScrollViewWidth;
        [self initialization];
        [self setUpUI];
    }
    return self;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray {
    ZXCycleScrollView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.sourceDataArr = dataArray;
    return scrollView;
}

//图片间有间距  又要有翻页效果～～
+(instancetype)initWithFrame:(CGRect)frame withMargnPadding:(CGFloat)margnPadding withImgWidth:(CGFloat)imgWidth{
    ZXCycleScrollView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.imgWidth = imgWidth;
    scrollView.itemMargnPadding = margnPadding;
    return scrollView;
}

+(instancetype)initWithFrame:(CGRect)frame withMargnPadding:(CGFloat)margnPadding withImgWidth:(CGFloat)imgWidth dataArray:(NSArray *)dataArray{
    ZXCycleScrollView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.imgWidth = imgWidth;
    scrollView.itemMargnPadding = margnPadding;
    scrollView.sourceDataArr = dataArray;
    return scrollView;
}


-(void)initialization{
     _autoScrollTimeInterval = 2.0;
    self.otherPageControlColor = [UIColor grayColor];
    self.curPageControlColor = [UIColor whiteColor];
    _showPageControl = YES;
    _hidesForSinglePage = YES;
    _autoScroll = YES;
      self.sourceDataArr = [NSArray array];
}

-(void)setUpUI{
    [self addSubview:self.mainScrollView];
    //图片视图；左边
    self.leftIV = [[UIImageView alloc] init];
    self.leftIV.contentMode = UIViewContentModeScaleToFill;
    self.leftIV.userInteractionEnabled = YES;
    [self.leftIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapGes)]];
    [self.mainScrollView addSubview:self.leftIV];
    
    //图片视图；中间
    self.centerIV = [[UIImageView alloc] init];
    self.centerIV.contentMode = UIViewContentModeScaleToFill;
    self.centerIV.userInteractionEnabled = YES;
    [self.centerIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerTapGes)]];
    [self.mainScrollView addSubview:self.centerIV];
    
    //图片视图；右边
    self.rightIV = [[UIImageView alloc] init];
    self.rightIV.contentMode = UIViewContentModeScaleToFill;
    self.rightIV.userInteractionEnabled = YES;
    [self.rightIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapGes)]];
    [self.mainScrollView addSubview:self.rightIV];
    
    [self updateViewFrameSetting];
}


//创建页码指示器
-(void)createPageControl{
    if (_pageControl) [_pageControl removeFromSuperview];
    if (self.sourceDataArr.count == 0) return;
    if ((self.sourceDataArr.count == 1) && self.hidesForSinglePage) return;
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width - 200)/2, ZXMainScrollViewHeight - 30, 200, 30)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
     _pageControl.pageIndicatorTintColor = self.otherPageControlColor;
    _pageControl.currentPageIndicatorTintColor = self.curPageControlColor;
    
    _pageControl.hidden = !_showPageControl;
}

-(void)updateViewFrameSetting{
    //设置偏移量
    self.mainScrollView.contentSize = CGSizeMake(ZXMainScrollViewWidth * 3, ZXMainScrollViewHeight);
    self.mainScrollView.contentOffset = CGPointMake(ZXMainScrollViewWidth, 0.0);
    
    //图片视图；左边
    self.leftIV.frame = CGRectMake(self.itemMargnPadding/2, 0.0, self.imgWidth, ZXMainScrollViewHeight);
    //图片视图；中间
    self.centerIV.frame = CGRectMake(ZXMainScrollViewWidth + self.itemMargnPadding/2, 0.0, self.imgWidth, ZXMainScrollViewHeight);
    //图片视图；右边
    self.rightIV.frame = CGRectMake(ZXMainScrollViewWidth * 2.0 + self.itemMargnPadding/2, 0.0, self.imgWidth, ZXMainScrollViewHeight);
    
//    self.leftIV.layer.cornerRadius = 8.0;
//    self.leftIV.layer.masksToBounds = YES;
//    self.centerIV.layer.cornerRadius = 8.0;
//    self.centerIV.layer.masksToBounds = YES;
//    self.rightIV.layer.cornerRadius = 8.0;
//    self.rightIV.layer.masksToBounds = YES;
}

-(void)setSourceDataArr:(NSArray *)sourceDataArr {
    _sourceDataArr = sourceDataArr;
    if (sourceDataArr.count < _sourceDataArr.count) {
        [_mainScrollView setContentOffset:CGPointMake(ZXMainScrollViewWidth, 0) animated:NO];
    }
    self.currentImageIndex = 0;
    self.imgCount = sourceDataArr.count;
    self.pageControl.numberOfPages = self.imgCount;
    [self setInfoByCurrentImageIndex:self.currentImageIndex];
    
    if (sourceDataArr.count != 1) {
        self.mainScrollView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        [self invalidateTimer];
        // ZXMainScrollViewWidth < self.frame.size.width    这样的 说明是 图片有间距 卡片 翻页效果那种布局
        self.mainScrollView.scrollEnabled = ZXMainScrollViewWidth < self.frame.size.width ?YES : NO;
    }
    
    [self createPageControl];
    
}

- (void)setInfoByCurrentImageIndex:(NSUInteger)currentImageIndex {
    if(self.self.imgCount == 0){
        return;
    }
    if([self isHttpString:self.sourceDataArr[currentImageIndex]]){
        [self.centerIV sd_setImageWithURL:[NSURL URLWithString:self.sourceDataArr[currentImageIndex]] placeholderImage:self.placeHolderImage];
    }else {
       self.centerIV.image = self.sourceDataArr[currentImageIndex];
    }
    
    NSInteger leftIndex = (unsigned long)((_currentImageIndex - 1 + self.imgCount) % self.imgCount);
   if([self isHttpString:self.sourceDataArr[leftIndex]]){
        [self.leftIV sd_setImageWithURL:[NSURL URLWithString:self.sourceDataArr[leftIndex]] placeholderImage:self.placeHolderImage];
    }else {
        self.leftIV.image = self.sourceDataArr[leftIndex];
    }
    
    NSInteger rightIndex = (unsigned long)((_currentImageIndex + 1) % self.imgCount);
    if([self isHttpString:self.sourceDataArr[rightIndex]]){
        [self.rightIV sd_setImageWithURL:[NSURL URLWithString:self.sourceDataArr[rightIndex]] placeholderImage:self.placeHolderImage];
    }else {
        self.rightIV.image = self.sourceDataArr[rightIndex];
    }

   _pageControl.currentPage = currentImageIndex;
}

- (void)reloadImage {
    //~~ 避免0
    if(self.imgCount == 0) {
        return;
    }
    CGPoint contentOffset = [self.mainScrollView contentOffset];
    if (contentOffset.x > ZXMainScrollViewWidth) { //向左滑动
        _currentImageIndex = (_currentImageIndex + 1) % self.imgCount;
    } else if (contentOffset.x < ZXMainScrollViewWidth) { //向右滑动
        _currentImageIndex = (_currentImageIndex - 1 + self.imgCount) % self.imgCount;
    }
    
    [self setInfoByCurrentImageIndex:_currentImageIndex];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    [self.mainScrollView setContentOffset:CGPointMake(ZXMainScrollViewWidth, 0) animated:NO] ;
    self.pageControl.currentPage = self.currentImageIndex;
    
    if ([self.delegate respondsToSelector:@selector(zxCycleScrollView:didScrollToIndex:)]) {
        [self.delegate zxCycleScrollView:self didScrollToIndex:self.currentImageIndex];
    } else if (self.itemDidScrollToBlock) {
        self.itemDidScrollToBlock(self.currentImageIndex);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self createTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}


#pragma mark -- action
-(void)leftTapGes{
    if([self.delegate respondsToSelector:@selector(zxCycleScrollView:didSelectItemAtIndex:)]){
        NSInteger leftIndex = (unsigned long)((_currentImageIndex - 1 + self.imgCount) % self.imgCount);
        [self.delegate zxCycleScrollView:self didSelectItemAtIndex:leftIndex];
    }
}

-(void)rightTapGes{
    if([self.delegate respondsToSelector:@selector(zxCycleScrollView:didSelectItemAtIndex:)]){
         NSInteger rightIndex = (unsigned long)((_currentImageIndex + 1) % self.imgCount);
        [self.delegate zxCycleScrollView:self didSelectItemAtIndex:rightIndex];
    }
}

-(void)centerTapGes{
    if([self.delegate respondsToSelector:@selector(zxCycleScrollView:didSelectItemAtIndex:)]){
        [self.delegate zxCycleScrollView:self didSelectItemAtIndex:self.currentImageIndex];
    }
}

-(void)createTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    if(_timer){
    [_timer invalidate];
    _timer = nil;
    }
}

- (void)automaticScroll {
    if (0 == _imgCount) return;
    if(self.mainScrollView.scrollEnabled == NO) return;
    
    [self.mainScrollView setContentOffset:CGPointMake(ZXMainScrollViewWidth*2, 0.0) animated:YES];
 
}



#pragma mark -- properties
-(void)setItemMargnPadding:(CGFloat)itemMargnPadding {
    _itemMargnPadding = itemMargnPadding;
    self.mainScrollView.frame = CGRectMake((ZXMainScrollViewWidth - (self.imgWidth + itemMargnPadding))/2, 0, self.imgWidth + itemMargnPadding, ZXMainScrollViewHeight);
    [self updateViewFrameSetting];
}

-(void)setCurPageControlColor:(UIColor *)curPageControlColor {
    _curPageControlColor = curPageControlColor;
    _pageControl.currentPageIndicatorTintColor = curPageControlColor; 
}

-(void)setOtherPageControlColor:(UIColor *)otherPageControlColor {
    _otherPageControlColor = otherPageControlColor;
    _pageControl.pageIndicatorTintColor = otherPageControlColor;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self createTimer];
    }
}


-(void)setPlaceHolderImage:(UIImage *)placeHolderImage {
    _placeHolderImage = placeHolderImage;
    self.centerIV.image = placeHolderImage;
    self.leftIV.image = placeHolderImage;
    self.rightIV.image = placeHolderImage;
}

-(void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
}


-(UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.clipsToBounds = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}



-(BOOL)isHttpString:(NSString *)urlStr {
    if([urlStr hasPrefix:@"http:"] || [urlStr hasPrefix:@"https:"]){
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - life circles
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainScrollView.delegate = nil;
    [self invalidateTimer];
}

@end
