//
//  YMInfiniteScrollView.m
//  UIScrollViewDemo
//
//  Created by WangWei on 28/7/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import "YMInfiniteScrollView.h"
#define kItemCount 3

@interface YMInfiniteScrollView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *showScrollView;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, assign) NSUInteger currentShowIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL isPause;
@end
@implementation YMInfiniteScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
   
    if (self = [super initWithFrame:frame]) {
        
        self.itemWidth = frame.size.width;
        self.itemHeight = frame.size.height;
        self.isPause = NO;
        
        [self initUI];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count placeImage:(NSString *)image {
  
    if (self = [self initWithFrame:frame]) {
        
        NSMutableArray *placeArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < count; i ++) {
            [placeArray addObject:image];
            
        }
        self.scrollTimerInteval = 2.5;
        self.showData = placeArray.copy;
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame placeImage:(NSString *)image {
  
    return [self initWithFrame:frame count:3 placeImage:image];
}


- (void)initUI {
  
    [self addSubview:self.showScrollView];
    [self addImageViewToScrollView];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
    [self addSubview:_pageControl];
}

- (UIScrollView *)showScrollView {
  
    if (!_showScrollView) {
        
        _showScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _showScrollView.delegate = self;
        _showScrollView.contentSize = CGSizeMake(kItemCount * _itemWidth, 0);
        _showScrollView.contentOffset = CGPointMake(_itemWidth, 0);
        _showScrollView.pagingEnabled = YES;
        _showScrollView.showsHorizontalScrollIndicator = NO;
        _showScrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _showScrollView;
}

- (void)addImageViewToScrollView {
  
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, _itemHeight)];
    self.leftImageView.backgroundColor = [UIColor redColor];
    
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_itemWidth, 0, _itemWidth, _itemHeight)];
    self.centerImageView.backgroundColor = [UIColor greenColor];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * _itemWidth, 0, _itemWidth, _itemHeight)];
    self.rightImageView.backgroundColor = [UIColor blueColor];
    
    [_showScrollView addSubview:self.leftImageView];
    [_showScrollView addSubview:self.rightImageView];
    [_showScrollView addSubview:self.centerImageView];

}



- (void)setImageWithCurrentIndex:(NSInteger)currentIndex {
  
    NSAssert(self.showData.count > 0 , @"请设置显示内容");
    self.centerImageView.image = [UIImage imageNamed:self.showData[_currentShowIndex]];
    self.leftImageView.image = [UIImage imageNamed:self.showData[(_currentShowIndex - 1 + self.showData.count) % self.showData.count]];
    self.rightImageView.image = [UIImage imageNamed:self.showData[(_currentShowIndex + 1) % self.showData.count]];
    self.pageControl.currentPage = _currentShowIndex;
    
}

- (void)reloadImages {
  
    CGFloat contentOffsetX = self.showScrollView.contentOffset.x;
    if (contentOffsetX > _itemWidth) {
        
        _currentShowIndex = (_currentShowIndex + 1) % self.showData.count;
        
    } else if (contentOffsetX < _itemWidth) {
        
        _currentShowIndex =(_currentShowIndex - 1 + self.showData.count) % self.showData.count;
        
    }
    [self setImageWithCurrentIndex:_currentShowIndex];
}


-(void)createTimer {
    
    if (self.timer) {
        
        [self.timer invalidate];
        
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.scrollTimerInteval target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
    self.timer = timer;
    if (_showData.count > 0) {
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    }
}


#pragma mark getter and setter

-(void)setScrollTimerInteval:(NSTimeInterval)scrollTimerInteval {
    
    _scrollTimerInteval = scrollTimerInteval;
    [self createTimer];
}

- (void)setShowData:(NSArray *)showData {
    

    
    _showData = showData;
    

    self.showScrollView.contentOffset = CGPointMake(_itemWidth, 0);

    self.currentShowIndex = 0;
    self.pageControl.currentPage = 0;
    [self setImageWithCurrentIndex:0];
    
    self.pageControl.numberOfPages = showData.count;
    
    [self createTimer];

    
    
}



#pragma mark override UIView

-(void)didMoveToSuperview {
  
    [super didMoveToSuperview];
    if (!self.timer) {
        
        self.scrollTimerInteval = 2.5;
    }
    
}


#pragma mark UIScrollView delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   
    if (self.timer) {
        
        [self.timer setFireDate:[NSDate distantFuture]];
        self.isPause = YES;

    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self reloadImages];

    [self.showScrollView setContentOffset:CGPointMake(_itemWidth, 0)];
    
    if (self.isPause) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollTimerInteval]];
        self.isPause = NO;
    }
}

#pragma mark NSTimer target

-(void)nextPage:(NSTimer *)timer {
   
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [_showScrollView setContentOffset:CGPointMake(_showScrollView.contentOffset.x + _itemWidth, 0) animated:NO];

        
    } completion:^(BOOL finished) {
        
        [self reloadImages];
        [self.showScrollView setContentOffset:CGPointMake(_itemWidth, 0)];
    }];

    
}


@end
