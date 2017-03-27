//
//  ViewController.m
//  View
//https://github.com/BenHuGZX/DZScrollView
//  Created by 古智性 on 2017/3/26.
//  Copyright © 2017年 古智性. All rights reserved.
//

#define ScreenWidth             CGRectGetWidth([[UIScreen mainScreen] bounds])
#define ScreenHeight            CGRectGetHeight([[UIScreen mainScreen] bounds])

#import "ViewController.h"
#import "DZScorllView.h"
@interface ViewController ()<DZScorllViewDelegate>
@property (nonatomic, strong) DZScorllView * dz_scrollview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, ScreenHeight/4 + 40)];
    headView.backgroundColor = [UIColor whiteColor];
    
    _dz_scrollview = [[DZScorllView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/4+40)];
    _dz_scrollview.dataSource = @[@"http://upload-images.jianshu.io/upload_images/4032443-6dd3429b9d4360c8.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"http://upload-images.jianshu.io/upload_images/102559-3aaac594bfd6fe9b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"http://upload-images.jianshu.io/upload_images/29021-89926ef0f86bd670.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"http://upload-images.jianshu.io/upload_images/4067161-ac329fffd016fee5.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/720/q/50"];
    _dz_scrollview.isAutoTroll = YES;
    _dz_scrollview.delegate = self;
    [headView addSubview:_dz_scrollview];
    [self.view addSubview:headView];
}

-(void)imageIndexClick:(NSInteger)index{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
