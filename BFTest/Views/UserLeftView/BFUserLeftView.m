//
//  BFUserLeftView.m
//  BFTest
//
//  Created by 伯符 on 16/6/6.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFUserLeftView.h"
@interface BFUserLeftView ()@property (nonatomic,strong) NSArray *category;

@end

@implementation BFUserLeftView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self configureUI];
        [self addGesture];
    }
    return self;
}

- (void)initData{
    NSDictionary *hidebtn = [[NSUserDefaults standardUserDefaults]objectForKey:@"HideBtn"];
    
    self.category = @[@{@"TitleName":@"会员中心",@"ImageName":@"member"},@{@"TitleName":@"我的钱包",@"ImageName":@"mywallet"},@{@"TitleName":@"我的卡包",@"ImageName":@"myticketlogo"},@{@"TitleName":@"我的设置",@"ImageName":@"settingicon"}];
    
    if ([hidebtn[@"MBCenter"]isEqualToString:@"0"] || [UserwordMsg isEqualToString:@"123456jm"]) {
        self.category = @[@{@"TitleName":@"我的卡包",@"ImageName":@"myticketlogo"},@{@"TitleName":@"我的设置",@"ImageName":@"settingicon"},@{@"TitleName":@"推荐给好友",@"ImageName":@"ShareWX"}];
    }
    
}

- (void)addGesture{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panStart:)];
    
    [self addGestureRecognizer:panGesture];
    self.userInteractionEnabled = YES;
}

- (void)configureUI{
    self.backgroundColor = BFColor(9, 9, 25, 1);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.0;
    self.layer.shadowRadius = 4;
    CGFloat width;
    width = Screen_width == 320 ? 250 : 305;
    view = [[UIImageView alloc]initWithFrame:CGRectMake(width -Screen_width, 0, Screen_width, Screen_height)];
    view.userInteractionEnabled = YES;
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.clipsToBounds = YES;
//    [view setFramesCount:20];


    UIView *maskView = [[UIView alloc]init];
    maskView.backgroundColor = [UIColor blackColor];
    
    
    maskView.alpha = 0.8;
    [view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 220*ScreenRatio)];
    upView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(iconSlected:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = upView.bounds;
    [upView addSubview:btn];
    
    _iconImageView = [UIImageView new];
    _iconImageView.frame = CGRectMake(0, 0, 55*ScreenRatio, 55*ScreenRatio);
    _iconImageView.center = CGPointMake(20 + 55*ScreenRatio/2, upView.centerY - 20*ScreenRatio);
    _iconImageView.layer.cornerRadius = 55*ScreenRatio/2;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [upView addSubview:_iconImageView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+15, CGRectGetMinY(_iconImageView.frame) + 15, 150 , 25)];
    nameLabel.textColor = BFColor(248, 248, 249, 1);
    nameLabel.font = BFFontOfSize(22);
    nameLabel.text = @"";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [upView addSubview:nameLabel];
    
    assign = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_iconImageView.frame)+5*ScreenRatio, CGRectGetMaxY(_iconImageView.frame) + 15, 150 , 25)];
    assign.textColor = BFColor(164, 167, 170, 1);
    assign.font = BFFontOfSize(13);
    assign.textAlignment = NSTextAlignmentLeft;
    [upView addSubview:assign];
    
    self.leftList = [[UITableView alloc]initWithFrame:CGRectMake(Screen_width - width, 0, self.width, Screen_height) style:UITableViewStylePlain];
    self.leftList.scrollEnabled = NO;
    self.leftList.delegate = self;
    self.leftList.dataSource = self;
    self.leftList.rowHeight = 59*ScreenRatio;
    self.leftList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:view];
    
    [view addSubview:self.leftList];
    self.leftList.tableHeaderView = upView;
    
    UIView *rootView = [UIApplication sharedApplication].keyWindow;
    back = [[UIView alloc]initWithFrame:rootView.bounds];
    back.alpha = 0.0;
    back.hidden = YES;
    back.backgroundColor = [UIColor blackColor];
    [rootView addSubview:back];
    
    [back addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)]];
    
    
}

