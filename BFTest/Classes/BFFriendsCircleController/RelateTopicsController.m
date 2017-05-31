//
//  RelateTopicsController.m
//  BFTest
//
//  Created by 伯符 on 17/3/7.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "RelateTopicsController.h"
#import "BFHotCollectionViewCell.h"
#import "UserDTDetailController.h"
@interface RelateTopicsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,assign) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation RelateTopicsController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setLinkStr:(NSString *)linkStr{
    _linkStr = linkStr;
    self.title = [NSString stringWithFormat:@"%@",_linkStr];
    [self achieveData:linkStr];
}

- (void)achieveData:(NSString *)link{
    NSLog(@"%@",link);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/news/search/",DongTai_URL];

    NSDictionary *para;
    if (UserwordMsg && JMTOKEN) {
        para = @{@"uid":UserwordMsg,@"token":JMTOKEN,@"type":@"T",@"parm":link};
    }
    [BFNetRequest getWithURLString:urlStr parameters:para success:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dic);
        if ([dic[@"success"] intValue]) {
            
            NSMutableArray *content = dic[@"content"];
            if (content.count != 0) {
                for (NSDictionary *model in content) {
                    [self.dataArray addObject:model];
                }
            }
            if (!self.collectionView) {
                [self addCollectionView];
            }
        }
    } failure:^(NSError *error) {
        //
    }];
    
}

- (void)addCollectionView{
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewFlowLayout.minimumLineSpacing = 1.0f;
    collectionViewFlowLayout.minimumInteritemSpacing = 1.0f;
    collectionViewFlowLayout.itemSize = CGSizeMake((Screen_width - 2)/3, (Screen_width - 2)/3);
    
    UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, Screen_height) collectionViewLayout:collectionViewFlowLayout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.bounces = YES;
//    collectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [collectView registerClass:[BFHotCollectionViewCell class] forCellWithReuseIdentifier:@"HotCell"];
    [collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    [self.view addSubview:collectView];
    self.collectionView = collectView;
    [self.collectionView reloadData];
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
    if (_dataArray.count > 0) {
        NSDictionary *dic = _dataArray[indexPath.item];
        UserDTDetailController *vc = [[UserDTDetailController alloc]init];
        vc.dic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *collectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 43*ScreenRatio)];
        header.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*ScreenRatio, 0, 100*ScreenRatio, 50*ScreenRatio)];
        titleLabel.text = @"最新";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = BFFontOfSize(18);

        [header addSubview:titleLabel];
        [collectionHeader addSubview:header];
        
        return collectionHeader;
    }else{
        return nil;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_width, 43*ScreenRatio);
}

@end
