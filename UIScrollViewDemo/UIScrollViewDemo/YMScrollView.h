//
//  YMScrollView.h
//  UIScrollViewDemo
//
//  Created by WangWei on 25/7/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomScrollView.h"


@interface YMScrollView : UIView
@property (nonatomic, strong) CustomScrollView *scrollView;

-(instancetype)initWithFrame:(CGRect)frame itemWidth:(CGFloat)itemWidth gap:(CGFloat)gap items:(NSArray *)items;
@end
