//
//  UserSettingController.m
//  BFTest
//
//  Created by 伯符 on 16/10/25.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "UserSettingController.h"
#import "UserTableViewCell.h"
#import "UserImageCell.h"
#import "BFDataGenerator.h"
#import "UserNameController.h"
#import "UserEdittingController.h"
#import "RACollectionViewCell.h"
@interface UserSettingController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectPhotoDelegate>{
    UIImageView *changeImg;
    UserImageCell *imgcell;
    NSInteger itemIndex;
    NSString *selectStr;
    
}
@property (nonatomic,strong) NSArray *listArray;
@property (nonatomic,strong) NSMutableArray *imgsArray;
@property (nonatomic,assign) NSInteger selectTag;

@property (nonatomic,strong) NSMutableArray *uploadImgs;
@property (nonatomic,copy) NSString *mainImg;



@end

@implementation UserSettingController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.userList reloadData];
}

- (NSMutableArray *)uploadImgs{
    if (!_uploadImgs) {
        _uploadImgs = [NSMutableArray array];
    }
    return _uploadImgs;
}

- (NSMutableArray *)imgsArray{
    if (!_imgsArray) {
        _imgsArray = [NSMutableArray array];

    }
    return _imgsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个人资料";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self configureUI];
}

- (void)setUserItem:(BFUserInfo *)userItem{
    NSArray *msgArray = @[userItem.nikename,userItem.sex,userItem.years,userItem.signature,userItem.emotionalstate,userItem.address,userItem.industry,userItem.occupation,userItem.school,userItem.interest,userItem.liveaddress,userItem.ilikeaddress];
    self.birthday = userItem.birthday;
    
    self.dataArray = [msgArray mutableCopy];
    NSArray *imgArray = [userItem.otherbmp componentsSeparatedByString:@","];
    for (NSString *str in imgArray) {
        if (str.length > 0) {
            [self.imgsArray addObject:str];
        }
    }
    
    if (userItem.mybmp && userItem.mybmp.length > 0) {
        [self.imgsArray insertObject:userItem.mybmp atIndex:0];
        self.mainImg = userItem.mybmp;
    }
    NSLog(@"%@",self.imgsArray);

    [self.userList reloadData];
}

- (void)initData{
    self.listArray = @[@"用户名",@"性别",@"年龄",@"个性签名",@"情感状态",@"来自",@"行业",@"职业",@"学校",@"兴趣爱好",@"常出没地",@"喜欢的约会地点"];
}

- (void)configureUI{
    
    self.userList = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, Screen_width, Screen_height) style:UITableViewStylePlain];
    self.userList.delegate = self;
    self.userList.dataSource = self;
    self.userList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.userList];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 :self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserImageCell *imageCell = [[UserImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"User_Image"];
            imageCell.delegate = self;
            imageCell.NewArrayBlock = ^(NSMutableArray *imgsArray){
                self.imgsArray = imgsArray;
                self.mainImg = [self.imgsArray firstObject];
                [self.userList reloadData];
            };
            imageCell.pictures = self.imgsArray;
            [imageCell.headerView reloadData];
            return imageCell;
        }
        return 0;
    }else{
        UserTableViewCell *cell = [[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"User_Msg"];
        cell.nameLabel.text = self.listArray[indexPath.row];
        cell.detailLabel.text = self.dataArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section == 0 ? Screen_width : 39*ScreenRatio;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 39)];
        header.backgroundColor = BFColor(235, 236, 237, 1);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 6*ScreenRatio, 70*ScreenRatio, 39*ScreenRatio - 12*ScreenRatio)];
        nameLabel.text = @"基本资料";
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor lightGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        [header addSubview:nameLabel];
        return header;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 39*ScreenRatio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 9 || indexPath.row == 10 ) {
            UserNameController *namevc = [[UserNameController alloc]init];
            namevc.placeholderStr = self.dataArray[indexPath.row];
            namevc.comeFrom = self.listArray[indexPath.row];
            namevc.rowIndex = indexPath.row;
            namevc.userSettingVC = self;
            [self.navigationController pushViewController:namevc animated:YES];
        }else{
            UserEdittingController *vc = [[UserEdittingController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            vc.rowStr = self.dataArray[indexPath.row];
            vc.dataIndex = indexPath.row;
            vc.userSettingVC = self;
            UserEdittingType type;
            switch (indexPath.row) {
                case 1:
                    type = UserEdittingTypeGender;
                    break;
                case 2:
                    type = UserEdittingTypeAge;
                    break;
                case 4:
                    type = UserEdittingTypeAffectState;
                    break;
                case 5:
                    type = UserEdittingTypeFrom;
                    break;
                case 6:
                    type = UserEdittingTypeIndustry;
                    break;
                case 7:
                    type = UserEdittingTypeOccupation;
                    break;
                case 8:
                    type = UserEdittingTypeSchool;
                    break;
                case 11:
                    type = UserEdittingTypeLikeAppointAddress;
                    break;
                default:
                    break;
            }
            vc.editviewType = type;
            vc.titleStr = self.listArray[indexPath.row];
        }
    }
}

