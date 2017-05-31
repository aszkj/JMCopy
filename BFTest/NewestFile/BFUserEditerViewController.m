//
//  BFUserEditerViewController.m
//  BFTest
//
//  Created by JM on 2017/4/8.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserEditerViewController.h"
#import "BFTextField.h"
#import "BFUserEditerTableViewAddTagVC.h"
#import "BFOriginNetWorkingTool+userInfo.h"
#import "RACollectionViewCell.h"
#import "BFIconCollectionView.h"
#import "UIImage+Addition.h"
#import "QiniuSDK.h"
#import "RACollectionViewReorderableTripletLayout.h"
#import "SDProgressView.h"
#import "BFInfoProgressView.h"

static int progressCount = 0;
static BOOL popBack = NO;

@interface BFUserEditerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource ,RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet BFTextField *nameTF;
@property (weak, nonatomic) IBOutlet BFTextField *birthdayTF;
@property (weak, nonatomic) IBOutlet BFTextField *singleTF;
@property (weak, nonatomic) IBOutlet BFTextField *signatureTF;
@property (weak, nonatomic) IBOutlet BFTextField *fromAreaTF;
@property (weak, nonatomic) IBOutlet BFTextField *industryTF;
@property (weak, nonatomic) IBOutlet BFTextField *occupationTF;
@property (weak, nonatomic) IBOutlet BFTextField *schoolTF;
@property (weak, nonatomic) IBOutlet BFTextField *datePlaceTF;
@property (weak, nonatomic) IBOutlet BFTextField *tagTF;

@property (nonatomic,strong) BFInfoProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *baseInfoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalInfoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherInfoCountLabel;

/*---- 初始化头像编辑器  -----*/
@property (weak, nonatomic) IBOutlet BFIconCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photosArray;

/*---- 初始化 家乡选择器  -----*/

@property (strong, nonatomic)  UIPickerView *homePickerView;

@property (strong,nonatomic) UIView *homePickerBackView;

@property (strong,nonatomic) UIView *homePickerTapView;

/**
 *  plist对应的字典
 */
@property (nonatomic, strong) NSDictionary* cityNames;
/**
 *  省份
 */
@property (nonatomic, strong) NSArray* provinces;
/**
 *  城市
 */
@property (nonatomic, strong) NSArray* cities;
/**
 *  选中的省份
 */
@property (nonatomic, strong) NSString* selectedProvince;

/*---- 当前选中城市下标  -----*/
@property (nonatomic,assign) NSInteger currentCityNum;
/*---- 当前选中的省份下标  -----*/
@property (nonatomic,assign) NSInteger currentProvinceNum;

@property (nonatomic,strong) NSMutableDictionary *imageCacheDicM;

@end

@implementation BFUserEditerViewController



- (void)viewDidLoad{
    self.title = @"编辑个人资料";
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.headView.height = Screen_width;
    [self setupDatePicker];
    [self setupNavgationItem];
    [self setupIconCollectionView];
    [self setupInfoProgressView];
    //重新根据model刷新一下UI
    [self setModel:self.model];
    
    //设置默认选中的省份是provinces中的第一个元素
    self.selectedProvince = self.provinces[0];
}

#pragma mark - 设置用户信息完整度的自定义View
- (void)setupInfoProgressView{
    BFInfoProgressView *progressView = [[NSBundle mainBundle]loadNibNamed:@"BFInfoProgressView" owner:self options:nil].lastObject;
    progressView.frame = CGRectMake(Screen_width-70, 100, 60, 60);
    self.progressView = progressView;
    UIView *view = self.navigationController.view;
    [view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(84);
        make.right.equalTo(view).offset(+ Screen_width);
        make.height.width.mas_equalTo(60);
    }];
    
    //添加拖拽手势到圆球
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [progressView addGestureRecognizer:pan];
}
- (void)panGestureAction:(UIPanGestureRecognizer *)sender{
    UIView *view = self.navigationController.view;
    CGPoint translation = [sender translationInView:view];
    CGPoint center = CGPointMake(sender.view.center.x + translation.x,
                                 sender.view.center.y + translation.y);
    //判断是否超出屏幕的边缘
    if([self isOutOffScreenByCenter:center]){
        [sender setTranslation:CGPointZero inView:self.view];
        return;
    }
    
    self.progressView.center = center;
    [sender setTranslation:CGPointZero inView:self.view];
}

