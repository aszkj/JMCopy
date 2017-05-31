//
//  RBFUserOtherReportVC.m
//  BFTest
//
//  Created by JM on 2017/4/12.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "BFUserOtherReportVC.h"
#import "BFOriginNetWorkingTool+userRelations.h"

typedef NS_ENUM(NSInteger,KeyboardVisible){
    KeyboardVisibleNO = 0,
    KeyboardVisibleYES,
    KeyboardVisibleMoving
};

@interface BFUserOtherReportVC ()<UITextViewDelegate>

@property (nonatomic,assign) KeyboardVisible keyboardVisible;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong)NSIndexPath *lastIndex;
@property (nonatomic,strong)UIView *MaskView;

@end

@implementation BFUserOtherReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = nil;
    self.textView.delegate = self;
}

- (IBAction)reportButtonAction:(UIButton *)sender{
    
    NSString *reasonId = [self getCurrentReasonId];
    NSString *jmid = [BFUserLoginManager shardManager].jmId;
    [self.textView resignFirstResponder];
    if(reasonId == nil){
        [self showAlertViewTitle:@"请选择举报原因！" message:nil];
        return;
    }
    
    [BFOriginNetWorkingTool complainWithJmid:jmid complainJmid:self.model.jmid reasonId:reasonId reason:self.textView.text completionHandler:^(NSString *code, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(code.intValue == 200){
                [self showAlertViewTitle:@"谢谢" message:@"近脉生活已收到您的举报，我们将会尽快处理！" duration:1 finishCallBack:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        });
    }];
}

- (NSString *)getCurrentReasonId{
    if(self.tableView.indexPathsForSelectedRows.count < 1){
        return nil;
    }else{
        return @(self.tableView.indexPathForSelectedRow.row + 1).stringValue;
    }
}


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectedImageViewForIndexPath:self.lastIndex].hidden = YES;
    [self selectedImageViewForIndexPath:indexPath].hidden = NO;
    self.lastIndex = indexPath;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    UIView *maskView = [[UIView alloc]init];
    [self.tableView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.tableView);
        make.width.equalTo(self.tableView);
        make.bottom.equalTo(self.textView.mas_top);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollDownTableView:)];
    [maskView addGestureRecognizer:tap];
    self.MaskView = maskView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.MaskView removeFromSuperview];
    self.MaskView = nil;
}

- (void)scrollDownTableView:(NSNotification *)notification{
    CGPoint offset = self.tableView.contentOffset;
    offset.y = -64;
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.contentOffset = offset;
    } completion:^(BOOL finished) {
        
    }];
}

- (UIImageView *)selectedImageViewForIndexPath:(NSIndexPath *)indexPath{
    UIImageView *imageView = nil;
    for(UIImageView *view in [self.tableView cellForRowAtIndexPath:indexPath].contentView.subviews){
        if([view isMemberOfClass:[UIImageView class]]){
            imageView = view;
        }
    }
    return imageView;
}

@end
