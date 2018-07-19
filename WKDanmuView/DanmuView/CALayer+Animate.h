//
//  CALayer+Animate.h
//  WKDanmuView
//
//  Created by 王开 on 2018/7/19.
//  Copyright © 2018年 com.wk. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Animate)
//暂停动画
-(void)pauseAnimate;
//恢复动画
-(void)resumeAnimate;
@end