- (BOOL)isOutOffScreenByCenter:(CGPoint)center{
    if(center.x < 30 || center.x > Screen_width - 30){
        return YES;
    }
    if(center.y < 30 + NavBar_Height || center.y > Screen_height - 30){
        return YES;
    }
    return NO;
}

#pragma mark - 设置iconCollectionView
- (void)setupIconCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.vc = self;
    [self setupPhotosArray];
    
}
- (void)setupPhotosArray
{
    _photosArray = [self.model.listUserPhotos mutableCopy];
    if(!_photosArray){
        _photosArray = [NSMutableArray array];
    }
}
-(NSMutableDictionary *)imageCacheDicM{
    //初始化图片缓存器
    if(!_imageCacheDicM){
        _imageCacheDicM = [[NSMutableDictionary alloc]init];
    }
    return _imageCacheDicM;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photosArray.count;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 1.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 1.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 1.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(1.f, 0, 1.f, 0);
}
//这里返回item的最大尺寸
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

//这里改变cell被选中之后的透明度
- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}
//当照片移动到对应下标时对图片数据源的处理
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    UIImage *image = [_photosArray objectAtIndex:fromIndexPath.item];
    [_photosArray removeObjectAtIndex:fromIndexPath.item];
    [_photosArray insertObject:image atIndex:toIndexPath.item];
}
//是否可以移动对应下标fromIndexPath的cell到toIndexPath
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}
//是否可以移动对应下标indexPath的cell
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//cell对应的数据源方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    RACollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    [cell.label removeFromSuperview];
    
    cell.imageView.frame = cell.bounds;
    
    UIImage *image = [self.imageCacheDicM valueForKey: _photosArray[indexPath.item]];
    if(image){
        cell.imageView.image = image;
        cell.progressView.hidden = NO;
    }else{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString: _photosArray[indexPath.item]]];
    }
    
    [cell.contentView addSubview:cell.label];
    return cell;
    
}

//选中对应cell时 删除图片数组中对应下标的图片  删除collectionView中对应的cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_photosArray.count == 1) {
        return;
    }
    [self deleteUserPhotoAtIndexPath:indexPath];
}
#pragma mark - imagePicker代理 上传图片到7牛
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //先将数据源数组添加一个空元素
    if(self.photosArray.count >= 6){
        [self.photosArray removeLastObject];
    }
    static int maskNum = 0;
    NSString *currentNum = @(maskNum).stringValue;
    [self.photosArray addObject:currentNum];
    maskNum++;
    [self.collectionView reloadData];
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        
        UIImage *img = info[UIImagePickerControllerEditedImage];
        [BFUserLoginManager shardManager].iconImage = img;
        //压缩图片到100KB
        NSData *compressImageData = [img compressImageDataWithMaxLimit:100];
        UIImage *blurImage = [self  coreBlurImage:img withBlurNumber:10];
        [self.imageCacheDicM setObject:blurImage forKey:currentNum];
        //需要把图片上传到七牛
        [BFOriginNetWorkingTool getUploadTokenWith:@"image" completionHandler:^(NSString *qiniuToken, NSError *error) {
            NSLog(@"%@",qiniuToken);
            //配置上传管理者
            QNConfiguration *qnConfig = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNZone zone2];
            }];
            //配置上传选项
            QNUploadOption *option = [[QNUploadOption alloc]initWithMime:nil progressHandler:^(NSString *key, float percent) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSInteger index = [self.photosArray indexOfObject:currentNum];
                    RACollectionViewCell *cell = (RACollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                    cell.progress = percent;
                    NSLog(@"青牛上传进度 ->%f",percent);
                });
            } params:nil checkCrc:NO cancellationSignal:nil];
            
            QNUploadManager *upManager = [QNUploadManager sharedInstanceWithConfiguration:qnConfig];
            [upManager putData:compressImageData key:nil token:qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    BFUserLoginManager *manager = [BFUserLoginManager shardManager];
                    NSString *imgLastComponent = resp[@"key"];
                    NSString *urlStr = [manager.qiniu_url stringByAppendingString:[NSString stringWithFormat:@"%@",imgLastComponent]];
#warning 这里添加图片的URL到图片数组
                    NSInteger index = [self.photosArray indexOfObject:currentNum];
                    [self.photosArray removeObject:currentNum];
                    [self.imageCacheDicM removeObjectForKey:currentNum];
                    [self.photosArray insertObject:urlStr atIndex:index];
                    
                    
                    [self.collectionView reloadData];
                    
                });
            } option:option];
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}


