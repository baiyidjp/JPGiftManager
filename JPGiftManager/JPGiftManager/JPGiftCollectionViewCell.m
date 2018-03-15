//
//  JPGiftCollectionViewCell.m
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPGiftCollectionViewCell.h"
#import "JPGiftCellModel.h"
#import "UIImageView+WebCache.h"

@interface JPGiftCollectionViewCell()
/** bg */
@property(nonatomic,strong) UIView *bgView;
/** image */
@property(nonatomic,strong) UIImageView *giftImageView;
/** name */
@property(nonatomic,strong) UILabel *giftNameLabel;
/** money */
@property(nonatomic,strong) UILabel *moneyLabel;
/** moneybtn */
@property(nonatomic,strong) UIButton *moneyBtn;
@end

@implementation JPGiftCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self p_SetUI];
    }
    return self;
}

#pragma mark -设置UI
- (void)p_SetUI {
    
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.bgView];
    
    self.giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.25, 10, self.bounds.size.width*0.5, self.bounds.size.width*0.5)];
    [self.contentView addSubview:self.giftImageView];
    
    self.giftNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.giftImageView.frame)+5, self.bounds.size.width, 16)];
    self.giftNameLabel.text = @"礼物名";
    self.giftNameLabel.textColor = [UIColor whiteColor];
    self.giftNameLabel.textAlignment = NSTextAlignmentCenter;
    self.giftNameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.giftNameLabel];
        
    self.moneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.giftNameLabel.frame)+5, self.bounds.size.width, 20)];
    [self.moneyBtn setTitle:@"0" forState:UIControlStateNormal];
    [self.moneyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.moneyBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.moneyBtn];
}

- (void)setModel:(JPGiftCellModel *)model {
    
    _model = model;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@""]];
    self.giftNameLabel.text = model.name;
    self.bgView.backgroundColor = model.isSelected ? [UIColor orangeColor] : [UIColor clearColor];
    BOOL isCcb = [model.cost_type boolValue];
    [self.moneyBtn setTitle:model.value forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:isCcb ? @"Live_Red_ccb" : @"Cece_live_star_small"];
    [self.moneyBtn setImage:img forState:UIControlStateNormal];
}

@end
