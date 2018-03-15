//
//  JPGiftView.h  礼物选择页面
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPGiftView,JPGiftCellModel;
@protocol JPGiftViewDelegate <NSObject>

/**
 赠送礼物

 @param giftView 礼物的选择的view
 @param model 礼物展示的数据
 */
- (void)giftViewSendGiftInView:(JPGiftView *)giftView data:(JPGiftCellModel *)model;

/**
 充值

 @param giftView view
 */
- (void)giftViewGetMoneyInView:(JPGiftView *)giftView;
@end


@interface JPGiftView : UIView

/** data */
@property(nonatomic,strong) NSArray *dataArray;

- (void)showGiftView;

- (void)hiddenGiftView;

@property(nonatomic,weak)id<JPGiftViewDelegate> delegate;

@end
