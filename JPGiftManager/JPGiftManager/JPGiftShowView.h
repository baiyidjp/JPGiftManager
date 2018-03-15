//
//  JPGiftShowView.h  礼物的展示view
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPGiftCountLabel.h"

@class JPGiftModel;
typedef void(^completeShowViewBlock)(BOOL finished,NSString *giftKey);

typedef void(^completeShowViewKeyBlock)(JPGiftModel *giftModel);

@interface JPGiftShowView : UIView

/**
 展示礼物动效

 @param giftModel 礼物的数据
 @param completeBlock 展示完毕回调
 */
- (void)showGiftShowViewWithModel:(JPGiftModel *)giftModel
                    completeBlock:(completeShowViewBlock)completeBlock;

/**
 隐藏礼物
 */
- (void)hiddenGiftShowView;

/** 背景 */
@property(nonatomic,strong) UIView *bgView;
/** icon */
@property(nonatomic,strong) UIImageView *userIconView;
/** name */
@property(nonatomic,strong) UILabel *userNameLabel;
/** giftName */
@property(nonatomic,strong) UILabel *giftNameLabel;
/** giftImage */
@property(nonatomic,strong) UIImageView *giftImageView;
/** count */
@property(nonatomic,strong) JPGiftCountLabel *countLabel;
/** 礼物数 */
@property(nonatomic,assign) NSInteger giftCount;
/** 当前礼物总数 */
@property(nonatomic,assign) NSInteger currentGiftCount;
/** block */
@property(nonatomic,copy)completeShowViewBlock showViewFinishBlock;
/** 返回当前礼物的唯一key */
@property(nonatomic,copy)completeShowViewKeyBlock showViewKeyBlock;
/** model */
@property(nonatomic,strong) JPGiftModel *finishModel;


@end
