//
//  DZScorllView.m
//  woyaochaweizhang
//https://github.com/BenHuGZX/DZScrollView
//  Created by 古智性 on 2016/12/15.
//  Copyright © 2016年 KATA. All rights reserved.
//
// Rect
#define ScreenWidth             CGRectGetWidth([[UIScreen mainScreen] bounds])
#define ScreenHeight            CGRectGetHeight([[UIScreen mainScreen] bounds])

#import "DZScorllView.h"

@interface DZScorllView()<UIScrollViewDelegate>{
}
@property (nonatomic,strong) UIScrollView * main_scrollView; //我们的滑动视图，承载了3个btn，用来展示banner
@property (nonatomic,strong) UIPageControl * pageContrl; //这个是banner下面的小圆点
//这三个记录btn位置的属性
@property (nonatomic,assign) NSInteger leftIndex;
@property (nonatomic,assign) NSInteger centerIndex;
@property (nonatomic,assign) NSInteger rightIndex;

@end

@implementation DZScorllView

//我们在这里重写他的Frame，并且在这里给给他初始化滑动视图和btn，还有数组
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _main_scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _main_scrollView.showsHorizontalScrollIndicator = NO;
        _main_scrollView.scrollEnabled = YES;
        _main_scrollView.pagingEnabled = YES;
        _main_scrollView.delegate = self;
        _main_scrollView.contentSize = CGSizeMake(ScreenWidth*3, frame.size.height);
        _main_scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
        
        _timer = [[NSTimer alloc]init];
        
        _btn_array = [NSMutableArray new];
        for (int i = 0 ; i<3; i++) {
            UIButton * imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imageBtn.tag = 1000+i;
            imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageBtn setAdjustsImageWhenHighlighted:NO];
            [imageBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_btn_array addObject:imageBtn];
            [_main_scrollView addSubview:imageBtn];
        }
        //在这里给他进行初始化，这个是分页小圆点
        _pageContrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - 30, ScreenWidth, 30)];
        _pageContrl.pageIndicatorTintColor = [UIColor redColor];
        _pageContrl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_main_scrollView];
        [self addSubview:_pageContrl];
        self.dataSource = [NSArray new];
    }
    return self;
}

//这个是数组的set方法，我们需要在这里进行btn的排布并且在这里判断是否可以滑动的操作的赋值
-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource; //这里要进行一次赋值，否则这个数组在其他地方是没有值得，并且我们尽量要是用self来调用，因为_不能使用set方法
    if (dataSource == nil) {//如果数组为空，我们要把我们承载btn的数组中的btn都设置为空
        for (UIButton * btn in _btn_array) {
            [btn setImage:nil forState:UIControlStateNormal];
        }
        return;
    }
    //这里是要使展示多少个小圆点，这里是图片数组的个数
    _pageContrl.numberOfPages = dataSource.count;
    _leftIndex = dataSource.count - 1;
    _centerIndex = 0;
    _rightIndex = 1;
    
    for (int i = 0; i<3; i++) {
        UIButton * imageBtn = _btn_array[i];
        if (dataSource.count <= 0) {
            [imageBtn setImage:nil forState:UIControlStateNormal];
        }else{
            //三目运算符，如果i为0，那么就取leftIndex值，如果不为0就取centerIndex得值
            id image = [dataSource objectAtIndex:(i==0?_leftIndex:_centerIndex)];
            [self imageSet:image button:imageBtn];
        }
        
        //当数组个数小于2的时候我们要给他停止滑动，并且我们要隐藏小圆点，否则开启滑动，并给他显示小圆点
        if (dataSource.count < 2) {
            _main_scrollView.scrollEnabled = NO;
            _pageContrl.hidden = YES;
        }else{
            _main_scrollView.scrollEnabled = YES;
            _pageContrl.hidden = NO;
        }
    }
}

-(void)setIsAutoTroll:(BOOL)isAutoTroll{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    }
}

//开启定时器，并且进行了判断，如果数组为空或者数组的个数 > 1就可以滑动，否则我们就不开启他的自动滑动
-(void)startTimer{
    if (_dataSource != nil && _dataSource.count > 1) {
    }else{
        return;
    }
    [_main_scrollView setContentOffset:CGPointMake(ScreenWidth*2, 0) animated:YES];
    //消息传递器,我们只需要告诉他调用什么方法，和在什么时候去调用
    [self performSelector:@selector(decelerating) withObject:nil afterDelay:0.4];
    
}