- (void)backpush:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveUserMsg:(UIButton *)save{
    /*
     NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"JM_TOKEN"];
     NSDictionary *parameters = @{@"tkname":UserwordMsg,@"tok":token,@"nikename":self.dataArray[0],@"phone":@"15919901165",@"sex":self.dataArray[1],@"years":self.dataArray[2],@"constellation":@"狮子座",@"signature":self.dataArray[3],@"emotionalstate":self.dataArray[4] ,@"occupation":self.dataArray[7],@"school":self.dataArray[8],@"interest":self.dataArray[9],@"haunt":self.dataArray[10],@"birthday":self.dataArray[2],@"phonesaver":@"0",@"industry":self.dataArray[6],@"lasttime":@"",@"loginnum":@"",@"mybmp":@"",@"address":self.dataArray[5]};
     NSLog(@"%@",parameters);
     NSString *urlstr = @"http:101.201.101.125:8000/changeUserinfo";
     */
    NSLog(@"%@ ",self.mainImg);

    if (self.mainImg) {
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"JM_TOKEN"];
        NSString *imgsPath = @"";
        NSLog(@"%@",self.imgsArray);
        [self.imgsArray removeObjectAtIndex:0];
        
        if (self.imgsArray.count > 0) {
            for (NSString *str in self.imgsArray) {
                imgsPath = [imgsPath stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
            }
        }
        if (!self.constellation) {
            self.constellation = @"";
        }
        if (!self.birthday) {
            self.birthday = @"";
        }
        NSDictionary *parameters = @{@"tkname":UserwordMsg,@"tok":token,@"nikename":self.dataArray[0],@"sex":self.dataArray[1],@"years":self.dataArray[2],@"constellation":self.constellation,@"signature":self.dataArray[3],@"emotionalstate":self.dataArray[4] ,@"occupation":self.dataArray[7],@"school":self.dataArray[8],@"interest":self.dataArray[9],@"liveaddress":self.dataArray[10],@"birthday":self.birthday,@"industry":self.dataArray[6],@"mybmp":self.mainImg,@"address":self.dataArray[5],@"otherbmp":imgsPath,@"ilikeaddress":self.dataArray[11]};
        NSLog(@"%@",parameters);

        NSString *urlstr = [NSString stringWithFormat:@"%@/changeUserinfo",ALI_BASEURL];
        [BFNetRequest postWithURLString:urlstr parameters:parameters success:^(id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic[@"s"] isEqualToString:@"t"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"saveUsermsgSuccess" object:nil];
                
                [self backpush:nil];
                NSDictionary *newdata = @{@"mybmp":self.mainImg,@"nikename":self.dataArray[0],@"signature":self.dataArray[3]};
                [[NSUserDefaults standardUserDefaults]setObject:newdata forKey:@"Mydata"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshUser" object:nil];
            }
            } failure:^(NSError *error) {
            
        }];

    }else{
    }
    
}


- (void)selectPhotoWith:(RACollectionViewCell *)collectCell atIndex:(NSInteger)indextag userImageCell:(UserImageCell *)imgCell{
    imgcell = imgCell;
    NSString *ident = [NSString stringWithFormat:@"img%ld",indextag];
    
    if (indextag == 0) {
        itemIndex = indextag;
        selectStr = collectCell.imageView.image.accessibilityIdentifier;
    }
    NSLog(@"%@ --- %ld",collectCell.imageView.image.accessibilityIdentifier,indextag);

    if (![collectCell.imageView.image.accessibilityIdentifier isEqualToString:ident] || indextag == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"从相册选择"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                
                picker.delegate = self;
                picker.allowsEditing = YES;
                //打开相册选择照片
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"删除该照片"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [imgCell.headerView performBatchUpdates:^{
                [imgCell.pictures removeObjectAtIndex:indextag];
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:indextag inSection:0];
                [imgCell.headerView deleteItemsAtIndexPaths:@[indexpath]];
            } completion:^(BOOL finished) {
                [imgCell.headerView reloadData];
            }];

            
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
        //    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"保存"style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *img = info[UIImagePickerControllerEditedImage];
        NSLog(@"%@",selectStr);
        NSString *urlStr = [NSString stringWithFormat:@"%@/upload",ALI_BASEURL];
        NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
        NSDictionary *para = @{@"tkname":UserwordMsg,@"tok":JMTOKEN};

        [BFNetRequest uploadWithURLString:urlStr parameters:para uploadParam:imgData success:^(id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic[@"s"] isEqualToString:@"t"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSArray *imgarray = dic[@"data"];
                NSDictionary *imgDic = [imgarray firstObject];
                NSString *imgStr = imgDic[@"path"];
                /*
                if (itemIndex == 0 && selectStr != nil) {
                    self.mainImg = imgStr;
                }else{
                    [self.uploadImgs addObject:imgStr];
                }
                */
                if (![selectStr isEqualToString:@"img0"] && itemIndex == 0 && selectStr != nil) {
                    // 头像大图 ，没有图片的情况
                    [imgcell.pictures insertObject:imgStr atIndex:0];
                    [imgcell.headerView reloadData];
                }else if ([selectStr isEqualToString:@"img0"] && itemIndex == 0){
//                    [imgcell.pictures replaceObjectAtIndex:itemIndex withObject:imgStr];
                    [self.imgsArray replaceObjectAtIndex:itemIndex withObject:imgStr];
                    self.mainImg = imgStr;
                    [imgcell.headerView reloadData];

                }else{
//                   [imgcell.pictures addObject:imgStr];
                    [self.imgsArray addObject:imgStr];
                    NSLog(@"%@",imgcell.pictures);
                    
                }
                [self.userList reloadData];
                
            }

        } failure:^(NSError *error) {
            //
            
        }];
        
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




@end
