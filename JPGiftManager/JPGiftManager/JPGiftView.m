//
//  JPGiftView.m
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPGiftView.h"
#import "JPGiftCollectionViewCell.h"
#import "JPGiftCellModel.h"
#import "JPHorizontalLayout.h"

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

static NSString *cellID = @"JPGiftCollectionViewCell";

@interface JPGiftView()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 底部功能栏 */
@property(nonatomic,strong) UIView *bottomView;
/** 礼物显示 */
@property(nonatomic,strong) UICollectionView *collectionView;
/** ccb余额 */
@property(nonatomic,strong) UILabel *ccbLabel;
/** 上一次点击的model */
@property(nonatomic,strong) JPGiftCellModel *preModel;
/** pagecontro */
@property(nonatomic,strong) UIPageControl *pageControl;
/** money */
@property(nonatomic,strong) UILabel *moneyLabel;

@end

@implementation JPGiftView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);

        [self p_SetUI];
    }
    return self;
}


#pragma mark -设置UI
- (void)p_SetUI {
    
    UIView *bottomView = [[UIView alloc] initWithFrame: CGRectMake(0, self.frame.size.height-Bottom_Margin(44), self.frame.size.width, Bottom_Margin(44))];
    bottomView.backgroundColor = [UIColor blackColor];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    self.pageControl = [[UIPageControl alloc]initWithFrame: CGRectMake(CGRectGetWidth(bottomView.frame)*0.5-15, 0, 30, CGRectGetHeight(bottomView.frame))];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.hidden = YES;
    [bottomView addSubview:self.pageControl];
    
    
    UIButton *getMoneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 12, 30, 20)];
    [getMoneyBtn setTitle:@"充值" forState:UIControlStateNormal];
    [getMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getMoneyBtn setBackgroundColor:[UIColor purpleColor]];
    [getMoneyBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [getMoneyBtn addTarget:self action:@selector(p_ClickGetMoneyBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:getMoneyBtn];
    
    UIImageView *ccbImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(getMoneyBtn.frame)+5, CGRectGetMinY(getMoneyBtn.frame), 20, 20)];
    ccbImage.image = [UIImage imageNamed:@"Live_Red_ccb"];
    [bottomView addSubview:ccbImage];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ccbImage.frame)+5, CGRectGetMinY(ccbImage.frame), 100, 20)];
    moneyLabel.text = @"999";
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.font = [UIFont systemFontOfSize:13];
    [bottomView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width-60, 2, 60, 40)];
    [sendBtn setBackgroundColor:[UIColor orangeColor]];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(p_ClickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendBtn];
    
    //110*125
    CGFloat itemW = SCREEN_WIDTH/4.0;
    CGFloat itemH = itemW*125/110.0;
    JPHorizontalLayout *layout = [[JPHorizontalLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(bottomView.frame)-1-2*itemH, SCREEN_WIDTH, 2*itemH) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = NO;
    [collectionView registerClass:[JPGiftCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    collectionView.pagingEnabled = YES;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;

    self.pageControl.numberOfPages = dataArray.count/8+1;
    self.pageControl.currentPage = 0;
    self.pageControl.hidden =  !(dataArray.count/8);
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JPGiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count) {
        JPGiftCellModel *model = self.dataArray[indexPath.item];
        cell.model = model;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item < self.dataArray.count) {
        JPGiftCellModel *model = self.dataArray[indexPath.item];
        model.isSelected = !model.isSelected;
        if ([self.preModel isEqual:model]) {
            [collectionView reloadData];
        }else {
            self.preModel.isSelected = NO;
            [collectionView reloadData];
        }
        self.preModel = model;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x;
    self.pageControl.currentPage = x/SCREEN_WIDTH+0.5;
}

#pragma mark -发送
- (void)p_ClickSendBtn {
    
    //找到已选中的礼物
    BOOL isBack = NO;
    for (JPGiftCellModel *model in self.dataArray) {
        if (model.isSelected) {
            isBack = YES;
            if ([self.delegate respondsToSelector:@selector(giftViewSendGiftInView:data:)]) {
                [self.delegate giftViewSendGiftInView:self data:model];
            }
        }
    }
    if (!isBack) {
        //提示选择礼物
        NSLog(@"没有选择礼物");
    }

}

#pragma mark -充值
- (void)p_ClickGetMoneyBtn {
    
    if ([self.delegate respondsToSelector:@selector(giftViewGetMoneyInView:)]) {
        [self.delegate giftViewGetMoneyInView:self];
    }
}



- (void)showGiftView {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];

}

- (void)hiddenGiftView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hiddenGiftView];
}

@end