//这里接收到消息开始执行
-(void)decelerating{
    //减速停止时开始执行scrollview的代理
    [self scrollViewDidEndDecelerating:self.main_scrollView];
}

//当frame的值发生变化就会调用
-(void) layoutSubviews{
    [super layoutSubviews];
    _main_scrollView.frame = self.frame;
    _main_scrollView.contentSize = CGSizeMake(self.frame.size.width*3, self.frame.size.height);
    _pageContrl.frame = CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 30);
    
    for (int i = 0; i<_btn_array.count; i++) {
        UIButton * button = _btn_array[i];
        button.frame = CGRectMake(i*ScreenWidth, 0, self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark  =========ScrollView代理UIScrollViewDelegate============
//减速停止时开始执行scrollview的代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_dataSource.count <= 0) {
        return;
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    //这里根据scrollview.contentOffset.来判断往那边滑动
    if (offsetX == 0) {//向左滑动
        _leftIndex = _leftIndex - 1;
        _centerIndex = _centerIndex - 1;
        _rightIndex = _rightIndex - 1;
        
        _leftIndex = _leftIndex == -1?_dataSource.count-1:_leftIndex;
        _centerIndex = _centerIndex == -1?_dataSource.count-1:_centerIndex;
        _rightIndex = _rightIndex == -1?_dataSource.count-1:_rightIndex;
    }else if (offsetX == ScreenWidth*2){//向右滑动
        _leftIndex = _leftIndex + 1;
        _centerIndex = _centerIndex + 1;
        _rightIndex = _rightIndex + 1;
        
        _leftIndex = _leftIndex == _dataSource.count?0:_leftIndex;
        _centerIndex = _centerIndex == _dataSource.count?0:_centerIndex;
        _rightIndex = _rightIndex == _dataSource.count?0:_rightIndex;
    }
    
    //重新赋值
    if (_dataSource.count == 1) {
        UIButton * leftBtn = [scrollView viewWithTag:1000];
        id image1 = _dataSource[_leftIndex];
        [self imageSet:image1 button:leftBtn];
        
    }else if (_dataSource.count == 2){
        UIButton * leftBtn = [scrollView viewWithTag:1000];
        id image1 = _dataSource[_leftIndex];
        [self imageSet:image1 button:leftBtn];
        
        UIButton * centerBtn = [scrollView viewWithTag:1001];
        id image2 = _dataSource[_centerIndex];
        [self imageSet:image2 button:centerBtn];
        
    }else{
        UIButton * leftBtn = [scrollView viewWithTag:1000];
        id image1 = _dataSource[_leftIndex];
        [self imageSet:image1 button:leftBtn];
        
        UIButton * centerBtn = [scrollView viewWithTag:1001];
        id image2 = _dataSource[_centerIndex];
        [self imageSet:image2 button:centerBtn];
        
        UIButton * rightBtn = [scrollView viewWithTag:1002];
        id image3 = _dataSource[_rightIndex];
        [self imageSet:image3 button:rightBtn];
    }
    
    //视图始终在显示在中间
    scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    self.pageContrl.currentPage = self.centerIndex;
    
    //重新开启自动滑动
    if (_dataSource != nil) {
        if (_dataSource.count >= 2) {
            self.isAutoTroll = YES;
        }else{
            self.isAutoTroll = NO;
        }
    }
    
}

//开始拖拽的时候，在这里给他置为nil
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//在这里我们给btn进行图片的赋值
-(void)imageSet:(id)image button:(UIButton*)btn{
    
    if ([image isKindOfClass:[UIImage class]]){
        [btn setBackgroundImage:[UIImage imageNamed:@"aboutLogo"] forState:UIControlStateNormal];
    }else{
        NSString * imgStr = image;
        if (imgStr != nil) {
            [btn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]]] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"aboutLogo"] forState:UIControlStateNormal];
        }
    }
}

//这里是我们按钮绑定的点击事件，在哪里使用就在那里开启
-(void)imgBtnClick:(UIButton *)sender{
    if (_dataSource != nil) {
        [self.delegate imageIndexClick:_centerIndex];
    }
}

@end
