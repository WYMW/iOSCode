//
//  ThirdViewController.m
//  Networking
//
//  Created by WangWei on 25/2/17.
//  Copyright © 2017年 BarryWang. All rights reserved.
//

#import "ThirdViewController.h"

int global_count = 10;

@interface ThirdViewController ()
@property (nonatomic, copy) void(^outChar)();
@property (nonatomic, copy) NSString *name;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    __weak typeof(self) weakSelf = self;
    self.name = @"1223";
    
    self.outChar = ^{
        
        [weakSelf test];
        
        typeof(self)strongSelf = weakSelf;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf test];
        });
    };
    self.outChar();
}

- (void)test {
    
    NSLog(@"name = %@", self.name);
}

- (void)dealloc {
  
    
    NSLog(@"第三个页面已经释放了");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
