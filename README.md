# DZScrollView
昨天整理之前的东西时，发现自己之前封装了一个轮播图，当然比较简单，也比较low。但是使用起来还是比较方便，并且易修改（注释就差每一个控件干嘛用的解释一遍了）。话不多说，看效果：

这里写图片描述

http://img.blog.csdn.net/20170327200947490?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvR1pYaW9z/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast

实现方法很简单，下面给大家写下实现代码：

    _dz_scrollview = [[DZScorllView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/4+40)];
    _dz_scrollview.dataSource = @[@"http://upload-images.jianshu.io/upload_images/4032443-6dd3429b9d4360c8.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"http://upload-images.jianshu.io/upload_images/102559-3aaac594bfd6fe9b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"http://upload-images.jianshu.io/upload_images/29021-89926ef0f86bd670.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"http://upload-images.jianshu.io/upload_images/4067161-ac329fffd016fee5.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/720/q/50"];
    _dz_scrollview.isAutoTroll = YES;
    _dz_scrollview.delegate = self;
    [headView addSubview:_dz_scrollview];
这里是总共实现的代码，当你这里使用的是url，如果没有url的话就给一个图片，名字叫做aboutimg就OK了，自己可以在自己项目中给的；到这里项目就实现了；
