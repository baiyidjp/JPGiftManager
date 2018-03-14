//
//  JPGiftShowView.m
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPGiftShowView.h"
#import "JPGiftModel.h"
#import "UIImageView+WebCache.h"

@interface JPGiftShowView()

@end

@implementation JPGiftShowView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //245 50
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        [self p_SetUI];
    }
    return self;
}

#pragma mark -设置UI
- (void)p_SetUI {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-30-5, 50)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.layer.cornerRadius = 25;
    [self addSubview:self.bgView];
    
    self.userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.userIconView.layer.cornerRadius = 25;
    self.userIconView.layer.backgroundColor = self.backgroundColor.CGColor;
    [self addSubview:self.userIconView];
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userIconView.frame)+5, 2.5, 100, 20)];
    self.userNameLabel.text = @"白衣哥哥";
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.userNameLabel];
    
    self.giftNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userIconView.frame)+5,CGRectGetMaxY(self.userNameLabel.frame)+5, 100, 20)];
    self.giftNameLabel.text = @"豪华游艇";
    self.giftNameLabel.textColor = [UIColor orangeColor];
    self.giftNameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.giftNameLabel];
    
    self.giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+5, 0, 50, 50)];
    [self addSubview:self.giftImageView];
    
    self.countLabel = [[JPGiftCountLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.giftImageView.frame)+5, 10, 50, 30)];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = [UIFont systemFontOfSize:20];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.text = @"";
    [self addSubview:self.countLabel];
    
}

- (void)showGiftShowViewWithModel:(JPGiftModel *)giftModel completeBlock:(completeShowViewBlock)completeBlock{
    
    self.finishModel = giftModel;
    [self.userIconView sd_setImageWithURL:[NSURL URLWithString:giftModel.userIcon] placeholderImage:[UIImage imageNamed:@""]];
    self.userNameLabel.text = giftModel.userName;
    self.giftNameLabel.text = giftModel.giftName;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.giftImage] placeholderImage:[UIImage imageNamed:@""]];
    self.hidden = NO;
    self.showViewFinishBlock = completeBlock;
    NSLog(@"当前展示的礼物--%@",giftModel.giftName);
    if (self.showViewKeyBlock) {
        self.showViewKeyBlock(giftModel.giftKey);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame =CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        self.currentGiftCount = 0;
        [self setGiftCount:giftModel.defaultCount];
        
    }];
}

- (void)hiddenGiftShowView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame =CGRectMake(-self.frame.size.width, self.frame.origin.y-50, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        if (self.showViewFinishBlock) {
            self.showViewFinishBlock(YES, self.finishModel.giftKey);
        }
        self.frame =CGRectMake(-self.frame.size.width, self.frame.origin.y+50, self.frame.size.width, self.frame.size.height);

        self.hidden = YES;
        self.currentGiftCount = 0;
        self.countLabel.text = @"";
    }];
}

- (void)setGiftCount:(NSInteger)giftCount {
    
    _giftCount = giftCount;
    self.currentGiftCount += giftCount;
    self.countLabel.text = [NSString stringWithFormat:@"x %zd",self.currentGiftCount];
    NSLog(@"累计礼物数 %zd",self.currentGiftCount);
    if (self.currentGiftCount > 1) {
        [self p_SetAnimation:self.countLabel];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenGiftShowView) object:nil];//可以取消成功。
        [self performSelector:@selector(hiddenGiftShowView) withObject:nil afterDelay:2];
        
    }else {
        [self performSelector:@selector(hiddenGiftShowView) withObject:nil afterDelay:2];
    }
}

- (void)p_SetAnimation:(UIView *)view {
    
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:1.0];
    pulse.toValue= [NSNumber numberWithFloat:1.5];
    [[view layer] addAnimation:pulse forKey:nil];
}


@end