#pragma mark -设置导航条

- (void)setupNavgationItem{
    [self.navigationController.navigationItem setHidesBackButton:YES];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveEditUserInfo)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBackAction)];
}

- (void)popBackAction{
    popBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setModel:(BFUserInfoModel *)model{
    _model = model;
    self.nameTF.text = model.name;
    self.birthdayTF.text = model.birthday;
    self.singleTF.text = model.single;
    self.fromAreaTF.text = model.fromArea;
    self.industryTF.text = model.industry;
    self.occupationTF.text = model.occupation;
    self.schoolTF.text = model.school;
    self.signatureTF.text = model.signature;
    self.datePlaceTF.text = model.datePlace;
#warning 标签赋值处
        self.nameTF.text = model.name;
}

- (void)saveEditUserInfo{
    
    self.model.name = self.nameTF.text;
    self.model.birthday = self.birthdayTF.text;
    self.model.single = self.singleTF.text;
    self.model.fromArea = self.fromAreaTF.text;
    self.model.industry = self.industryTF.text;
    self.model.occupation = self.occupationTF.text;
    self.model.school = self.schoolTF.text;
    self.model.signature = self.signatureTF.text;
    self.model.datePlace = self.datePlaceTF.text;
    self.model.listUserPhotos = self.photosArray;
    self.model.photo = self.photosArray.firstObject;
#warning 这里后期标签功能上传完善处
    //        self.model.tagLabelStrArr = self.tagTF.text;
    
    [BFOriginNetWorkingTool updateUserInfoByUserInfoModel:self.model completionHandler:^(NSString *code, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(code.intValue == 200){
//                [self showAlertViewTitle:@"用户信息保存成功！" message:nil];
                [self popBackAction];
            }else{
                [self showAlertViewTitle:@"用户信息保存失败！" message:error.description];
            }
        });
    }];
}

#pragma mark - 删除头像
- (void)deleteUserPhotoAtIndexPath:(NSIndexPath *)indexPath {
    // 初始化 添加 提示内容
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 添加 AlertAction 事件回调（三种类型：默认，取消，警告）
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除该照片" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除用户头像");
        [self.collectionView performBatchUpdates:^{
            [_photosArray removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消用户头像");
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    // 出现
    [self presentViewController:alertController animated:YES completion:^{
        NSLog(@"presented");
    }];
    
}


#pragma mark - 初始化选择器
- (void)setupDatePicker{
    
    UIPickerView *homePickerView = [[UIPickerView alloc]init];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_height +10 + NavBar_Height, Screen_width, 240)];
    
    UIView *homePickerTapView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    
    self.homePickerTapView = homePickerTapView;
    self.homePickerView = homePickerView;
    self.homePickerBackView = backView;
    
    
    [self.view addSubview:homePickerTapView];
    [self.view addSubview:backView];
    [backView addSubview:homePickerView];
    
    
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePickerView)];
    [homePickerTapView addGestureRecognizer:tap];
    
    
    [homePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backView);
    }];
    
    [homePickerTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.bottom.equalTo(self.homePickerBackView.mas_top);
    }];
    
    homePickerView.delegate = self;
    homePickerView.dataSource = self;
    backView.hidden = YES;
    
}
- (void)hidePickerView{
    [self setHomePickerViewHiden:YES];
}

-(BFTextField *)textFieldForIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    BFTextField *textField;
    for(BFTextField *tf in cell.contentView.subviews){
        textField = tf;
    }
    return textField;
}

- (void)refreshFromAreaTF{
    NSString *city = self.cities[self.currentCityNum];
    NSString *province = self.provinces[self.currentProvinceNum];
    
    if(city && province && !self.homePickerBackView.hidden){
        NSString *str = [NSString stringWithFormat:@"%@-%@",province,city];
        if([str containsString:@"无"]){
            self.fromAreaTF.text = nil;
            return;
        }
        self.fromAreaTF.text  = str;
    }
}

