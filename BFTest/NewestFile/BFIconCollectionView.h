//
//  BFIconCollectionView.h
//  RACollectionViewReorderableTripletLayout-Demo
//
//  Created by JM on 2017/4/14.
//  Copyright © 2017年 Ryo Aoyama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFIconCollectionView : UICollectionView
@property (nonatomic,weak)UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>*vc;
@end
