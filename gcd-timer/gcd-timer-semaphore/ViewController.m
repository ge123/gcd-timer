//
//  ViewController.m
//  gcd-timer-semaphore
//
//  Created by 高召葛 on 2019/5/16.
//  Copyright © 2019 高召葛. All rights reserved.
//

#import "ViewController.h"
#import "GZTimeManager.h"
@interface ViewController ()

@end
static NSString * timerName = @"time1";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
}
- (IBAction)startTimer {
    [[GZTimeManager shareGZTimeManager] scheduledTimerWithTimeInterval:1 target:self timeName:timerName isAsyn:YES repeate:YES leeway:1 task:^{
        NSLog(@"我是定时任务的时间");
    }];
}

- (IBAction)pauseTimer {
    [[GZTimeManager shareGZTimeManager] pauseGCDTimerTask:timerName];
}

- (IBAction)stopTimer {
     [[GZTimeManager shareGZTimeManager] cancellTimeWithName:timerName];
}

- (IBAction)wakeUpTimer {
       [[GZTimeManager shareGZTimeManager] wakeUpTimer:timerName];
}


@end
