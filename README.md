# TYLineViewDemo
a simple way for drawing line

图表绘制的过程实际上是坐标位置的计算过程，至于画线只要有了position,通过CAShapeLayer+BezierPath很快就可以画出来，这里提供一个绘制折线的demo,贵在思路，有需要的可以参考

话不多说，效果图和代码

![](http://images2017.cnblogs.com/blog/950551/201708/950551-20170814182604428-243169550.gif)

使用方法：
```
lineView:
[self.lineView setDatas:[self prepareDatas]];

multiLineView:
    [self.multiLineView addLineWithDatas:[self prepareDatas] lineColor:[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1] animated:YES];

-(NSArray *)prepareDatas{
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [datas addObject:@(arc4random_uniform(201)).stringValue];
    }
    return datas;
}
```

实现方法参考demo

