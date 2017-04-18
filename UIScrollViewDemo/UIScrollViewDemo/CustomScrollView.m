//
//  CustomScrollView.m
//  UIScrollViewDemo
//
//  Created by WangWei on 1/8/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
  
    if (self = [super initWithFrame:frame]) {
        
        
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.clipsToBounds = NO;
//        self.delaysContentTouches = NO;
//        self.canCancelContentTouches = YES;
        self.backgroundColor = [UIColor lightGrayColor];
                
    }
    
    return self;
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        
        for (UIView *tview in self.subviews) {
            CGPoint point1 = [tview convertPoint:point fromView:self];
            if (CGRectContainsPoint(tview.bounds, point1)) {
                view = tview;
            }
        }
        
    }
    
    return view;

}




//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
//{
//    NSLog(@"用户点击了scroll上的视图%@,是否开始滚动scroll",view);
//    //返回yes 是不滚动 scroll 返回no 是滚动scroll
//    return YES;
//}
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    
//    NSLog(@"用户点击的视图 %@",view);
//    
//    //NO scroll不可以滚动 YES scroll可以滚动
//    return NO;
//}



@end
