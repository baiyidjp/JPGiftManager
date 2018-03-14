//
//  JPGiftModel.m
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPGiftModel.h"

@implementation JPGiftModel

- (NSString *)giftKey {
    
    return [NSString stringWithFormat:@"%@%@",self.giftName,self.giftId];
}

@end
