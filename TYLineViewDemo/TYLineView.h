//
//  TYLineView.h
//  TYLineViewDemo
//
//  Created by Tiny on 2017/8/7.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//  单根折线

#import <UIKit/UIKit.h>

@interface TYLineView : UIView

@property (nonatomic,strong) NSArray *datas;

@property (nonatomic,strong) UIColor *lineColor;

/**
 是否显示灰色背景
 */
@property (nonatomic,assign) BOOL isShowBack;

/// 移除划线
-(void)clear;



@end

