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
 送礼物(不处理第一次展示当前礼物逻辑)
 
 @param backView 礼物动效展示父view
 @param giftModel 礼物的数据
 @param completeBlock 展示完毕回调
 */

- (void)showGiftViewWithBackView:(UIView *)backView
                            info:(JPGiftModel *)giftModel
                   completeBlock:(completeBlock)completeBlock;

/**
 送礼物(回调第一次展示当前礼物的逻辑)

 @param backView 礼物动效展示父view
 @param giftModel 礼物的数据
 @param completeBlock 展示完毕回调
 @param completeShowGifImageBlock 第一次展示当前礼物的回调(为了显示gif)
 */
- (void)showGiftViewWithBackView:(UIView *)backView
                            info:(JPGiftModel *)giftModel
                   completeBlock:(completeBlock)completeBlock
       completeShowGifImageBlock:(completeShowGifImageBlock)completeShowGifImageBlock;

@end
