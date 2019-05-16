//
//  GZTimeManager.m
//  gcd-timer
//
//  Created by 高召葛 on 2019/5/16.
//  Copyright © 2019 高召葛. All rights reserved.
//

#import "GZTimeManager.h"
static GZTimeManager * _gzTimeManager;
static dispatch_semaphore_t _semaphore;
@implementation GZTimeManager
+ (instancetype) shareGZTimeManager{
    @synchronized(self){
    if (!_gzTimeManager) {
        _gzTimeManager = [[self alloc] init];
    }
    }
    return _gzTimeManager;
}
/*  dispatch_once
 1. 解决多线程同步访问
 2. 性能高
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gzTimeManager = [super allocWithZone:zone];
        _gzTimeManager.time_dic  = [[NSMutableDictionary alloc] init];
        _semaphore = dispatch_semaphore_create(1);
    });
    return _gzTimeManager;
}

- (void) scheduledTimerWithTimeInterval:(uint64_t)interval target:(id)Target timeName:(NSString*)time_name  isAsyn:(BOOL) isAsyn repeate:(BOOL)repeate leeway:(uint64_t)leeway task:(gzBlock)block{
    
    if (!block) return;
    dispatch_queue_t queue = isAsyn ? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, leeway * NSEC_PER_SEC);
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [self.time_dic setObject:timer forKey:time_name];
    dispatch_semaphore_signal(_semaphore);
    dispatch_source_set_event_handler(timer, ^{
        block();
        if (!repeate) {
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
    
}

#pragma mark 唤醒GCD定时器
- (void) wakeUpTimer:(NSString*)time_name{
    // 加锁
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t _timer = self.time_dic[time_name];
    if (_timer) {
        dispatch_resume(_timer);
    };
    // 解锁
    dispatch_semaphore_signal(_semaphore);
}

#pragma mark 取消GCD定时器
- (void) cancellTimeWithName:(NSString*) time_name{
    // 加锁
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t _timer = self.time_dic[time_name];
    if (_timer) {
        dispatch_source_cancel(_timer);
        [self.time_dic removeObjectForKey:time_name];
    };
    // 解锁
    dispatch_semaphore_signal(_semaphore);
}

#pragma mark 暂停GCD定时器
-(void)pauseGCDTimerTask:(NSString *)time_name{
    if (time_name.length == 0) return;
    // 加锁
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t _timer = self.time_dic[time_name];
    if (_timer) {
        dispatch_suspend(_timer);
    };
    // 解锁
    dispatch_semaphore_signal(_semaphore);
}


@end
