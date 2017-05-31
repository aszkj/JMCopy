//
//  BFInfinitScrollView.m
//  BFTest
//
//  Created by 伯符 on 16/5/13.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFInfinitScrollView.h"
//广告的宽度
#define kAdViewWidth  _adScrollView.bounds.size.width
//广告的高度
#define kAdViewHeight  _adScrollView.bounds.size.height
//由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标
#define HIGHT _adScrollView.bounds.origin.y

#define NB_BASE_COLOR  RGBCOLORA(6,167,225, 1.0)

@interface BFInfinitScrollView ()<UIScrollViewDelegate>
@property (nonatomic,assign) NSUInteger centerImageIndex;
@property (nonatomic,assign) NSUInteger leftImageIndex;
@property (nonatomic,assign) NSUInteger rightImageIndex;
@property (nonatomic,strong) NSTimer *moveTimer;
@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;
@property (nonatomic,strong) NSArray * models;
@end

@implementation BFInfinitScrollView{
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;
}

#pragma mark -- Getters
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认滚动式3.0s
        _adMoveTime = 3.0;
        _adScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _adScrollView.bounces = NO;
        _adScrollView.delegate = self;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.backgroundColor = [UIColor whiteColor];
        _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
        _adScrollView.contentSize = CGSizeMake(kAdViewWidth * 3, kAdViewHeight);
        //该句是否执行会影响pageControl的位置,如果该应用上面有导航栏,就是用该句,否则注释掉即可
        _adScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAdViewWidth, kAdViewHeight)];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _leftImageView.backgroundColor = [UIColor blackColor];
        [_adScrollView addSubview:_leftImageView];
        
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAdViewWidth, 0, kAdViewWidth, kAdViewHeight)];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        _centerImageView.backgroundColor = [UIColor blackColor];
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        [_adScrollView addSubview:_centerImageView];
        
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAdViewWidth*2, 0, kAdViewWidth, kAdViewHeight)];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImageView.backgroundColor = [UIColor blackColor];
        [_adScrollView addSubview:_rightImageView];
        
        _isNeedCycleRoll = YES;
        [self addSubview:_adScrollView];
    }
    return self;
}

+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSMutableArray *)imageArr placeHoderImageName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle currentIndex:(NSInteger)index
{
    if (imageArr.count==0)
        return nil;
    
//    NSMutableArray * imagePaths = [[NSMutableArray alloc]init];
//    for (NSString * imageName in imageArr)
//    {
//        NSURL * imageURL = [NSURL URLWithString:imageName];
//        [imagePaths addObject:imageURL];
//    }
    BFInfinitScrollView * infinitScr = [BFInfinitScrollView adScrollViewWithFrame:frame imageLinkURL:imageArr   pageControlShowStyle:PageControlShowStyle currentIndex:index];
//    infinitScr.placeHoldImage = [UIImage imageNamed:imageName];
    return infinitScr;
}

+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSMutableArray *)imageLinkURL pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle currentIndex:(NSInteger)index
{
    if (imageLinkURL.count==0)
        return nil;
    BFInfinitScrollView * scroll = [[BFInfinitScrollView alloc]initWithFrame:frame];
//    [BFInfinitScrollView setimageLinkURL:imageLinkURL];
    [scroll setimage:imageLinkURL currentIndex:index];
//    [BFInfinitScrollView setPageControlShowStyle:PageControlShowStyle];
    return scroll;
}

- (void)setimage:(NSMutableArray *)imgArray currentIndex:(NSInteger)index{
    self.imageArray = imgArray;
    self.leftImageIndex = index - 1;
    if (self.leftImageIndex == -1) {
        self.leftImageIndex = _imageArray.count-1;
    }
    self.centerImageIndex = index;
    self.rightImageIndex = index + 1;
    if (imgArray.count==1)
    {
        _adScrollView.scrollEnabled = NO;
        self.rightImageIndex = 0;
    }
//    [_leftImageView setImageWithURL:imageLinkURL[leftImageIndex] placeholderImage:self.placeHoldImage];
//    [_centerImageView setImageWithURL:imageLinkURL[centerImageIndex] placeholderImage:self.placeHoldImage];
//    [_rightImageView setImageWithURL:imageLinkURL[rightImageIndex] placeholderImage:self.placeHoldImage];
    if (self.rightImageIndex == _imageArray.count)
    {
        self.rightImageIndex = 0;
    }
    
    _leftImageView.image = imgArray[self.leftImageIndex];
    _centerImageView.image = imgArray[self.centerImageIndex];
    _rightImageView.image = imgArray[self.rightImageIndex];
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    if (_adScrollView.contentOffset.x == 0)
    {
        self.centerImageIndex = self.centerImageIndex - 1;
        self.leftImageIndex = self.leftImageIndex - 1;
        self.rightImageIndex = self.rightImageIndex - 1;
        
        if (self.leftImageIndex == -1) {
            self.leftImageIndex = _imageArray.count-1;
        }
        if (self.centerImageIndex == -1)
        {
            self.centerImageIndex = _imageArray.count-1;
        }
        if (self.rightImageIndex == -1)
        {
            self.rightImageIndex = _imageArray.count-1;
        }
    }
    else if(_adScrollView.contentOffset.x == kAdViewWidth * 2)
    {
        self.centerImageIndex = self.centerImageIndex + 1;
        self.leftImageIndex = self.leftImageIndex + 1;
        self.rightImageIndex = self.rightImageIndex + 1;
        
        if (self.leftImageIndex >= _imageArray.count) {
            self.leftImageIndex = 0;
        }
        if (self.centerImageIndex == _imageArray.count)
        {
            self.centerImageIndex = 0;
        }
        if (self.rightImageIndex == _imageArray.count)
        {
            self.rightImageIndex = 0;
        }
    }
    else
    {
        NSLog(@"ssssss");
        
        return;
    }
    _leftImageView.image = self.imageArray[self.leftImageIndex];
    _centerImageView.image = self.imageArray[self.centerImageIndex];
    _rightImageView.image = self.imageArray[self.rightImageIndex];
//    [_leftImageView setImageWithURL:_imageLinkURL[self.leftImageIndex] placeholderImage:self.placeHoldImage];
//    [_centerImageView setImageWithURL:_imageLinkURL[self.centerImageIndex] placeholderImage:self.placeHoldImage];
//    [_rightImageView setImageWithURL:_imageLinkURL[self.rightImageIndex] placeholderImage:self.placeHoldImage];
//    _pageControl.currentPage = self.centerImageIndex;
    
    //有时候只有在有广告标签的时候才需要加载
//    if (_adTitleArray)
//    {
//        if (self.centerImageIndex<=_adTitleArray.count-1)
//        {
//            _centerAdLabel.text = _adTitleArray[self.centerImageIndex];
//        }
//    }
    _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
//    if (!_isTimeUp) {
//        [moveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_adMoveTime]];
//    }
    
    _isTimeUp = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
}

/**
 *  @author ZY, 15-04-26
 *
 *  @brief  当前显示的图片被点击
 */
-(void)tap
{
    if (_callBack)
    {
        _callBack(self.centerImageIndex,_imageArray[self.centerImageIndex]);
    }
    
    if (self.models&&_callBackForModel)
    {
        _callBackForModel(self.models[self.centerImageIndex]);
    }
}

+ (id)adScrollViewWithFrame:(CGRect)frame modelArr:(NSArray *)modelArr imagePropertyName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle{
    return nil;
}


@end
