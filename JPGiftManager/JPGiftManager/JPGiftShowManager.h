//
//  JPGiftShowManager.h  送礼物逻辑的管理
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/14.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^completeBlock)(BOOL finished);

@class JPGiftModel;
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
                   completeBlock:(completeBlock)completeBlock;

/// 取消上一次的动画操作
- (void)cancelOperationWithLastInfo:(JPGiftModel *)giftModel;

@end
