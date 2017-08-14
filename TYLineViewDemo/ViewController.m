//
//  ViewController.m
//  TYLineViewDemo
//
//  Created by Tiny on 2017/8/7.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import "ViewController.h"
#import "TYLineView.h"
#import "TYMultiLineView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet TYLineView *lineView;

@property (weak, nonatomic) IBOutlet TYMultiLineView *multiLineView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.lineView setDatas:[self prepareDatas]];
    
}


-(NSArray *)prepareDatas{
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [datas addObject:@(arc4random_uniform(201)).stringValue];
    }
    return datas;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.multiLineView addLineWithDatas:[self prepareDatas] lineColor:[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1] animated:YES];

}

@end
