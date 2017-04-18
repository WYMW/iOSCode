//
//  ViewController.m
//  UIScrollViewDemo
//
//  Created by WangWei on 25/7/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import "ViewController.h"
#import "YMScrollView.h"
#import "YMInfiniteScrollView.h"
@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSUInteger imageCount;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) BOOL needReload;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YMScrollView *ymscrollView = [[YMScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 280) itemWidth:300 gap:20 items:@[@"1.png", @"2.png", @"3.png", @"4.png", @"5.png"]];
    
    [self.view addSubview:ymscrollView];
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 100)];
//    scrollView.contentSize = CGSizeMake(3 * self.view.frame.size.width, 0);
//    scrollView.pagingEnabled = YES;
//    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0.0);
//    [self.view addSubview:scrollView];
//    scrollView.backgroundColor = [UIColor yellowColor];
//    self.scrollView = scrollView;
//    scrollView.delegate = self;
//    self.lastContentOffset = scrollView.contentOffset.x;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    
////    [self addImageToScrollView];
////    
////    self.imageCount = 5;
////    
////    [self setDetaultInfo];
//    
//    YMInfiniteScrollView *scrollView = [[YMInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 300) count:3 placeImage:@"1.png"];
//    [self.view addSubview:scrollView];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        scrollView.showData = @[@"1.png", @"2.png", @"3.png", @"4.png", @"5.png"];
//
//        
//    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
