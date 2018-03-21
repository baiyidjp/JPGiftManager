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
@property(nonatomic,strong) NSOperationQueue *giftQueue1;
@property(nonatomic,strong) NSOperationQueue *giftQueue2;
/** showgift */
@property(nonatomic,strong) JPGiftShowView *giftShowView1;
@property(nonatomic,strong) JPGiftShowView *giftShowView2;
/** 操作缓存 */
@property (nonatomic,strong) NSCache *operationCache;

@property(nonatomic,copy) completeBlock finishedBlock;
/** 当前礼物的keys */
@property(nonatomic,strong) NSMutableArray *curentGiftKeys;

@end

@implementation JPGiftShowManager

- (NSOperationQueue *)giftQueue1{
    
    if (!_giftQueue1) {
        
        _giftQueue1 = [[NSOperationQueue alloc] init];
        _giftQueue1.maxConcurrentOperationCount = 1;
    }
    return _giftQueue1;
}

- (NSOperationQueue *)giftQueue2{
    
    if (!_giftQueue2) {
        
        _giftQueue2 = [[NSOperationQueue alloc] init];
        _giftQueue2.maxConcurrentOperationCount = 1;
    }
    return _giftQueue2;
}

- (NSMutableArray *)curentGiftKeys{
    
    if (!_curentGiftKeys) {
        
        _curentGiftKeys = [NSMutableArray array];
    }
    return _curentGiftKeys;
}

- (JPGiftShowView *)giftShowView1{
    
    if (!_giftShowView1) {
        CGFloat itemW = SCREEN_WIDTH/4.0;
        CGFloat itemH = itemW*105/93.8;
        
        __weak typeof(self) weakSelf = self;
        CGFloat showViewW = 10+showGiftView_UserIcon_LT+showGiftView_UserIcon_WH+showGiftView_UserName_L+showGiftView_UserName_W+showGiftView_GiftIcon_W+showGiftView_XNum_L+showGiftView_XNum_W;
        CGFloat showViewY = SCREEN_HEIGHT-Bottom_Margin(44)-2*itemH-showGiftView_GiftIcon_H-10-15;
        _giftShowView1 = [[JPGiftShowView alloc] initWithFrame:CGRectMake(-showViewW, showViewY, showViewW, showGiftView_GiftIcon_H)];
        [_giftShowView1 setShowViewKeyBlock:^(JPGiftModel *giftModel) {
            [weakSelf.curentGiftKeys addObject:giftModel.giftKey];
            if (weakSelf.completeShowGifImageBlock) {
                weakSelf.completeShowGifImageBlock(giftModel);
            }
        }];
    }
    return _giftShowView1;
}

- (JPGiftShowView *)giftShowView2 {
    
    if (!_giftShowView2) {
        CGFloat itemW = SCREEN_WIDTH/4.0;
        CGFloat itemH = itemW*105/93.8;
        
        __weak typeof(self) weakSelf = self;
        CGFloat showViewW = 10+showGiftView_UserIcon_LT+showGiftView_UserIcon_WH+showGiftView_UserName_L+showGiftView_UserName_W+showGiftView_GiftIcon_W+showGiftView_XNum_L+showGiftView_XNum_W;
        CGFloat showViewY = SCREEN_HEIGHT-Bottom_Margin(44)-2*itemH-showGiftView_GiftIcon_H*2-2*10-15;
        _giftShowView2 = [[JPGiftShowView alloc] initWithFrame:CGRectMake(-showViewW, showViewY, showViewW, showGiftView_GiftIcon_H)];
        [_giftShowView2 setShowViewKeyBlock:^(JPGiftModel *giftModel) {
            [weakSelf.curentGiftKeys addObject:giftModel.giftKey];
            if (weakSelf.completeShowGifImageBlock) {
                weakSelf.completeShowGifImageBlock(giftModel);
            }
        }];
    }
    return _giftShowView2;
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
    
    if (self.curentGiftKeys.count && [self.curentGiftKeys containsObject:giftModel.giftKey]) {
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
                [self.curentGiftKeys removeObject:giftModel.giftKey];
            }

        }else {
            NSOperationQueue *queue;
            JPGiftShowView *showView;
            if (self.giftQueue1.operations.count <= self.giftQueue2.operations.count) {
                queue = self.giftQueue1;
                showView = self.giftShowView1;
            }else {
                queue = self.giftQueue2;
                showView = self.giftShowView2;
            }

            //当前操作已结束 重新创建
            JPGiftOperation *operation = [JPGiftOperation addOperationWithView:showView OnView:backView Info:giftModel completeBlock:^(BOOL finished,NSString *giftKey) {
                if (self.finishedBlock) {
                    self.finishedBlock(finished);
                }
                //移除操作
                [self.operationCache removeObjectForKey:giftKey];
                //清空唯一key
                [self.curentGiftKeys removeObject:giftKey];
            }];
            operation.model.defaultCount += giftModel.sendCount;
            //存储操作信息
            [self.operationCache setObject:operation forKey:giftModel.giftKey];
            //操作加入队列
            [queue addOperation:operation];
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
                [self.curentGiftKeys removeObject:giftModel.giftKey];
            }

        }else {
            NSOperationQueue *queue;
            JPGiftShowView *showView;
            if (self.giftQueue1.operations.count <= self.giftQueue2.operations.count) {
                queue = self.giftQueue1;
                showView = self.giftShowView1;
            }else {
                queue = self.giftQueue2;
                showView = self.giftShowView2;
            }

            JPGiftOperation *operation = [JPGiftOperation addOperationWithView:showView OnView:backView Info:giftModel completeBlock:^(BOOL finished,NSString *giftKey) {
                if (self.finishedBlock) {
                    self.finishedBlock(finished);
                }
                //移除操作
                [self.operationCache removeObjectForKey:giftKey];
                //清空唯一key
                [self.curentGiftKeys removeObject:giftKey];
            }];
            operation.model.defaultCount += giftModel.sendCount;
            //存储操作信息
            [self.operationCache setObject:operation forKey:giftModel.giftKey];
            //操作加入队列
            [queue addOperation:operation];
        }
    }
}

@end
