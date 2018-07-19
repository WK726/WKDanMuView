//
//  ViewController.m
//  WKDanmuView
//
//  Created by 王开 on 2018/7/18.
//  Copyright © 2018年 com.wk. All rights reserved.
//

#import "ViewController.h"
#import "DanmuView/WKDanmuView.h"
#import "WKDanmuModel.h"
@interface ViewController ()<WKDanmuViewProcotol>
@property (nonatomic, weak) WKDanmuView *danmuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WKDanmuView *danmuView = [[WKDanmuView alloc] initWithFrame:CGRectMake(100, 10, 200, 250)];
    danmuView.delegate = self;
    danmuView.backgroundColor = [UIColor orangeColor];
    self.danmuView = danmuView;
    [self.view addSubview:danmuView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    WKDanmuModel *model1 = [[WKDanmuModel alloc] init];
    model1.beginTime = 3;
    model1.liveTime = 5;
    model1.content = @"想拉就是德弗里斯拉开发动机拉升";
    
    WKDanmuModel *model2 = [[WKDanmuModel alloc] init];
    model2.beginTime = 3.2;
    model2.liveTime = 8;
    model2.content = @"想阿里斯顿肌肤";
    
    [self.danmuView.models addObject:model1];
    [self.danmuView.models addObject:model2];
}
-(NSTimeInterval)currentTime
{
    static double time = 0;
    time += 0.1;
    return time;
}

-(UIView *)danmuViewWithModel:(WKDanmuModel *)model
{
    UILabel *label = [UILabel new];
    label.text = model.content;
    [label sizeToFit];
    
    return label;
    
}

-(void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point
{
    NSLog(@"点击了弹幕--%@，%@",danmuView,NSStringFromCGPoint(point));
}


- (IBAction)pauseClick:(id)sender {
    [self.danmuView pause];
}

- (IBAction)resume:(id)sender {
    [self.danmuView resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
