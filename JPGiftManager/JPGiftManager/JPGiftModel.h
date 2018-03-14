//
//  JPGiftModel.h  发送的礼物的Model
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPGiftModel : NSObject

/** usericon */
@property(nonatomic,copy)NSString *userIcon;
/** username */
@property(nonatomic,copy)NSString *userName;
/** giftname */
@property(nonatomic,copy)NSString *giftName;
/** giftimage */
@property(nonatomic,copy)NSString *giftImage;
/** count */
@property(nonatomic,assign) NSInteger defaultCount; //0
/** 发送的数 */
@property(nonatomic,assign) NSInteger sendCount;
/** 礼物ID */
@property(nonatomic,copy)NSString *giftId;
/** 礼物操作的唯一Key */
@property(nonatomic,copy)NSString *giftKey;
@end
