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
    
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.giftNameLabel.frame)+5, self.bounds.size.width, 14)];
    self.moneyLabel.text = @"1测测币";
    self.moneyLabel.textColor = [UIColor grayColor];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.moneyLabel];
}

- (void)setModel:(JPGiftCellModel *)model {
    
    _model = model;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@""]];
    self.giftNameLabel.text = model.name;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@测测币",model.value];
    self.bgView.backgroundColor = model.isSelected ? [UIColor orangeColor] : [UIColor clearColor];
}

@end
