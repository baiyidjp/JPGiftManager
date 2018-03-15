//
//  ViewController.m
//  JPGiftManager
//
//  Created by Keep丶Dream on 2018/3/13.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "ViewController.h"
#import "JPGiftView.h"
#import "JPGiftCellModel.h"
#import "YYModel.h"
#import "JPGiftModel.h"
#import "JPGiftShowManager.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<JPGiftViewDelegate>
/** gift */
@property(nonatomic,strong) JPGiftView *giftView;
/** gifimage */
@property(nonatomic,strong) UIImageView *gifImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSArray *data = [responseObject objectForKey:@"data"];
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:data];
    [dataArr addObjectsFromArray:data];
    self.giftView.dataArray = [NSArray yy_modelArrayWithClass:[JPGiftCellModel class] json:dataArr];
    
}

- (UIImageView *)gifImageView{
    
    if (!_gifImageView) {
        
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 360, 225)];
        _gifImageView.hidden = YES;
    }
    return _gifImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JPGiftView *)giftView{
    
    if (!_giftView) {
        
        _giftView = [[JPGiftView alloc] init];
        _giftView.delegate = self;
    }
    return _giftView;
}

- (IBAction)clickGift:(id)sender {
    
    [self.giftView showGiftView];
}

- (void)giftViewSendGiftInView:(JPGiftView *)giftView data:(JPGiftCellModel *)model {
    
    NSLog(@"点击-- %@",model.name);
    JPGiftModel *giftModel = [[JPGiftModel alloc] init];
    giftModel.userIcon = model.icon;
    giftModel.userName = model.username;
    giftModel.giftName = model.name;
    giftModel.giftImage = model.icon;
    giftModel.giftGifImage = model.icon_gif;
    giftModel.giftId = model.id;
    giftModel.defaultCount = 0;
    giftModel.sendCount = 1;
    [[JPGiftShowManager sharedManager] showGiftViewWithBackView:self.view info:giftModel completeBlock:^(BOOL finished) {
        //结束
    } completeShowGifImageBlock:^(JPGiftModel *giftModel) {
        //展示gifimage
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self.gifImageView];
            [self.gifImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.giftGifImage]];
            self.gifImageView.hidden = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.gifImageView.hidden = YES;
                [self.gifImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
                [self.gifImageView removeFromSuperview];
            });
        });
    }];
}


- (void)giftViewGetMoneyInView:(JPGiftView *)giftView {
    
    NSLog(@"充值");
}

@end
