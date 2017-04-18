//
//  ViewController.m
//  AVFoudationDemo
//
//  Created by WangWei on 17/2/17.
//  Copyright © 2017年 WangWei. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:@"http://fs.refanqie.com/Team.mp4"] options:nil];
    
    NSArray *keys = @[@"duration"];
    
    NSError *error = nil;
    
    AVKeyValueStatus traceStatus = [asset statusOfValueForKey:@"duration" error:&error];
    NSLog(@"%ld", traceStatus);
    
    
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        
        NSError *error = nil;
        NSLog(@"%lld", asset.duration.value / asset.duration.timescale);
        AVKeyValueStatus traceStatus = [asset statusOfValueForKey:@"duration" error:&error];
        NSLog(@"%ld", traceStatus);
        
    }];
    
    UIImage *image =  [self getThumbnail:asset];
    self.thumbnail.image = image;
    


    
}

- (UIImage *)getThumbnail:(AVURLAsset *)asset {
  
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count == 0) {
        return  nil;
    }
    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    Float64 durationSecond = CMTimeGetSeconds([asset duration]);
    CMTime midpoint = CMTimeMakeWithSeconds(durationSecond / 2, 600);
    NSError *error;
    CMTime actualTime;
    
    CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
    NSString *actualTimeString = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
    NSString *requestedTimeString = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, midpoint));
    NSLog(@"Got halfWayImage: Asked for %@, got %@", requestedTimeString, actualTimeString);
    
    UIImage *image = [UIImage imageWithCGImage:halfWayImage];
    // Do something interesting with the image.
    CGImageRelease(halfWayImage);
    
    return image;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
