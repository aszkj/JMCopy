//
//  BFPhotoAlbumController.m
//  BFTest
//
//  Created by 伯符 on 16/7/13.
//  Copyright © 2016年 bofuco. All rights reserved.
//

#import "BFPhotoAlbumController.h"

#import "BFPhotoAlbumCell.h"
#import "BFImageCreatUtils.h"
@interface BFPhotoAlbumController ()

@end

@implementation BFPhotoAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightCancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtn:)];
    self.navigationItem.rightBarButtonItem = rightCancel;
    self.navigationItem.hidesBackButton = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)cancelBtn:(UIBarButtonItem *)item{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BFPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoAlbumCell"];
    if (!cell) {
        cell = [[BFPhotoAlbumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PhotoAlbumCell"];
    }
    cell.tag = indexPath.row;
    
    // Thumbnail
    PHAssetCollection *assetCollection = self.albumArray[indexPath.row];
    PHFetchOptions *options = [PHFetchOptions new];
    
    switch (self.mediaType) {
        case 1:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            break;
            
        case 2:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            break;
            
        default:
            break;
    }
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    PHImageManager *imgManager = [PHImageManager defaultManager];
    if (fetchResult.count >= 1) {
        [imgManager requestImageForAsset:fetchResult[fetchResult.count - 1] targetSize:CGSizeMake(80*[[UIScreen mainScreen]scale], 80*[[UIScreen mainScreen]scale]) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (cell.tag == indexPath.row) {
                cell.imageView.image = result;
            }
        }];
    }else{
        cell.imageView.image = [BFImageCreatUtils placeholderImageWithSize:CGSizeMake(60, 60)];
    }
    // Album title
    cell.photoTitle.text = assetCollection.localizedTitle;
    
    // Number of photos
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (long)fetchResult.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.collectionView.assetCollection = self.albumArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


@end
