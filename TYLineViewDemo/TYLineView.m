//
//  TYLineView.m
//  TYLineViewDemo
//
//  Created by Tiny on 2017/8/7.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import "TYLineView.h"

#define kMarginX        30
#define kMarginY        20

@interface TYLineView  ()

@property (nonatomic,strong)CAShapeLayer *shapeLayer;//划线layer

@property (nonatomic,strong) CAShapeLayer *backLayer; //背景

@property (nonatomic,assign)CGFloat  maxYvalue;     //最大y值

@property (nonatomic,assign) NSInteger xAxisCount;  //x轴点数

@property (nonatomic,assign) NSInteger yAxisCount;  //y轴点数

@end

@implementation TYLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    //闭合背景
    _backLayer = [[CAShapeLayer alloc] init];
    _backLayer.fillColor = [UIColor grayColor].CGColor;
    _backLayer.frame = self.bounds;
    //    [self.layer addSublayer:_backLayer];
    
    //主线段
    _shapeLayer = [[CAShapeLayer alloc] init];
    _shapeLayer.lineWidth = 1;
    _shapeLayer.lineCap = @"round";
    _shapeLayer.lineJoin = @"round";
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.frame = self.bounds;
    //    [self.layer addSublayer:_shapeLayer];
    
    //初始化
    self.isShowBack = NO;
    self.yAxisCount = 5;
    self.backgroundColor = [UIColor cyanColor];
}

-(void)clear{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

-(void)setDatas:(NSArray <NSNumber *>*)datas{
    //保存数据
    _datas = datas;
    
    //取出最大值
    CGFloat max =[[datas valueForKeyPath:@"@max.floatValue"] floatValue];
    
    //    NSLog(@"%.f",max);
    //设置最大值
    self.maxYvalue = max;
    //设置xAxisCount
    self.xAxisCount = datas.count;
    
    [self setNeedsDisplay];
    //划线
    [self drawLine];
}

-(void)drawLine
{
    
    CGFloat totalHeight = CGRectGetHeight(self.frame) - kMarginY*2;
    //    CGFloat maxY = self.maxYvalue;
    CGFloat totoalWidth = CGRectGetWidth(self.frame) - kMarginX*2;
    //x轴每一段的宽度
    CGFloat perX = totoalWidth/(self.xAxisCount-1)*1.0;
    
    CGFloat yper = totalHeight/self.maxYvalue;  //y轴一个单位的高度
    //主线段曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    //背景曲线
    UIBezierPath *backPath = [UIBezierPath bezierPath];
    //原点
    CGPoint startPoint = CGPointMake(kMarginX,totalHeight + kMarginY);
    [backPath moveToPoint:startPoint];
    
    for (int i = 0; i < _datas.count; i++) {
        NSInteger valueY = [_datas[i] integerValue];
        CGFloat x = kMarginX + perX*i;
        CGFloat y = (totalHeight + kMarginY) - yper*valueY;
        CGPoint point = CGPointMake(x,y);
        NSLog(@"%@",NSStringFromCGPoint(point));
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else{
            [bezierPath addLineToPoint:point];
        }
        [backPath addLineToPoint:point];
    }
    //终点
    CGPoint endPoint = CGPointMake(kMarginX + perX*(self.datas.count-1), totalHeight + kMarginY);
    [backPath addLineToPoint:endPoint];
    
    //开始动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 2.0f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = @(0);
    animation.toValue =@(1);
    self.shapeLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:self.shapeLayer];
    [self.shapeLayer addAnimation:animation forKey:@"strokeEnd"];
    [self.layer addSublayer:self.backLayer];
    self.backLayer.path = backPath.CGPath;
}



-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0f];
    [[UIColor redColor] set];
    
    CGFloat totalWidth = self.bounds.size.width;
    CGFloat totalHeight = self.bounds.size.height;
    
    //画坐标系
    //------> y轴
    [path moveToPoint:CGPointMake(kMarginX,kMarginY)];
    [path addLineToPoint:CGPointMake(kMarginX, totalHeight - kMarginY)];
    
    //------> x轴
    [path addLineToPoint:CGPointMake(totalWidth - kMarginX, totalHeight - kMarginY)];
    [path stroke];
    
    //线段 - y轴
    CGFloat perHeight = ((totalHeight - kMarginY*2)/(self.yAxisCount));
    for (int i = 0; i < self.yAxisCount; i++) {
        CGFloat y = perHeight*i + kMarginY;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path setLineWidth:1.0f];
        [[UIColor blueColor] set];
        [path moveToPoint:CGPointMake(kMarginX, y)];
        [path addLineToPoint:CGPointMake(kMarginX+ 5, y)];
        [path stroke];
    }
    
    //线段 - x轴
    CGFloat perWidth = (totalWidth - kMarginX*2)/((self.xAxisCount - 1)*1.0);
    for (int i = 0; i < self.xAxisCount - 1; i++) {
        CGFloat x = perWidth*(i+1);
        CGFloat y = totalHeight - kMarginY;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path setLineWidth:1.0f];
        [[UIColor blueColor] set];
        [path moveToPoint:CGPointMake(x+kMarginX, y)];
        [path addLineToPoint:CGPointMake(x+kMarginX, y-5)];
        [path stroke];
    }
    
    //画y轴文字
    NSMutableArray *yArr = [NSMutableArray array];
    
    for (int i = 0; i < self.yAxisCount; i++) {
        
        [yArr  addObject:[NSString stringWithFormat:@"%.f",self.maxYvalue - self.maxYvalue/self.yAxisCount *i]];
    }
    [yArr addObject:@"0"];
    
    for (int i = 0; i < yArr.count ; i++) {
        NSString *title = yArr[i];
        CGFloat y = ((totalHeight - kMarginY*2)/(self.yAxisCount))*i + kMarginY;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setAlignment:NSTextAlignmentCenter];
        
        [title drawInRect:CGRectMake(0,y-5, kMarginX, 20) withAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:10],NSParagraphStyleAttributeName:style}];
    }
    
}



#pragma mark setter getter
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.shapeLayer.strokeColor = lineColor.CGColor;
}

-(void)setIsShowBack:(BOOL)isShowBack{
    _isShowBack = isShowBack;
    self.backLayer.hidden = !isShowBack;
}

@end

