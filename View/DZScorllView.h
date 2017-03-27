//
//  DZScorllView.h
//  woyaochaweizhang
//https://github.com/BenHuGZX/DZScrollView
//  Created by 古智性 on 2016/12/15.
//  Copyright © 2016年 KATA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DZScorllViewDelegate <NSObject>

-(void)imageIndexClick:(NSInteger)index;

@end

@interface DZScorllView : UIView
@property (nonatomic,strong) NSMutableArray<UIButton *> * btn_array; //这个数组承载我们三个btn
@property (nonatomic,strong) NSTimer * timer; //定时器
@property (nonatomic,assign) BOOL isAutoTroll; //这个是判断我们是否开启定时器
@property (nonatomic,strong) NSArray * dataSource; //这个是我们外面拿过来的图片数组
@property (nonatomic,weak) id<DZScorllViewDelegate> delegate; //按钮点击的代理，我们把按钮点击方法要开出去
@end
