//
//  UserImageCell.m
//  BFTest
//
//  Created by 伯符 on 16/10/24.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserImageCell.h"
#import "RACollectionViewCell.h"
#import "BFDataGenerator.h"
@interface UserImageCell ()

@end

@implementation UserImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        RACollectionViewReorderableTripletLayout *flowLayout = [[RACollectionViewReorderableTripletLayout alloc]init];
        self.headerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_width) collectionViewLayout:flowLayout];

        [self.headerView registerClass:[RACollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        self.headerView.scrollEnabled = NO;
        self.headerView.backgroundColor = [UIColor clearColor];
        self.headerView.delegate = self;
        self.headerView.dataSource = self;
        self.contentView.userInteractionEnabled = YES;
        UIEdgeInsets inset = UIEdgeInsetsMake(2.f, 0, 2.f, 0);
        CGFloat largeCellSideLength = (2.f * (self.headerView.width - inset.left - inset.right) - 2) / 3.f;
        CGFloat smallCellSideLength = (largeCellSideLength - 2) / 2.f;

        CGFloat rightSideSmallCellOriginX = self.headerView.width - smallCellSideLength - inset.right;
        
        for (int i = 0; i < 2; i ++ ) {
            UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(rightSideSmallCellOriginX, 2 + (2 + smallCellSideLength)*i, smallCellSideLength, smallCellSideLength)];
            img1.image = [UIImage imageNamed:@"addback"];
            img1.contentMode = UIViewContentModeScaleToFill;
            [self addSubview:img1];
        }
        
        for (int i = 0; i < 3; i ++ ) {
            UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake((smallCellSideLength + 2)*i, largeCellSideLength + 4, smallCellSideLength, smallCellSideLength)];
            img1.image = [UIImage imageNamed:@"addback"];
            img1.contentMode = UIViewContentModeScaleToFill;
            [self addSubview:img1];
        }

        [self addSubview:self.headerView];

    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _pictures.count;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 2.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 2.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 2.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(2.f, 0, 2.f, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{

    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"%@",_pictures);
        [_pictures exchangeObjectAtIndex:fromIndexPath.item withObjectAtIndex:toIndexPath.item];
        if (self.NewArrayBlock) {
            NSLog(@"%@",_pictures);
            
            self.NewArrayBlock(_pictures);
        }
    
    /*
    UIImage *image = [_pictures objectAtIndex:fromIndexPath.item];
    [_pictures removeObjectAtIndex:fromIndexPath.item];
    [_pictures insertObject:image atIndex:toIndexPath.item];
     */
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    RACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

//    cell.imageView.image = _pictures[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_pictures[indexPath.item]]];
    
    NSString *ident = [NSString stringWithFormat:@"img%ld",indexPath.item];
    [cell.imageView.image setAccessibilityIdentifier:ident];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)collectionView:(UICollectionView *)collectionView selectItemAtIndexPath:(NSIndexPath *)indexPath{
    RACollectionViewCell *cell = (RACollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(selectPhotoWith:atIndex:userImageCell:)]) {
        [self.delegate selectPhotoWith:cell atIndex:indexPath.item userImageCell:self];
    }
}

- (void)setPictures:(NSMutableArray *)pictures{
    _pictures = pictures;
    [self.headerView reloadData];
    
}


@end
