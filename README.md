# iOS 直播间送礼物    


----------
- [点击查看-从0开始实现一个直播礼物系统](https://juejin.im/post/5acc605e51882555712caf7f)

- demo基本实现了主流直播间礼物的逻辑    

- 按照队列顺序显示用户所送礼物,累加当前礼物,支持同时显示两人的
礼物


----------


- 先来最终效果图    
 
	![效果图](https://github.com/baiyidjp/JPGiftManager/blob/master/JPGiftManager/gif/giftimage.gif?raw=true)    


----------


- 一句代码调用送礼物    

- 具体的使用可以查看demo中viewController中的调用 (Model的数据必传,需要拼.实际项目中可以直接用服务器返回的数据Model话就行了).
```
/**
 送礼物(不处理第一次展示当前礼物逻辑)
 
 @param backView 礼物动画(左出)展示父view
 @param giftModel 礼物的数据
 @param completeBlock 展示完毕回调
 */

- (void)showGiftViewWithBackView:(UIView *)backView
                            info:(JPGiftModel *)giftModel
                   completeBlock:(completeBlock)completeBlock;

/**
 送礼物(回调第一次展示当前礼物的逻辑)

 @param backView 礼物动画(左出)展示父view
 @param giftModel 礼物的数据
 @param completeBlock 展示完毕回调
 @param completeShowGifImageBlock 第一次展示当前礼物的回调(为了显示gif)
 */
- (void)showGiftViewWithBackView:(UIView *)backView
                            info:(JPGiftModel *)giftModel
                   completeBlock:(completeBlock)completeBlock
       completeShowGifImageBlock:(completeShowGifImageBlock)completeShowGifImageBlock;

```