#pragma mark - tableviewDelegate/tableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.category.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identiCell = @"userCell";
    BFSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:identiCell];
    if (!cell) {
        cell = [[BFSliderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = [self.category[indexPath.row] objectForKey:@"TitleName"];
    cell.imgView.image = [UIImage imageNamed:[self.category[indexPath.row] objectForKey:@"ImageName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
//    [UIView animateWithDuration:0.1 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self performBackAnimate];
//    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
            [self.delegate selectedIndex:indexPath.row];
        }
//    }];

    
//    [UIView animateWithDuration:0.1 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        [self performBackAnimate];
//    } completion:^(BOOL finished) {
//        if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
//                [self.delegate selectedIndex:indexPath.row];
//        }
//    }];
}


#pragma mark - 点击头像跳转

- (void)iconSlected:(UIButton *)btn{
    BFMapMainController *mapVC = (BFMapMainController *)self.vc;
    [mapVC pushtoUserController];
}

#pragma mark - detailClick
- (void)detailClick:(UIButton *)btn{
    [UIView animateWithDuration:0.1 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self performBackAnimate];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
            [self.delegate selectedIndex:9];
        }
    }];
}

#pragma mark - backTap
- (void)backTap:(UITapGestureRecognizer *)tap{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self performBackAnimate];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - showLeftView
- (void)showLeftView{
    back.hidden = NO;
    [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self performAnimate];
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark - 在本View内拖动
- (void)panStart:(UIPanGestureRecognizer *)pan{
    CGPoint transPoint = [pan translationInView:self];
    CGFloat proportion = (transPoint.x + self.width) / self.width;
    self.transform = CGAffineTransformMakeTranslation(transPoint.x + self.width, 0);
    back.alpha = 0.5 * proportion;
    self.layer.shadowOffset = CGSizeMake(4 * proportion, 0);
    self.layer.shadowOpacity = 0.5 * proportion;
    if (transPoint.x + self.width > 0.5) {
        back.hidden = NO;
    }
    if (transPoint.x + self.width > self.width && transPoint.x > 0) {
        [self performAnimate];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (transPoint.x + self.width > Screen_width/2) {
            [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                [self performAnimate];
            } completion:nil];
            
        }else{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                [self performBackAnimate];
            } completion:^(BOOL finished) {
            }];
            back.hidden = YES;
        }
    }
}


#pragma mark - 边缘拖动
- (void)showWithGesture:(UIPanGestureRecognizer *)pan{
    CGPoint transPoint = [pan translationInView:self];
    CGFloat proportion = transPoint.x / self.width;
    self.transform = CGAffineTransformMakeTranslation(transPoint.x, 0);
    back.alpha = 0.5 * proportion;
    self.layer.shadowOffset = CGSizeMake(4 * proportion, 0);
    self.layer.shadowOpacity = 0.5 * proportion;
    if (transPoint.x > 0.2 ) {
        back.hidden = NO;
    }
    if (transPoint.x > self.width) {
        [self performAnimate];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (transPoint.x > self.width/2) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
            if ([self.delegate respondsToSelector:@selector(hiddenStatusBar)]) {
                [self.delegate hiddenStatusBar];
            }
            [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                [self performAnimate];
            } completion:nil];
        }else{
            
            [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                [self performBackAnimate];
            } completion:nil];
            
            back.hidden = YES;
        }
    }
}

#pragma mark - 执行动画
- (void)performBackAnimate{
    self.transform = CGAffineTransformIdentity;
    back.alpha = 0.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.0f;
}

//修改背景 及添加高斯模糊效果
- (void)performAnimate{
    self.transform = CGAffineTransformMakeTranslation(self.width, 0);
    back.alpha = 0.5;
    NSURL *url = [NSURL URLWithString:[BFUserLoginManager shardManager].photo];
    

    if(![_iconImageView.sd_imageURL.absoluteString isEqualToString:url.absoluteString]){
        [self refreshIconImageAndBackgroundImage:url];
    }
    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
//    assign.text = manager.signature;
    assign.text = nil;
    nameLabel.text = manager.name;
    
    self.layer.shadowOffset = CGSizeMake(4, 0);
    self.layer.shadowOpacity = 0.5;
    
}

- (void)refreshIconImageAndBackgroundImage:(NSURL *)url{
    
    [_iconImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
        
        [self setbackgroundViewImageWithImage:image];
    }];
}

- (void)setbackgroundViewImageWithImage:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1currentThread ->%@",[NSThread currentThread]);
        UIImage *iconBlurImage = [self coreBlurImage:image withBlurNumber:8];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2currentThread ->%@",[NSThread currentThread]);
            view.image = iconBlurImage;
    
        });
    });
}

- (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

@end
