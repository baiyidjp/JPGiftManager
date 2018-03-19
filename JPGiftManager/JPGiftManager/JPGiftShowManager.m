//
//  JPGiftShowManager.m
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/14.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPGiftShowManager.h"
#import "JPGiftShowView.h"
#import "JPGiftOperation.h"
#import "JPGiftModel.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define Nav_Bar_HEIGHT (iPhoneX ? 88.f : 64.f)
// 导航+状态
#define Nav_Status_Height (STATUS_BAR_HEIGHT+Nav_Bar_HEIGHT)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
//距离底部的间距
#define Bottom_Margin(margin) ((margin)+HOME_INDICATOR_HEIGHT)


static const NSInteger giftMaxNum = 99;

@interface JPGiftShowManager()

/** 队列 */
@property(nonatomic,strong) NSOperationQueue *giftQueue;
/** showgift */
@property(nonatomic,strong) JPGiftShowView *giftShowView;
/** 操作缓存 */
@property (nonatomic,strong) NSCache *operationCache;

@property(nonatomic,copy) completeBlock finishedBlock;
/** 当前礼物的key */
@property(nonatomic,strong) NSString *curentGiftKey;
@end

@implementation JPGiftShowManager

- (NSOperationQueue *)giftQueue{
    
    if (!_giftQueue) {
        
        _giftQueue = [[NSOperationQueue alloc] init];
        _giftQueue.maxConcurrentOperationCount = 1;
    }
    return _giftQueue;
}

- (JPGiftShowView *)giftShowView{
    
    if (!_giftShowView) {
        CGFloat itemW = SCREEN_WIDTH/4.0;
        CGFloat itemH = itemW*105/93.8;
        
        __weak typeof(self) weakSelf = self;
        CGFloat showViewW = 10+showGiftView_UserIcon_LT+showGiftView_UserIcon_WH+showGiftView_UserName_L+showGiftView_UserName_W+showGiftView_GiftIcon_W+showGiftView_XNum_L+showGiftView_XNum_W;
        _giftShowView = [[JPGiftShowView alloc] initWithFrame:CGRectMake(-showViewW, SCREEN_HEIGHT-Bottom_Margin(44)-2*itemH-showGiftView_GiftIcon_H-10-15, showViewW, showGiftView_GiftIcon_H)];
        [_giftShowView setShowViewKeyBlock:^(JPGiftModel *giftModel) {
            _curentGiftKey = giftModel.giftKey;
            if (weakSelf.completeShowGifImageBlock) {
                weakSelf.completeShowGifImageBlock(giftModel);
            }
        }];
    }
    return _giftShowView;
}

- (NSCache *)operationCache
{
    if (_operationCache==nil) {
        _operationCache = [[NSCache alloc] init];
    }
    return _operationCache;
}

+ (instancetype)sharedManager {
    
    static JPGiftShowManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JPGiftShowManager alloc] init];
    });
    return manager;
}

- (void)showGiftViewWithBackView:(UIView *)backView info:(JPGiftModel *)giftModel completeBlock:(completeBlock)completeBlock completeShowGifImageBlock:(completeShowGifImageBlock)completeShowGifImageBlock {
    
    self.completeShowGifImageBlock = completeShowGifImageBlock;
    
    if (self.curentGiftKey && [self.curentGiftKey isEqualToString:giftModel.giftKey]) {
        //有当前的礼物信息
        if ([self.operationCache objectForKey:giftModel.giftKey]) {
            //当前存在操作
            JPGiftOperation *op = [self.operationCache objectForKey:giftModel.giftKey];
            op.giftShowView.giftCount = giftModel.sendCount;
            
            //限制一次礼物的连击最大值
            if (op.giftShowView.currentGiftCount >= giftMaxNum) {
                //移除操作
                [self.operationCache removeObjectForKey:giftModel.giftKey];
                //清空唯一key
                self.curentGiftKey = @"";
            }

        }else {
            //当前操作已结束 重新创建
            JPGiftOperation *operation = [JPGiftOperation addOperationWithView:self.giftShowView OnView:backView Info:giftModel completeBlock:^(BOOL finished,NSString *giftKey) {
                if (self.finishedBlock) {
                    self.finishedBlock(finished);
                }
                //移除操作
                [self.operationCache removeObjectForKey:giftKey];
                //清空唯一key
                self.curentGiftKey = @"";
            }];
            operation.model.defaultCount += giftModel.sendCount;
            //存储操作信息
            [self.operationCache setObject:operation forKey:giftModel.giftKey];
            //操作加入队列
            [self.giftQueue addOperation:operation];
        }

    }else {
        //没有礼物的信息
        if ([self.operationCache objectForKey:giftModel.giftKey]) {
            //当前存在操作
            JPGiftOperation *op = [self.operationCache objectForKey:giftModel.giftKey];
            op.model.defaultCount += giftModel.sendCount;
            
            //限制一次礼物的连击最大值
            if (op.model.defaultCount >= giftMaxNum) {
                //移除操作
                [self.operationCache removeObjectForKey:giftModel.giftKey];
                //清空唯一key
                self.curentGiftKey = @"";
            }

        }else {
            
            JPGiftOperation *operation = [JPGiftOperation addOperationWithView:self.giftShowView OnView:backView Info:giftModel completeBlock:^(BOOL finished,NSString *giftKey) {
                if (self.finishedBlock) {
                    self.finishedBlock(finished);
                }
                //移除操作
                [self.operationCache removeObjectForKey:giftKey];
                //清空唯一key
                self.curentGiftKey = @"";
            }];
            operation.model.defaultCount += giftModel.sendCount;
            //存储操作信息
            [self.operationCache setObject:operation forKey:giftModel.giftKey];
            //操作加入队列
            [self.giftQueue addOperation:operation];
        }
    }
}

@end
