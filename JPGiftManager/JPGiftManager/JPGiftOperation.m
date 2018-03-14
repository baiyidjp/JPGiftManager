//
//  JPGiftOperation.m
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPGiftOperation.h"
#import "JPGiftShowView.h"
#import "JPGiftModel.h"

@interface JPGiftOperation()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;


@end

@implementation JPGiftOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

+ (instancetype)addOperationWithView:(JPGiftShowView *)giftShowView OnView:(UIView *)backView Info:(JPGiftModel *)model completeBlock:(completeOpBlock)completeBlock {
    
    JPGiftOperation *op = [[JPGiftOperation alloc] init];
    op.giftShowView = giftShowView;
    op.model = model;
    op.backView = backView;
    op.opFinishedBlock = completeBlock;
    return op;

}

- (void)start {
    
    if ([self isCancelled]) {
        _finished = YES;
        return;
    }
    
    _executing = YES;
    NSLog(@"当前队列-- %@",self.model.giftName);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self.backView addSubview:self.giftShowView];
        [self.giftShowView showGiftShowViewWithModel:self.model completeBlock:^(BOOL finished,NSString *giftKey) {
            self.finished = finished;
            if (self.opFinishedBlock) {
                self.opFinishedBlock(finished,giftKey);
            }
        }];
    }];
    
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}


@end