#pragma  mark - tableView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self refreshFromAreaTF];
    [self setHomePickerViewHiden:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self refreshProgress];
    NSLog(@"被选中cell对应的下标是 ->%@",indexPath);
    if(indexPath.row == 0)
        return;
    
    NSIndexPath *(^callBack)(NSString *) = ^(NSString *str){
        [self textFieldForIndexPath:indexPath].text = str;
        [self refreshProgress];
        return indexPath;
    };
    
    NSString *tableViewID = @"jumpToUserEditerTabelAddTagVC";
    NSString *defineViewID = @"BFUserInfoSelfDefinedVC";
    NSString *birthdayViewID = @"BFUserInfoBirthdayEditVC";
    NSString *schoolViewID = @"BFUserEditerSchoolVC";
    NSString *identifier = nil;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 1:
                    identifier = defineViewID;
                    break;
                case 2:
                    identifier = birthdayViewID;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 1:
                    identifier = tableViewID;
                    break;
                case 2:
                    identifier = defineViewID;
                    break;
                case 3://对应点击编辑家乡的cell
                {
                    //判断当前是否已经是选择家乡界面
                    if(self.homePickerBackView.hidden){
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self setHomePickerViewHiden:NO];
                        });
                    }
                    return ;
                }
                    break;
                case 4:
                    identifier = tableViewID;
                    break;
                case 5:
                    identifier = tableViewID;
                    break;
                case 6:
                    identifier = schoolViewID;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 1:
                    identifier = tableViewID;
                    break;
                case 2:
                    identifier = tableViewID;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    if(identifier){
        [self performSegueWithIdentifier:identifier sender:callBack];
    }
}
#pragma mark - 跳转的准备工作
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc = segue.destinationViewController;
    [vc setValue:sender forKey:@"callBack"];
    [vc setValue:self.model forKey:@"model"];
}



#pragma mark -refreshProgress
- (void)refreshProgress{
    //刷新百分比
//    int i = ([self.nameTF.text isEqualToString: @""] ? 0:1)  + ([self.birthdayTF.text isEqualToString: @""]  ? 0:1)  + ([self.schoolTF.text isEqualToString: @""]  ? 0:1) + ([self.singleTF.text isEqualToString: @""] ? 0:1) + ([self.signatureTF.text isEqualToString: @""]  ? 0:1) + ([self.fromAreaTF.text isEqualToString: @""]  ? 0:1) + ([self.industryTF.text isEqualToString: @""]  ? 0:1) +([self.occupationTF.text isEqualToString: @""]  ? 0:1) +([self.datePlaceTF.text isEqualToString: @""] ? 0:1) +([self.tagTF.text isEqualToString: @""]  ? 0:1) ;//包含标签 需要将stroyboard中标签cell Hiden属性设置为NO
    
    int i = ([self.nameTF.text isEqualToString: @""] ? 0:1)  + ([self.birthdayTF.text isEqualToString: @""]  ? 0:1)  + ([self.schoolTF.text isEqualToString: @""]  ? 0:1) + ([self.singleTF.text isEqualToString: @""] ? 0:1) + ([self.signatureTF.text isEqualToString: @""]  ? 0:1) + ([self.fromAreaTF.text isEqualToString: @""]  ? 0:1) + ([self.industryTF.text isEqualToString: @""]  ? 0:1) +([self.occupationTF.text isEqualToString: @""]  ? 0:1) +([self.datePlaceTF.text isEqualToString: @""] ? 0:1) ;//不包含标签

    
    
    NSString *progressStr;
    if(i == 0){
        progressStr = [NSString stringWithFormat:@"%2zd%%",(i/9.0)*100];
    }else{
        progressStr = [NSString stringWithFormat:@"%zd%%",(int)((i/9.0)*100)];
    }
    NSLog(@"thread ----- %@",[NSThread currentThread]);
    
//    self.progressView.progress = i/10.0;//包含标签
    self.progressView.progress = i/9.0;//不包含标签
    
    //刷新对应信息的个数条目
    int baseInfoCount = ([self.nameTF.text isEqualToString: @""] ? 0:1)  + ([self.birthdayTF.text isEqualToString: @""]  ? 0:1) ;
    int personalInfoCount = ([self.schoolTF.text isEqualToString: @""]  ? 0:1) + ([self.singleTF.text isEqualToString: @""] ? 0:1) + ([self.signatureTF.text isEqualToString: @""]  ? 0:1) + ([self.fromAreaTF.text isEqualToString: @""]  ? 0:1) + ([self.industryTF.text isEqualToString: @""]  ? 0:1) +([self.occupationTF.text isEqualToString: @""]  ? 0:1) ;
    int otherInfoCount = ([self.datePlaceTF.text isEqualToString: @""] ? 0:1) +([self.tagTF.text isEqualToString: @""]  ? 0:1) ;
    self.baseInfoCountLabel.text = @(baseInfoCount).stringValue;
    self.personalInfoCountLabel.text = @(personalInfoCount).stringValue;
    self.otherInfoCountLabel.text = @(otherInfoCount).stringValue;
}

