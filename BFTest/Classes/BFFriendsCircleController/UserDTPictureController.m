//
//  UserDTPictureController.m
//  BFTest
//
//  Created by 伯符 on 17/2/10.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "UserDTPictureController.h"
#import "BFHotCollectionViewCell.h"
#import "BFDataGenerator.h"
#import "UserDTDetailController.h"
@interface UserDTPictureController () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation UserDTPictureController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];

    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addCollectionView];

}

- (void)addCollectionView{
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewFlowLayout.minimumLineSpacing = 1.0f;
    collectionViewFlowLayout.minimumInteritemSpacing = 1.0f;
    collectionViewFlowLayout.itemSize = CGSizeMake((Screen_width - 2)/3, (Screen_width - 2)/3);
    
    UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.view.height) collectionViewLayout:collectionViewFlowLayout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.bounces = YES;
    collectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [collectView registerClass:[BFHotCollectionViewCell class] forCellWithReuseIdentifier:@"HotCell"];
    [self.view addSubview:collectView];
    self.collectionView = collectView;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BFHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.item];
    
    cell.dic = dic;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.item];

    UserDTDetailController *vc = [[UserDTDetailController alloc]init];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
