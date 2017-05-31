//
//  CHCardItemView.m
//  CHCardView
//
//  Created by yaoxin on 16/10/8.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "CHCardItemView.h"
#import "CHCardItemModel.h" 
#import "CHCardUser.h"
@interface  CHCardItemView()

//@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) CHCardUser *imgView;

@end
@implementation CHCardItemView {
    CGPoint _originalCenter;
    CGFloat _currentAngle;
    BOOL _isLeft;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
        
        [self addPanGest];
        
        [self configLayer];
        
    }
    return self;
}

- (void)setItemModel:(CHCardItemModel *)itemModel {
    _itemModel = itemModel;
    
    self.imgView.cardModel = itemModel;
    
}

- (CHCardUser *)imgView{
    if (!_imgView) {
        _imgView = [[CHCardUser alloc]initWithFrame:self.bounds];
        [self addSubview:_imgView];
    }
    return _imgView;
}


- (void)addPanGest {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestHandle:)];
    [self addGestureRecognizer:pan];
}

- (void)configLayer { 
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
}

- (void)panGestHandle:(UIPanGestureRecognizer *)panGest {
    if (panGest.state == UIGestureRecognizerStateChanged) {
        
        CGPoint movePoint = [panGest translationInView:self];
        _isLeft = (movePoint.x < 0);
        
        self.center = CGPointMake(self.center.x + movePoint.x, self.center.y + movePoint.y);
        
        CGFloat angle = (self.center.x - self.frame.size.width / 2.0) / self.frame.size.width / 4.0;
        _currentAngle = angle;
        
        self.transform = CGAffineTransformMakeRotation(angle);
        
        [panGest setTranslation:CGPointZero inView:self];
        
    } else if (panGest.state == UIGestureRecognizerStateEnded) {
        
        CGPoint vel = [panGest velocityInView:self];
        if (vel.x > 800 || vel.x < - 800) {
            [self remove];
            return ;
        }
        if (self.frame.origin.x + self.frame.size.width > 150 && self.frame.origin.x < self.frame.size.width - 150) {
            [UIView animateWithDuration:0.5 animations:^{
                self.center = _originalCenter;
                self.transform = CGAffineTransformMakeRotation(0);
            }];
        } else {
            [self remove];
        }
    }
}

- (void)remove {
    [UIView animateWithDuration:0.3 animations:^{
        // right
        if (!_isLeft) {
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + _currentAngle * self.frame.size.height);
        } else { // left
            self.center = CGPointMake(- 1000, self.center.y - _currentAngle * self.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView:direction:match:userModel:)]) {
                [self.delegate cardItemViewDidRemoveFromSuperView:self direction:_isLeft match:self.matchView userModel:_itemModel];
            }
        }
    }];

}

- (void)removeWithLeft:(BOOL)left match:(BFMatchView *)matchview userMsg:(CHCardItemModel *)model{
    [UIView animateWithDuration:0.5 animations:^{
        
        // right
        if (!left) {
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0));
        } else { // left
            self.center = CGPointMake(- 1000, self.center.y - _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0));
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView:direction:match:userModel:)]) {
                [self.delegate cardItemViewDidRemoveFromSuperView:self direction:left match:matchview userModel:_itemModel];
            }
        }
    }];
}

@end
