//
//  YMScrollView.m
//  UIScrollViewDemo
//
//  Created by WangWei on 25/7/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import "YMScrollView.h"

@interface YMScrollView ()<UIScrollViewDelegate>
@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) BOOL isLast;
@end

@implementation YMScrollView

-(instancetype)initWithFrame:(CGRect)frame itemWidth:(CGFloat)itemWidth gap:(CGFloat)gap items:(NSArray *)items {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, 0, itemWidth + 20, self.frame.size.height)];
        [self addSubview:self.scrollView];
        
        
        self.scrollView.contentSize = CGSizeMake((items.count - 1) * (itemWidth + gap) + (2 * self.scrollView.frame.size.width - self.frame.size.width) + gap, 0) ;
        
        for (int i = 1; i < items.count + 1; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i * 20 + (i - 1) * itemWidth, 0, itemWidth, self.frame.size.height);
            button.backgroundColor = [UIColor greenColor];
            [self.scrollView addSubview:button];
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
        
        
    }
    
    return self;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  //  NSLog(@"scorllView");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
  //  NSLog(@"不滚动了");
    NSLog(@"conteSize = %f", scrollView.contentSize.width);
    NSLog(@"contentOffset = %f", scrollView.contentOffset.x);
}


static int i = 0;

-(void)click{
  
    NSLog(@"come here");
    NSArray *array = @[[UIColor redColor], [UIColor yellowColor]];
    self.superview.backgroundColor = array[i % 2];
    i++;
}

-(void)setItemWidth:(float)itemWidth {
    
    
    
}


@end
