//
//  JPHorizontalLayout.m
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/15.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPHorizontalLayout.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface JPHorizontalLayout()
/** 存放cell全部布局属性 */
@property(nonatomic,strong) NSMutableArray *cellAttributesArray;

@end

@implementation JPHorizontalLayout

- (NSMutableArray *)cellAttributesArray{
    
    if (!_cellAttributesArray) {
        
        _cellAttributesArray = [NSMutableArray array];
    }
    return _cellAttributesArray;
}


- (void)prepareLayout {
    
    [super prepareLayout];
    
    
    CGFloat itemW = SCREEN_WIDTH/4.0;
    CGFloat itemH = itemW*125/110.0;
    self.itemSize = CGSizeMake(itemW, itemH);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //刷新后清除所有已布局的属性 重新获取
    [self.cellAttributesArray removeAllObjects];
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < cellCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attibute = [self layoutAttributesForItemAtIndexPath:indexPath];
        NSInteger page = i / 8;//第几页
        NSInteger row = i % 4 + page*4;//第几列
        NSInteger col = i / 4 - page*2;//第几行
        attibute.frame = CGRectMake(row*itemW, col*itemH, itemW, itemH);
        [self.cellAttributesArray addObject:attibute];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.cellAttributesArray;
}

- (CGSize)collectionViewContentSize{
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger page = cellCount / 8 + 1;
    return CGSizeMake(SCREEN_WIDTH*page, 0);
}



@end
