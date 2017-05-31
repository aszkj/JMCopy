//
//  BFIconCollectionView.m
//  RACollectionViewReorderableTripletLayout-Demo
//
//  Created by JM on 2017/4/14.
//  Copyright © 2017年 Ryo Aoyama. All rights reserved.
//

#import "BFIconCollectionView.h"

@interface BFIconCollectionView()

@property (nonatomic,strong)NSMutableArray <UIButton *>*addMoreButtonArrM;

@end

@implementation BFIconCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        [self setupAddMoreButtonArrM];
    }
    return self;
}
- (NSMutableArray<UIButton *> *)addMoreButtonArrM{
    if(_addMoreButtonArrM == nil){
        _addMoreButtonArrM = [NSMutableArray array];
    }
    return _addMoreButtonArrM;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupAddMoreButtonArrM];
    });
}

- (void)setupAddMoreButtonArrM{
    
    self.backgroundColor = [UIColor whiteColor];
    for(int i = 0 ; i <5 ;i++){
        
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"chat_bar_more_normal"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectMorePicture:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:button atIndex:0];
        button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        button.hidden = NO;
        [self.addMoreButtonArrM addObject:button];;
        [self setFrameForAddMoreButtonByIndex:i];
    }
    
}

- (void)reloadData{
    [super reloadData];
    [self refreshAddPictureButtonPosition];
    
}

- (void)setFrameForAddMoreButtonByIndex:(NSInteger )index{
    NSInteger dataSourceCount = index+1;
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfY = self.frame.origin.y;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 1/3.f*selfWidth;
    CGFloat height = 1/3.f*selfWidth;
    CGFloat edage = 0.5;
    switch (dataSourceCount) {
        case 0:
            x = 0;
            y = 0 + selfY;
            break;
            
        case 1:
            x = 2/3.f*selfWidth + 2*edage;
            y = 0 +selfY + 2*edage;
            break;
        case 2:
            x = 2/3.f*selfWidth + 2*edage;
            y = 1/3.f*selfWidth + selfY + 3*edage;
            break;
        case 3:
            x = 2/3.f*selfWidth + 2*edage;
            y = 2/3.f*selfWidth+selfY +  4*edage;
            break;
        case 4:
            x = 1/3.f*selfWidth + edage;
            y = 2/3.f*selfWidth+selfY + 4*edage;
            break;
        case 5:
            x = 0;
            y = 2/3.f*selfWidth+selfY + 4*edage;
            break;
        case 6:
            x = -selfWidth;
            y = selfWidth+selfY;
            break;
            
        default:
            x = -selfWidth;
            y = selfWidth+selfY;
            break;
    }
           CGRect rect = CGRectMake(x, y, width-1, height-1);
        
        self.addMoreButtonArrM[index].frame = rect;

}

- (void)refreshAddPictureButtonPosition{
    
    
    NSInteger dataSourceCount = [self.dataSource collectionView:self numberOfItemsInSection:0];
    
    for(UIButton *addBtn in self.addMoreButtonArrM){
        addBtn.hidden = YES;
    }
    
    for (int i = 4 ; i >= dataSourceCount-1 ; i--){
        self.addMoreButtonArrM[i].hidden = NO;
    }
//
//    CGFloat selfWidth = self.frame.size.width;
//    CGFloat selfY = self.frame.origin.y;
//    CGFloat x = 0;
//    CGFloat y = 0;
//    CGFloat width = 1/3.f*selfWidth;
//    CGFloat height = 1/3.f*selfWidth;
//    CGFloat edage = 2.5;
//    switch (dataSourceCount) {
//        case 0:
//            x = 0;
//            y = 0 + selfY;
//            break;
//            
//        case 1:
//            x = 2/3.f*selfWidth + 2*edage;
//            y = 0 +selfY + 2*edage;
//            break;
//        case 2:
//            x = 2/3.f*selfWidth + 1*edage;
//            y = 1/3.f*selfWidth + selfY + 2*edage;
//            break;
//        case 3:
//            x = 2/3.f*selfWidth + 1*edage;
//            y = 2/3.f*selfWidth+selfY +  4*edage;
//            break;
//        case 4:
//            x = 1/3.f*selfWidth + edage;
//            y = 2/3.f*selfWidth+selfY + 4*edage;
//            break;
//        case 5:
//            x = 0;
//            y = 2/3.f*selfWidth+selfY + 4*edage;
//            break;
//        case 6:
//            x = -selfWidth;
//            y = selfWidth+selfY;
//            break;
//            
//        default:
//            x = -selfWidth;
//            y = selfWidth+selfY;
//            break;
//    }
//    [UIView animateWithDuration:0.15 animations:^{
//        CGRect rect = CGRectMake(x, y, width-5, height-5);
//        
//        self.addMoreButton.frame = rect;
//    }];
}

- (void)selectMorePicture:(UIButton *)btn{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self.vc;
        picker.allowsEditing = YES;
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.vc presentViewController:picker animated:YES completion:nil];
    }
}


@end
