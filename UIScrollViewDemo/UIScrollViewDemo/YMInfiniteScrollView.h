//
//  YMInfiniteScrollView.h
//  UIScrollViewDemo
//
//  Created by WangWei on 28/7/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMInfiniteScrollView : UIView
@property (nonatomic, strong) NSArray *showData;
@property (nonatomic, assign) NSTimeInterval scrollTimerInteval; // Default is 2.5s

- (instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count placeImage:(NSString *)image;
-(instancetype)initWithFrame:(CGRect)frame placeImage:(NSString *)image;

@end
