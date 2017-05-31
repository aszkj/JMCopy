//
//  BFPhotoPicker.m
//  BFTest
//
//  Created by 伯符 on 16/7/7.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFPhotoPicker.h"
#import <Photos/Photos.h>

#import "BFScrollSelctView.h"
#import "BFButtonView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BFPhotoPicker ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *backScrol;
@property (nonatomic,strong) UIView *bottomBack;
@property (nonatomic,strong) BFButtonView *photoSelctBtn;
@property (nonatomic,strong) BFButtonView *cameraButton;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) NSMutableArray *imgArray;
@property (nonatomic,strong) NSMutableArray *imgviewArray;

@end

@implementation BFPhotoPicker

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];

        
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"yellowColor"] forState:UIControlStateNormal];

        _sendButton.layer.cornerRadius = 5;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendMesg:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.titleLabel.font = BFFontOfSize(13);
        _sendButton.enabled = NO;
    }
    return _sendButton;
}

- (NSMutableArray *)imgviewArray{
    if (!_imgviewArray) {
        _imgviewArray = [NSMutableArray array];
    }
    return _imgviewArray;
}

- (NSMutableArray *)imgArray{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (UIScrollView *)backScrol{
    if (!_backScrol) {
        _backScrol = [[UIScrollView alloc]init];
//        _backScrol.delegate = self;
        _backScrol.scrollEnabled = YES;
        _backScrol.showsHorizontalScrollIndicator = NO;
        _backScrol.showsVerticalScrollIndicator = NO;
        _backScrol.backgroundColor = [UIColor grayColor];

    }
    return _backScrol;
}

- (UIView *)bottomBack{
    if (!_bottomBack) {
        _bottomBack = [[UIView alloc]init];
        _bottomBack.backgroundColor = BFColor(29, 29, 29, 1);
    }
    return _bottomBack;
}

//- (UIButton *)photoSelctBtn{
//    if (!_photoSelctBtn) {
//        _photoSelctBtn = [[UIButton alloc]init];
//        [_photoSelctBtn setTitle:@"相册" forState:UIControlStateNormal];
//        [_photoSelctBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [_photoSelctBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
//        _photoSelctBtn.titleLabel.font = BFFontOfSize(13);
//    }
//    return _photoSelctBtn;
//}

- (void)selectPhoto:(UIButton *)btn{
    NSLog(@"selectPhoto");
    // 跳转到选择相片界面
}

- (void)takePicture:(UIButton *)btn{
    NSLog(@"takePicture");
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self getPhotos];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.backScrol];
    [self configureScroll];
    [self addSubview:self.bottomBack];
    [self.bottomBack addSubview:self.sendButton];
}

#pragma mark - 添加 相册、拍照

- (void)configureScroll{
    
    CGFloat scrHeight = self.height - 35*ScreenRatio;

    _photoSelctBtn = [[BFButtonView alloc]initViewImage:@"picture" imgframe:CGRectMake(0, 0, scrHeight/2, scrHeight/2 - 0.5) text:@"相片"];
    _photoSelctBtn.btnViewType = BFButtonViewTypePhoto;
    [self.backScrol addSubview:_photoSelctBtn];
    
    _cameraButton = [[BFButtonView alloc]initViewImage:@"camera" imgframe:CGRectMake(0, scrHeight/2 + 0.5, scrHeight/2, scrHeight/2 - 0.5) text:@"拍照"];
    _cameraButton.btnViewType = BFButtonViewTypeCamera;
    [self.backScrol addSubview:_cameraButton];
}

- (void)getPhotos{

    if ([self isCanUsePhotos]) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *photoCollections = [PHAsset fetchAssetsWithOptions:options];
        PHImageRequestOptions *imgoption = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        imgoption.synchronous = YES;
        NSInteger maxNum = photoCollections.count > 20 ? 20 : photoCollections.count;
        float __block sumWidth = 0;
        if (maxNum != 0) {
            [self setupUI];
            for (NSInteger i = 0; i < maxNum; i++) {
                // 获取一个资源（PHAsset）
                PHAsset *asset = photoCollections[photoCollections.count - i - 1];
                
                CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                float ratio = size.width / size.height;
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:imgoption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (result != nil) {
                        float photoHeight = self.height - 35*ScreenRatio;
                        float photoWidth = (self.height - 35*ScreenRatio)*ratio;
                        BFScrollSelctView *imgvc = [[BFScrollSelctView alloc]initWithFrame:CGRectMake((self.height - 35*ScreenRatio)/2 + sumWidth, 0, photoWidth, photoHeight)];
                        imgvc.image = result;
                            __weak BFPhotoPicker *weakSelf = self;
                        [imgvc selectedImg:^(UIImage *image) {
                            
                            [weakSelf sendPicture:image selected:imgvc.imgSelected imageView:imgvc];
                            NSLog(@"imageArr.count -> %zd",weakSelf.imgArray.count);
                            if(weakSelf.imgArray.count > 8){
                                [weakSelf.imgArray removeLastObject];
                                [weakSelf.imgviewArray removeLastObject];
                                UIViewController *vc = (UIViewController *)weakSelf.nextResponder.nextResponder;
                                [vc showAlertViewTitle:@"一次最多选择八张图片！" message:nil];
                                return NO;
                            }
                            if(weakSelf.imgArray.count == 0){
                                weakSelf.sendButton.enabled = NO;
                            }else{
                                weakSelf.sendButton.enabled = YES;
                            }
                            return YES;
                        }];
                        [self.backScrol addSubview:imgvc];
                        sumWidth += photoWidth + 2*ScreenRatio;
                    }
                }];
                [self.backScrol setContentSize:CGSizeMake(sumWidth + (self.height - 35*ScreenRatio)/2,self.height - 35*ScreenRatio)];
            }
        }else{
            UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
            label.text = @"暂无相片";
            label.textColor = [UIColor grayColor];
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }
    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.text = @"请到设置中心打开相册访问权限";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    
    
}

- (BOOL)isCanUsePhotos {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    return YES;
}

- (void)sendPicture:(UIImage *)img selected :(BOOL)isSelected imageView:(BFScrollSelctView *)imgView{
    // 发送底部滑动图片 （需要图片接口）
    NSLog(@"---- img :%@ ----- isSelected :%d",img,isSelected);
    if (isSelected) {
        [self.imgArray addObject:img];
        [self.imgviewArray addObject:imgView];
    }else{
        [self.imgArray removeObject:img];
        [self.imgviewArray removeObject:imgView];
    }
}

#pragma mark - Scrollview Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
}


#pragma mark - 发送图片
- (void)sendMesg:(UIButton *)btn{
    // 发送图片
    if ([self.delegate respondsToSelector:@selector(sendPicture:)]) {
        [self.delegate sendPicture:self.imgArray];
        [self.imgArray removeAllObjects];
    }
    for (BFScrollSelctView *imgView in self.imgviewArray) {
        imgView.imgSelected = NO;
    }
    [self.imgviewArray removeAllObjects];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat scrHeight = self.height - 35*ScreenRatio;
    self.backScrol.frame = CGRectMake(0, 0, Screen_width, scrHeight);
    self.bottomBack.frame = CGRectMake(0, scrHeight, Screen_width, 35*ScreenRatio);
    self.sendButton.frame = CGRectMake(Screen_width - 60*ScreenRatio, 5*ScreenRatio, 50*ScreenRatio, 25*ScreenRatio);
    
}

@end
