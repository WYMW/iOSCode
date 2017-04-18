//
//  TestViewController.m
//  Networking
//
//  Created by WangWei on 21/2/17.
//  Copyright © 2017年 BarryWang. All rights reserved.
//

#import "TestViewController.h"
#define url "http://api.rfq.mobi/gdg-api/task/getbanner.json"
#define url2 "http://api.rfq.mobi/gdg-api/comicsound/listcomic.json?start=0&size=100"


@interface TestViewController ()<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>
@property (nonnull, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSString *name;
@end

@implementation TestViewController
- (IBAction)pop:(id)sender {
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"come here TestViewController");
    // Do any additional setup after loading the view.
    self.name = @"wangwei";
    self.count = 1111;
    __weak typeof(self)weakSelf = self;
    
//   self.timer =  [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        
//        a++;
//       weakSelf.count ++;
//        NSLog(@"%d", a);
//        
//    }];
    
//    self.data = [NSMutableData data];
//
//    
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    NSURLSessionDataTask *dataTask2 = [session dataTaskWithURL:[NSURL URLWithString:@url2]];
//    NSLog(@"dataTask2 = %p", dataTask2);
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@url]];
//    NSLog(@"dataTask = %p", dataTask);
//    [dataTask2 resume];
//    [dataTask resume];
    
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
       for (int i = 0; i < 10000; i++) {
           NSLog(@"%d", i);
           NSLog(@"%ld", weakSelf.count + i);
           NSLog(@"%@",weakSelf);
           if (i == 7000) {
               [weakSelf test];
           }
       }
       
   });
    
    
}

- (void) test {
    
    NSLog(@"come here for test.....................");
}
- (id)getBlockArray
{
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            ^{NSLog(@"blk0:%d", val);},
            ^{NSLog(@"blk1:%d", val);}, nil];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"%s======= %@",__FUNCTION__, [NSThread currentThread]);
    NSLog(@"dataTask++++ = %p", dataTask);

    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSLog(@"%s======= %@",__FUNCTION__, [NSThread currentThread]);
    NSLog(@"dataTask++++++ = %p", dataTask);

    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"dataTask+++++++ = %p", task);

    NSLog(@"%s======= %@",__FUNCTION__, [NSThread currentThread]);
    
    NSLog(@"error = %@",error);
    NSLog(@"下载完成");
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dict);
    [session finishTasksAndInvalidate];
}

- (void)viewWillDisappear:(BOOL)animated {
   
    [super viewWillDisappear:animated];

}

- (void)dealloc {
  
    [self.timer invalidate];
    NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    
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
