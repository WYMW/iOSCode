//
//  ViewController.m
//  tableViewDemo
//
//  Created by WangWei on 11/4/17.
//  Copyright © 2017年 rehulu. All rights reserved.
//

#import "ViewController.h"
#import "AIDownload.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AIDownload *download = [[AIDownload alloc] init];
    [download startDownload];
    
}

- (NSDictionary *)convertToDictionary:(NSData *)data {
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (receiveStr) {
        
        NSString *subString = [receiveStr substringFromIndex:1];
        subString = [subString substringToIndex:subString.length - 1];
        for (NSString *item in [subString componentsSeparatedByString:@","]) {
            
            NSArray *array = [item componentsSeparatedByString:@":"] ;
               
                if ([array count] == 2) {
                    
                    
                    NSString *name = array[0];
                    if ([name hasPrefix:@"\""]) {
                        name = [name substringFromIndex:1];
                        name = [name substringToIndex:name.length - 1];
                    }
                    
                    NSString *object = array[1];
                    if ([object hasPrefix:@"\""]) {
                      object =   [object substringFromIndex:1];
                       object =  [object substringToIndex:object.length - 1];
                    }
                    
                    

                    
                    [dict setObject:object forKey:name];
                }
            }
        }
    return  dict.copy ;

    
    }
    


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

- (IBAction)click:(id)sender {
    
    CGFloat height = self.headView.frame.size.height;
    
    if (height == 0) {
        height = 100;
    } else {
        height = 0;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        

        
        self.headView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        
    } completion:^(BOOL finished) {
        
        [self.tableView setTableHeaderView:self.headView];

    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//   
    if (scrollView.contentOffset.y < 0) {
        
        NSLog(@"contentOffSetY = %f",scrollView.contentOffset.y);
        self.headView.frame = CGRectMake(scrollView.contentOffset.y, 0, self.view.frame.size.width, 100 - scrollView.contentOffset.y);
        
        [self.tableView beginUpdates];
        [self.tableView setTableHeaderView:self.headView];
        [self.tableView endUpdates];
        
        
        NSLog(@"%@",NSStringFromCGRect(self.headView.frame));
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
