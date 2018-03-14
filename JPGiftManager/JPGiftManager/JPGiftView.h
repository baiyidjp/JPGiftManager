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

- (void)giftViewDisSendGiftInView:(JPGiftView *)giftView data:(JPGiftCellModel *)model;

@end


@interface JPGiftView : UIView

/** data */
@property(nonatomic,strong) NSArray *dataArray;

- (void)showGiftView;

- (void)hiddenGiftView;

@property(nonatomic,weak)id<JPGiftViewDelegate> delegate;

@end
