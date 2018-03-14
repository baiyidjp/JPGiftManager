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

@interface JPGiftShowManager()

/** 队列 */
@property(nonatomic,strong) NSOperationQueue *giftQueue;
/** showgift */
@property(nonatomic,strong) JPGiftShowView *giftShowView;
/** 队列缓存 */
@property (nonatomic,strong) NSCache *operationCache;
/** 礼物缓存 */
@property (nonatomic,strong) NSCache *userGigtInfos;

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
        
        _giftShowView = [[JPGiftShowView alloc] initWithFrame:CGRectMake(-245, 200, 245, 50)];
        [_giftShowView setShowViewKeyBlock:^(NSString *giftKey) {
            self.curentGiftKey = giftKey;
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

- (NSCache *)userGigtInfos {
    if (_userGigtInfos == nil) {
        _userGigtInfos = [[NSCache alloc] init];
    }
    return _userGigtInfos;
}


+ (instancetype)sharedManager {
    
    static JPGiftShowManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JPGiftShowManager alloc] init];
    });
    return manager;
}

- (void)showGiftViewWithBackView:(UIView *)backView info:(JPGiftModel *)giftModel completeBlock:(completeBlock)completeBlock {
    
    NSLog(@"当前key:%@",self.curentGiftKey);
    NSLog(@"传来key:%@",giftModel.giftKey);
    if (self.curentGiftKey && [self.curentGiftKey isEqualToString:giftModel.giftKey]) {
        //有当前的礼物信息
        if ([self.operationCache objectForKey:giftModel.giftKey]) {
            //当前存在操作
            JPGiftOperation *op = [self.operationCache objectForKey:giftModel.giftKey];
            op.giftShowView.giftCount = giftModel.sendCount;
            NSLog(@"111");
        }else {
            //当前操作已结束 重新创建
            JPGiftOperation *operation = [JPGiftOperation addOperationWithView:self.giftShowView OnView:backView Info:giftModel completeBlock:^(BOOL finished,NSString *giftKey) {
                NSLog(@"执行完毕-%@",giftModel.giftName);
                if (self.finishedBlock) {
                    self.finishedBlock(finished);
                }
                //移除操作
                [self.operationCache removeObjectForKey:giftKey];
                //移除礼物信息
                [self.userGigtInfos removeObjectForKey:giftKey];
                self.curentGiftKey = @"";
            }];
            operation.model.defaultCount += giftModel.sendCount;
            //存储操作信息
            [self.operationCache setObject:operation forKey:giftModel.giftKey];
            //存储礼物信息
            [self.userGigtInfos setObject:giftModel forKey:giftModel.giftKey];
            //操作加入队列
            [self.giftQueue addOperation:operation];
            NSLog(@"222");
        }

    }else {
        //没有礼物的信息
        if ([self.operationCache objectForKey:giftModel.giftKey]) {
            //当前存在操作
            JPGiftOperation *op = [self.operationCache objectForKey:giftModel.giftKey];
            op.model.defaultCount += giftModel.sendCount;
            NSLog(@"333");
        }else {
            
            JPGiftOperation *operation = [JPGiftOperation addOperationWithView:self.giftShowView OnView:backView Info:giftModel completeBlock:^(BOOL finished,NSString *giftKey) {
                NSLog(@"执行完毕-%@",giftModel.giftName);
                if (self.finishedBlock) {
                    self.finishedBlock(finished);
                }
                //移除操作
                [self.operationCache removeObjectForKey:giftKey];
                //移除礼物信息
                [self.userGigtInfos removeObjectForKey:giftKey];
                
                self.curentGiftKey = @"";
            }];
            operation.model.defaultCount += giftModel.sendCount;
            //存储操作信息
            [self.operationCache setObject:operation forKey:giftModel.giftKey];
            //存储礼物信息
            [self.userGigtInfos setObject:giftModel forKey:giftModel.giftKey];
            //操作加入队列
            [self.giftQueue addOperation:operation];
            NSLog(@"444");
        }
    }
}

@end