#pragma mark - 生命周期的方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.nameTF.text = @"hahah";
    [self refreshProgress];
}


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshProgress];
        if(progressCount++ > 0){
            //平移渐现的效果 继续push控制器 动画右移
            [UIView animateWithDuration:0.1 animations:^{
                CGPoint center = self.progressView.center;
                self.progressView.center = CGPointMake(center.x + Screen_width, center.y);
                self.progressView.alpha = 1;
            }];
        }else{
            //第一次将要显示的位置 第一次push控制器 动画左移
            //平移渐现的效果
            [UIView animateWithDuration:0.25 animations:^{
                CGPoint center = self.progressView.center;
                self.progressView.center = CGPointMake(center.x - Screen_width , center.y);
                self.progressView.alpha = 1;
            }];
        }
        
    });
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    if(popBack){
        //平移渐隐的动画效果 pop控制器 动画右移
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint center = self.progressView.center;
            self.progressView.center = CGPointMake(center.x + Screen_width, center.y);
            self.progressView.alpha = 0;
        }];
    }else{
        //平移渐隐的动画效果 push控制器 动画左移
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint center = self.progressView.center;
            self.progressView.center = CGPointMake(center.x - Screen_width, center.y);
            self.progressView.alpha = 0;
        }];
    }
}
- (void)dealloc{
    //progress位置静态变量计数归0
    progressCount = 0;
    popBack = NO;
    [self.progressView removeFromSuperview];
}


#pragma mark - 家乡的地址选择器相关方法

- (void)setHomePickerViewHiden:(BOOL)trueOrFalse{
    for(UIView *view in self.homePickerTapView.subviews){
        if(view.height < 2){
            [view removeFromSuperview];
        }
    }
    self.homePickerBackView.hidden = trueOrFalse;
    self.homePickerView.hidden = trueOrFalse;
    self.homePickerTapView.hidden = trueOrFalse;
    [self refreshProgress];
}




- (NSDictionary*)cityNames
{
    if (_cityNames == nil) {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
        
        _cityNames = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return _cityNames;
}

/**
 *  懒加载省份
 *
 *  @return 省份对应的数组
 */
- (NSArray*)provinces
{
    if (_provinces == nil) {
        
        //将省份保存到数组中  但是字典保存的是无序的 所以读出来的省份也是无序的
        _provinces = @[@"无",
                       @"安徽",
                       @"福建",
                       @"甘肃",
                       @"广东",
                       @"贵州",
                       @"海南",
                       @"河北",
                       @"河南",
                       @"黑龙江",
                       @"湖北",
                       @"湖南",
                       @"吉林",
                       @"江苏",
                       @"江西",
                       @"辽宁",
                       @"青海",
                       @"山东",
                       @"山西",
                       @"陕西",
                       @"四川",
                       @"台湾",
                       @"云南",
                       @"浙江"
                       ];
    }
    
    return _provinces;
}

/**
 *  返回每一列的行数
 *
 *  @param pickerView
 *  @param component
 *
 *  @return
 */
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        return self.provinces.count;
    }
    else {
        
        self.cities = [self.cityNames valueForKey:self.selectedProvince];
        
        return self.cities.count;
    }
}

/**
 *  返回每一行显示的文本
 *
 *  @param pickerView
 *  @param row
 *  @param component
 *
 *  @return
 */
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //第一列返回所有的省份
    if (component == 0) {
        return self.provinces[row];
    }
    else {
        
        self.cities = [self.cityNames valueForKey:self.selectedProvince];
        
        return self.cities[row];
    }
}


/**
 *  一共多少咧
 *
 *  @param pickerView
 *
 *  @return
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}

/**
 *  选中某一行后回调 联动的关键
 *
 *  @param pickerView
 *  @param row        用户选择的省份
 *  @param component
 */
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    //标记当前选中的下标
    if (component == 0){
        (self.currentProvinceNum = row);
        (self.currentCityNum = 0);
    }else{
        (self.currentCityNum = row);
    }
    
    if (component == 0) {
        
        //选中的省份
        self.selectedProvince = self.provinces[row];
        //重新加载第二列的数据
        [pickerView reloadComponent:1];
        //让第二列归位
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    [self refreshFromAreaTF];
}

//高斯模糊
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


