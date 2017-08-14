//
//  TYMultiLineView.h
//  TYLineViewDemo
//
//  Created by Tiny on 2017/8/11.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//  可以绘制多条折线

#import <UIKit/UIKit.h>

@interface TYMultiLineView : UIView

-(void)addLineWithDatas:(NSArray *)datas lineColor:(UIColor *)color animated:(BOOL)animated;

@end
