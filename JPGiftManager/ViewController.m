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

@interface ViewController ()<JPGiftViewDelegate>
/** gift */
@property(nonatomic,strong) JPGiftView *giftView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSArray *data = [responseObject objectForKey:@"data"];
    self.giftView.dataArray = [NSArray yy_modelArrayWithClass:[JPGiftCellModel class] json:data];
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

- (void)giftViewDisSendGiftInView:(JPGiftView *)giftView data:(JPGiftCellModel *)model {
    
    NSLog(@"点击-- %@",model.name);
    JPGiftModel *giftModel = [[JPGiftModel alloc] init];
    giftModel.userIcon = model.icon;
    giftModel.userName = model.username;
    giftModel.giftName = model.name;
    giftModel.giftImage = model.icon;
    giftModel.giftId = model.id;
    giftModel.defaultCount = 0;
    giftModel.sendCount = 1;
    [[JPGiftShowManager sharedManager] showGiftViewWithBackView:self.view info:giftModel completeBlock:^(BOOL finished) {
        
    }];
}

@end
