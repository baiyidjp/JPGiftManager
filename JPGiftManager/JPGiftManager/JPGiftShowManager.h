//
//  JPGiftShowManager.h  送礼物逻辑的管理
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/14.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JPGiftModel;
typedef void(^completeBlock)(BOOL finished);
typedef void(^completeShowGifImageBlock)(JPGiftModel *giftModel);

@interface JPGiftShowManager : NSObject

+ (instancetype)sharedManager;


/**
 送礼物

 @param backView 礼物需要展示的父view
 @param giftModel 礼物的数据
 @param completeBlock 回调
 */
- (void)showGiftViewWithBackView:(UIView *)backView
                            info:(JPGiftModel *)giftModel
                   completeBlock:(completeBlock)completeBlock
       completeShowGifImageBlock:(completeShowGifImageBlock)completeShowGifImageBlock;

/** showgif */
@property(nonatomic,copy)completeShowGifImageBlock completeShowGifImageBlock;

@end
