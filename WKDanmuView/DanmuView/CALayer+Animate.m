//
//  CALayer+Animate.m
//  WKDanmuView
//
//  Created by 王开 on 2018/7/19.
//  Copyright © 2018年 com.wk. All rights reserved.
//

#import "CALayer+Animate.h"

@implementation CALayer (Animate)
-(void)pauseAnimate
{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}
-(void)resumeAnimate
{
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}
@end
