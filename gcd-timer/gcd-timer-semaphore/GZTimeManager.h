//
//  GZTimeManager.h
//  gcd-timer
//
//  Created by 高召葛 on 2019/5/16.
//  Copyright © 2019 高召葛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^gzBlock)(void);


@interface GZTimeManager : NSObject
@property (strong,nonatomic) NSMutableDictionary * time_dic;

+ (instancetype) shareGZTimeManager;
- (void) scheduledTimerWithTimeInterval:(uint64_t)interval target:(id)Target timeName:(NSString*)time_name  isAsyn:(BOOL) isAsyn repeate:(BOOL)repeate leeway:(uint64_t)leeway task:(gzBlock)block;
- (void) cancellTimeWithName:(NSString*) time_name;
-(void)pauseGCDTimerTask:(NSString *)time_name;
- (void) resumeTimeWithName:(NSString*) time_name;
- (void) wakeUpTimer:(NSString*)time_name;
@end

NS_ASSUME_NONNULL_END
