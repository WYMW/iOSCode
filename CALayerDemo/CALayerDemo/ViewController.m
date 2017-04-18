//
//  ViewController.m
//  CALayerDemo
//
//  Created by WangWei on 26/7/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, 50, 50);
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 3.0f;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 50, 50)];
    
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    
    //添加并显示
    [self.view.layer addSublayer:self.shapeLayer];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40, 300, 50, 50);
    [button.layer addSublayer: self.shapeLayer ];
    button.layer.cornerRadius = 25;

    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(increase) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


-(void)increase {
  
    self.shapeLayer.strokeStart += 0.1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
