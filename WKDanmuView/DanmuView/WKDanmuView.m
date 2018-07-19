//
//  WKDanmuView.m
//  WKDanmuView
//
//  Created by 王开 on 2018/7/18.
//  Copyright © 2018年 com.wk. All rights reserved.
//

#import "WKDanmuView.h"
#import "CALayer+Animate.h"

#define   kClockSec      0.1
#define   kDandaoCount   5

@interface WKDanmuView()
{
    BOOL _isPause;          //为了防止没有销毁掉定时器
}
@property (nonatomic, weak) NSTimer *clock;

@property (nonatomic, strong) NSMutableArray *laneWaitTimes;
@property (nonatomic, strong) NSMutableArray *laneLeftTimes;     //跑到最后所要的时间

@property (nonatomic, strong) NSMutableArray *danmuViews;
@end
@implementation WKDanmuView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)click:(UITapGestureRecognizer *)tap
{
    //其实真个的动画，弹幕的移动只是layer层的移动，所以只要拿到弹幕的layer层就行了。
    CGPoint point = [tap locationInView:tap.view];
    for (UIView *danmuview in self.danmuViews) {
        CGRect frame = danmuview.layer.presentationLayer.frame;
        BOOL isContain =  CGRectContainsPoint(frame, point);
        if (isContain) {
            if ([self.delegate respondsToSelector:@selector(danmuViewDidClick:at:)]) {
                [self.delegate danmuViewDidClick:danmuview at:point];
            }
            break;
        }
    }
    UIView *tapView = self.danmuViews.firstObject;
    NSStringFromCGRect(tapView.layer.presentationLayer.frame);
}
#pragma mark - 接口
-(void)pause
{
    _isPause = YES;
    [[self.danmuViews valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(pauseAnimate)];
    [self.clock invalidate];
    self.clock = nil;
}

-(void)resume
{
    _isPause = NO;
    [[self.danmuViews valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(resumeAnimate)];
    [self clock];
}
#pragma mark - 私有方法
-(void)checkAndBiu
{
    if (_isPause) {
        return;
    }
    //实时更新弹道记录的时间信息
    for (int i = 0; i < kDandaoCount; i++) {
        double waitValue = [self.laneWaitTimes[i] doubleValue] -kClockSec;
        if (waitValue <= 0.0) {
            waitValue = 0.0;
        }
        self.laneWaitTimes[i] = @(waitValue);
        
        double leftValue = [self.laneLeftTimes[i] doubleValue] -kClockSec;
        if (leftValue <= 0.0) {
            leftValue = 0.0;
        }
        self.laneLeftTimes[i] = @(leftValue);
    }
    
    //排序
    [self.models sortUsingComparator:^NSComparisonResult(id<WKDanmuModelProtocol>_Nonnull obj1, id<WKDanmuModelProtocol>_Nonnull obj2) {
        if (obj1.beginTime < obj2.beginTime) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    //检测模型数组里的模型，是否可以发射 如果可以直接发射
    NSMutableArray *deleteModels = [NSMutableArray array];
    for (id<WKDanmuModelProtocol>model in self.models) {
        //1.检测开始时间是否有到达
        NSTimeInterval beginTime = model.beginTime;
        NSTimeInterval currentTime = self.delegate.currentTime;
        //通过不了就结束循环
        if (beginTime > currentTime) {
            break;
        }
        
        //发送时间已经到了
        //2.检测碰撞(如果已经发送，那么下次执行的时候就把这些符合的删掉)
        BOOL result = [self checkBoomAndBiuWith:model];
        if (result) {
            [deleteModels addObject:model];
        }
    }
    
    [self.models removeObjectsInArray:deleteModels];
    
}
- (BOOL)checkBoomAndBiuWith:(id<WKDanmuModelProtocol>)model
{
    CGFloat danDaoH = self.frame.size.height/kDandaoCount;
    //遍历所有的弹道，在弹道里，进行检测（检测开始碰撞，检测，结束碰撞）
    for (int i = 0; i < kDandaoCount; i++) {
        //1.获取该弹道的绝对等待时间
        NSTimeInterval waitTime = [self.laneWaitTimes[i] doubleValue];
        if (waitTime > 0.0) {
            continue;
        }
        
        //2.绝对等待时间没有，可以发射，如果你发射了，会不会，与前面一个弹幕试图产生碰撞
        UIView *danmuView = [self.delegate danmuViewWithModel:model];
        NSTimeInterval leftTime = [self.laneLeftTimes[i] doubleValue];
        double speed = (danmuView.frame.size.width + self.frame.size.width)/model.liveTime;
        double distance = leftTime*speed;
        if (distance > self.frame.size.width) {
            continue;
        }
        
        [self.danmuViews addObject:danmuView];
        
        //重置数据
        self.laneWaitTimes[i] = @(danmuView.frame.size.width/speed);
        self.laneLeftTimes[i] = @(model.liveTime);
        
        //3.弹幕可以发射
        //先把弹幕试图加在弹幕背景里
        CGRect frame = danmuView.frame;
        frame.origin = CGPointMake(self.frame.size.width, danDaoH*i);
        danmuView.frame = frame;
        [self addSubview:danmuView];
        
        [UIView animateWithDuration:model.liveTime delay:0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             CGRect frame = danmuView.frame;
                             frame.origin.x = -danmuView.frame.size.width;
                             danmuView.frame = frame;
                             [self addSubview:danmuView];
                         } completion:^(BOOL finished) {
                             [danmuView removeFromSuperview];
                             [self.danmuViews removeObject:danmuView];
                         }];
        return YES;
    }
    //如果没有碰撞，还要发射
    return NO;
}

#pragma mark - 声明周期方法
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self clock];
    //不让超出界面的展示出来
    self.layer.masksToBounds = YES;
}
-(void)dealloc
{
    [self.clock invalidate];
    self.clock = nil;
}
#pragma mark set get
-(NSMutableArray *)models
{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

-(NSTimer *)clock
{
    if (!_clock) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:kClockSec target:self selector:@selector(checkAndBiu) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _clock = timer;
    }
    return _clock;
}

-(NSMutableArray *)laneWaitTimes
{
    if (!_laneWaitTimes) {
        _laneWaitTimes = [NSMutableArray arrayWithCapacity:kDandaoCount];
        for (int i = 0; i < kDandaoCount; i++) {
            _laneWaitTimes[i] = @0.0;
        }
    }
    return _laneWaitTimes;
}

-(NSMutableArray *)laneLeftTimes
{
    if (!_laneLeftTimes) {
        _laneLeftTimes = [NSMutableArray arrayWithCapacity:kDandaoCount];
        for (int i = 0; i < kDandaoCount; i++) {
            _laneLeftTimes[i] = @0.0;
        }
    }
    return _laneLeftTimes;
}

-(NSMutableArray *)danmuViews
{
    if (!_danmuViews) {
        _danmuViews = [NSMutableArray array];
    }
    return _danmuViews;
}
@end
