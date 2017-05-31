//
//  MKJMainPopoutView.m
//  PhotoAnimationScrollDemo
//
//  Created by MKJING on 16/8/9.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJMainPopoutView.h"
#import "MKJConstant.h"
#import "NSArray+Extension.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "MKJCollectionViewCell.h"
#import "MKJCollectionViewFlowLayout.h"
#import "MKJItemModel.h"
#import "UIImageView+WebCache.h"


@interface MKJMainPopoutView () <UICollectionViewDelegate,UICollectionViewDataSource,MKJCollectionViewFlowLayoutDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIView *underBackView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger selectedIndex; // 选择了哪个

@end

static NSString *indentify = @"MKJCollectionViewCell";

@implementation MKJMainPopoutView
{
    NSInteger _selectedIndex;
}

// self是继承于UIView的，给上面的第一个View容器加个动画
- (void)showInSuperView:(UIView *)superView
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.25;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1f, 0.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    popAnimation.keyTimes = @[@0.2f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [superView addSubview:self];
    [self.underBackView.layer addAnimation:popAnimation forKey:nil];
}

// 初始化 设置背景颜色透明点，然后加载子视图
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        _selectedIndex = 0;
        self.backgroundColor = [UIColor clearColor];
        [self setupDataSource];
        [self addsubviews];
    }
    return self;
}

//加载数据源
- (void)setupDataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 11; i ++) {
            MKJItemModel *model = [[MKJItemModel alloc] init];
            model.imageName = [NSString stringWithFormat:@"%zd",i];
            
            [self setupModelForIndex:i model:model];
//            model.latitude = 22.56262283436824+i*0.0001;
//            model.longitude = 113.9021362493373+i*0.004;
            [_dataSource addObject:model];
        }
    }
}

- (void)setupModelForIndex:(NSInteger)index model:(MKJItemModel* )model{
    switch (index) {
        case 0:
            model.titleName = @"海岸城购物中心";
            model.longitude = 113.942215;
            model.latitude = 22.52261;
            
            break;
        case 1:
            model.titleName = @"南山欢乐颂购物中心";
            model.longitude = 113.926561;
            model.latitude = 22.541054;
            
            break;
        case 2:
            model.titleName = @"京基滨河时代";
            model.longitude = 114.032729;
            model.latitude = 22.53471;
            
            break;
        case 3:
            model.titleName = @"购物公园";
            model.longitude = 114.060586;
            model.latitude = 22.541451;
            
            break;
        case 4:
           
            model.titleName = @"苹果总部";
            model.longitude = -122.032167;
            model.latitude = 37.322997;
            break;
        case 5:
            model.titleName = @"华侨城";
            model.longitude = 113.990657;
            model.latitude = 22.540561;
            
            break;
        case 6:
            model.titleName = @"源兴科技大厦";
            model.longitude = 113.958316;
            model.latitude = 22.559209;
            
            break;
        case 7:
            model.titleName = @"海岸城购物中心";
            model.longitude = 113.942211;
            model.latitude = 22.52261;
            
            break;
        case 8:
            model.titleName = @"奥特莱斯";
            model.longitude = 114.31518;
            model.latitude = 22.602274;
            break;
        case 9:
            model.titleName = @"海岸城购物中心";
            model.longitude = 113.942212;
            model.latitude = 22.52261;
            
            break;
        case 10:
            model.titleName = @"海岸城购物中心";
            model.longitude = 113.922214;
            model.latitude = 22.52261;
            
            break;
       
            
        default:
            break;
    }
    
}


// 加载子视图
- (void)addsubviews
{
    [self addSubview:self.underBackView];
    [self.underBackView addSubview:self.collectionView];
    
    [self.underBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MKJItemModel *model = self.dataSource[indexPath.item];
    MKJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    cell.heroImageVIew.image = [UIImage imageNamed:model.imageName];
    return cell;
}

// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    if ([self.collectionView.collectionViewLayout isKindOfClass:[MKJCollectionViewFlowLayout class]]) {
        CGPoint pInUnderView = [self.underBackView convertPoint:collectionView.center toView:collectionView];
        
        // 获取中间的indexpath
        NSIndexPath *indexpathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
        
        if (indexPath.row == indexpathNew.row)
        {
            NSLog(@"点击了同一个");
            return;
        }
        else
        {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}


#pragma mark - 懒加载
- (UIView *)underBackView
{
    if (_underBackView == nil) {
        _underBackView = [[UIView alloc] init];
        _underBackView.backgroundColor = [UIColor clearColor] ;
        
//        _underBackView.originX = 30;
//        _underBackView.originY = 60;
//        _underBackView.width = SCREEN_WIDTH - 2 * _underBackView.originX;
//        _underBackView.height = SCREEN_HEIGHT - 2 * _underBackView.originY;
        
//        _underBackView.layer.cornerRadius = 5;
//        _underBackView.layer.borderColor = [UIColor redColor].CGColor;
//        _underBackView.layer.borderWidth = 2.0f;
    }
    return _underBackView;
}


- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        flow.needAlpha = NO;
        flow.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, self.underBackView.bounds.size.width, self.underBackView.bounds.size.height * 0.65) collectionViewLayout:flow];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:indentify bundle:nil] forCellWithReuseIdentifier:indentify];
    }
    return _collectionView;
}


#pragma CustomLayout的代理方法
- (void)collectioViewScrollToIndex:(NSInteger)index
{
    if(_selectedIndex != index){
        [self.delegate selected:self.dataSource[index]];
    }
    _selectedIndex = index;
}


// 第一次加载的时候刷新collectionView
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = [NSMutableArray arrayWithArray: dataSource];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.underBackView.width / 2, self.underBackView.height/MKJZoomScale);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //这里确定首尾最终偏移量
    CGFloat oneX =self.underBackView.width / 4;
    return  UIEdgeInsetsMake(0, oneX, 0, oneX);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //这里设置cell间距
    return  45;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return  30;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}






@end
