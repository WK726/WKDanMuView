//
//  WKDanmuView.h
//  WKDanmuView
//
//  Created by 王开 on 2018/7/18.
//  Copyright © 2018年 com.wk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKDanmuModelProtocol.h"

@protocol WKDanmuViewProcotol <NSObject>
//不能写死只能是从外部获取
@property(nonatomic, readonly) NSTimeInterval currentTime;
-(UIView *)danmuViewWithModel:(id<WKDanmuModelProtocol>)model;
-(void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point;

@end
@interface WKDanmuView : UIView

@property(nonatomic, weak) id<WKDanmuViewProcotol> delegate;

@property(nonatomic, strong) NSMutableArray <id<WKDanmuModelProtocol>>*models;

-(void)pause;
-(void)resume;
@end
