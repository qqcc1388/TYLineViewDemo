//
//  TYMultiLineView.m
//  TYLineViewDemo
//
//  Created by Tiny on 2017/8/11.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import "TYMultiLineView.h"

#define kMarginX        30
#define kMarginY        20

@interface TYMultiLineView ()

@property (nonatomic,assign)CGFloat  maxYvalue;     //最大y值

@property (nonatomic,assign) NSInteger xAxisCount;  //x轴点数

@property (nonatomic,assign) NSInteger yAxisCount;  //y轴点数

@end

@implementation TYMultiLineView

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
    self.backgroundColor = [UIColor cyanColor];
    
    self.maxYvalue = 200;
    self.yAxisCount = 5;
    self.xAxisCount = 5;
    
    [self setNeedsDisplay];
}

-(void)clear{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

-(void)addLineWithDatas:(NSArray *)datas lineColor:(UIColor *)color animated:(BOOL)animated{
    
    //设置最大值
    self.maxYvalue = 200;
    //设置xAxisCount
    self.xAxisCount = datas.count;
    
    CAShapeLayer* lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.lineWidth = 1;
    lineLayer.lineCap = @"round";
    lineLayer.lineJoin = @"round";
    lineLayer.strokeColor = color.CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.frame = self.bounds;
    [self.layer addSublayer:lineLayer];
    
    UIBezierPath *path = [self prepareBezierPathDatas:datas];
    
    lineLayer.path = path.CGPath;
    
    if(animated){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 2.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(0);
        animation.toValue =@(1);
        [lineLayer addAnimation:animation forKey:@"strokeEnd"];
    }
    
}

-(UIBezierPath *)prepareBezierPathDatas:(NSArray *)datas
{
    CGFloat totalHeight = CGRectGetHeight(self.frame) - kMarginY*2;
    //    CGFloat maxY = self.maxYvalue;
    CGFloat totoalWidth = CGRectGetWidth(self.frame) - kMarginX*2;
    //x轴每一段的宽度
    CGFloat perX = totoalWidth/((self.xAxisCount-1)*1.0);
    
    CGFloat yper = totalHeight/(self.maxYvalue*1.0);  //y轴一个单位的高度
    //主线段曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    
    for (int i = 0; i < datas.count; i++) {
        NSInteger valueY = [datas[i] integerValue];
        CGFloat x = kMarginX + perX*i;
        CGFloat y = (totalHeight + kMarginY) - yper*valueY;
        CGPoint point = CGPointMake(x,y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else{
            [bezierPath addLineToPoint:point];
        }
    }
    return bezierPath;
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
    CGFloat perHeight = ((totalHeight - kMarginY*2)/(self.yAxisCount*1.0));
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
    for (int i = 0; i < self.xAxisCount -1; i++) {
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


@end

