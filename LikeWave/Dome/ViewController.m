//
//  ViewController.m
//  Dome
//
//  Created by liubaojian on 16/8/27.
//  Copyright © 2016年 liubaojian. All rights reserved.
//

#import "ViewController.h"


#define HEIGHT                   [UIScreen mainScreen].bounds.size.height
#define WIDTH                    [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
{
    CGFloat waveHeight;//浪高
    CGFloat waveSpeed; //浪速
    CGFloat waveCurvature;//浪的弯曲度
    CGFloat offSetValue;
    
    CAShapeLayer *realWaveLayer;
    CAShapeLayer *maskWaveLayer;
    
    UIImageView *boardView;
}
@end

@implementation ViewController


/**
 *  本篇dome 已最 简单的方式展现，没有多余的封装和复杂的方法
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"舟行碧波上";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化
    waveHeight = 8;
    waveSpeed = 1;
    waveCurvature = 1.2;
    offSetValue = 0.f;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self creatWave];
    
    /**
     *   初始化一个CADisplayLink对象并以特定的模式注册到runloop之中，屏幕刷新时调用指定的方法
     *
     */
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveMove)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)creatWave{
    
    UIView *blueBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, HEIGHT, 160)];
    blueBgView.backgroundColor = [UIColor colorWithRed:0.47 green:0.83 blue:0.98 alpha:1.00];
    [self.view addSubview:blueBgView];
    
    /**
     *  此处 CAShapeLayer 的Frame 需要初始化，后续path的坐标是相对 CAShapeLayer 的frame的，
        如果此处不设置 Frame ， path 里面点的坐标就要设置成想对当前 View的坐标 效果才对。
     */
    //实浪图层
    realWaveLayer = [CAShapeLayer layer];
    CGRect rect = blueBgView.frame;
    rect.origin.y = CGRectGetHeight(rect)-waveHeight;
    realWaveLayer.fillColor = [UIColor whiteColor].CGColor;
    realWaveLayer.frame = rect;
    [blueBgView.layer addSublayer:realWaveLayer];
    
    //背后的遮罩浪图层
    maskWaveLayer = [CAShapeLayer layer];
    CGRect rect1 = blueBgView.frame;
    rect1.origin.y = CGRectGetHeight(rect)-waveHeight;
    maskWaveLayer.fillColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4].CGColor;
    maskWaveLayer.frame = rect1;
    [blueBgView.layer addSublayer:maskWaveLayer];
    
    
    boardView =  [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2-30, 0, 60, 60)];
    boardView.image = [UIImage imageNamed:@"chuan"];
    [blueBgView addSubview:boardView];
    
}
- (void)waveMove
{
    
    //为实浪图层设置路径，起始点
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, waveHeight);
    CGFloat y = 0;
    //为实浪图层设置路径，起始点
    CGMutablePathRef maskPath = CGPathCreateMutable();
    CGPathMoveToPoint(maskPath, nil, 0, waveHeight);
    CGFloat masky = 0;
    
    
    offSetValue += waveSpeed; //移动的变化就是靠这个值的累加
    /**
     *  使用for循环 生成一系列的正弦曲线的点，并添加到路径中
     */
    for (int x = 0; x<WIDTH; x++) {
        y = waveHeight*sinf(0.01*waveCurvature*x+offSetValue*0.045);
        CGPathAddLineToPoint(path, nil, x, y);
        //遮罩层的路径与之相反
        masky = -y;
        CGPathAddLineToPoint(maskPath, nil, x, masky);
    }
    //CAShapeLayer右下角的点
    CGPathAddLineToPoint(path, nil, WIDTH, waveHeight);
    //CAShapeLayer左下角的点
    CGPathAddLineToPoint(path, nil, 0, waveHeight);
    //闭合路径
    CGPathCloseSubpath(path);
    realWaveLayer.path =  path;
    //释放路径
    CGPathRelease(path);
    
    CGPathAddLineToPoint(maskPath, nil, WIDTH, waveHeight);
    CGPathAddLineToPoint(maskPath, nil, 0, waveHeight);
    CGPathCloseSubpath(maskPath);
    maskWaveLayer.path =  maskPath;
    CGPathRelease(maskPath);
    
    //设置船的 y坐标。
    CGFloat CentY = waveHeight*sinf(0.01*waveCurvature*WIDTH/2+offSetValue*0.045);
    CGRect boardViewFrame = [boardView frame];
    boardViewFrame.origin.y = 100-waveHeight+CentY;
    boardView.frame = boardViewFrame;
    
}





@end
