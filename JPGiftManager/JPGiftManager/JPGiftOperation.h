//
//  JPGiftOperation.h  送礼物的操作
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JPGiftModel,JPGiftShowView;

typedef void(^completeOpBlock)(BOOL finished,NSString *giftKey);

@interface JPGiftOperation : NSOperation

+ (instancetype)addOperationWithView:(JPGiftShowView *)giftShowView
                              OnView:(UIView *)backView
                                Info:(JPGiftModel *)model
                       completeBlock:(completeOpBlock)completeBlock;


/** 礼物展示的父view */
@property(nonatomic,strong) UIView *backView;
/** ext */
@property(nonatomic,strong) JPGiftModel *model;
/** block */
@property(nonatomic,copy) completeOpBlock opFinishedBlock;
/** showview */
@property(nonatomic,strong) JPGiftShowView *giftShowView;

@end
