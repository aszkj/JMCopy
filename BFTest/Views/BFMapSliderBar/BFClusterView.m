//
//  BFClusterView.m
//  BFTest
//
//  Created by 伯符 on 16/9/13.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFClusterView.h"
#import "ClusterCell.h"
#import "BFDataGenerator.h"
#import "BFMapItemModel.h"
@interface BFClusterView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@end

@implementation BFClusterView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    [self addCollectionView];

}

- (void)addCollectionView{
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewFlowLayout.minimumLineSpacing = 1.0f;
    collectionViewFlowLayout.minimumInteritemSpacing = 1.0f;
    collectionViewFlowLayout.itemSize = CGSizeMake((self.width - 4)/3, (self.width - 4)/3);
    
    self.itemsView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:collectionViewFlowLayout];
    self.itemsView.contentInset = UIEdgeInsetsMake(0, 1, 0, 1);
    self.itemsView.backgroundColor = [UIColor clearColor];
    self.itemsView.delegate = self;
    self.itemsView.dataSource = self;
    self.itemsView.bounces = YES;
    self.itemsView.scrollEnabled = YES;
    self.itemsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.itemsView registerClass:[ClusterCell class] forCellWithReuseIdentifier:@"ClusterCell"];
    [self.itemsView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    
    [self addSubview:self.itemsView];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.items.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClusterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClusterCell" forIndexPath:indexPath];
    BFMapItemModel *model = self.items[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[model.logo isKindOfClass:[NSNull class]] == YES?@"":model.logo]placeholderImage:[UIImage imageNamed:[BFDataGenerator randomIconImageName]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BFMapItemModel *model = self.items[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(didSelectedMapModelItem:)]) {
        [self.delegate didSelectedMapModelItem:model];
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *collectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50*ScreenRatio)];
        header.backgroundColor = [UIColor clearColor];
        
        UILabel *numIcon = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 32*ScreenRatio, 32*ScreenRatio)];
        numIcon.center = CGPointMake(self.width/2, 25*ScreenRatio);
        numIcon.text = [NSString stringWithFormat:@"%ld",self.items.count];
        numIcon.textColor = [UIColor yellowColor];
        numIcon.textAlignment = NSTextAlignmentCenter;
        numIcon.font = BFFontOfSize(20);
        numIcon.layer.cornerRadius = numIcon.width / 2;
        numIcon.layer.masksToBounds = YES;
        numIcon.layer.borderColor = [[UIColor whiteColor]CGColor];
        numIcon.layer.borderWidth = 1.0f;
        [header addSubview:numIcon];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(self.width - 25*ScreenRatio, 10, 20*ScreenRatio, 20*ScreenRatio);
        [deleteBtn setImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:deleteBtn];
        [collectionHeader addSubview:header];
        return collectionHeader;
    }else{
        return nil;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_width, 50*ScreenRatio);
}

- (void)delete:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(clusterDeleteClick:)]) {
        [self.delegate clusterDeleteClick:tap];
    }
}

- (void)showMapAlertView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(40*ScreenRatio, Screen_height - 120*ScreenRatio, kMapPopViewHeight, - kMapShowHeight);
        self.itemsView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

@end
