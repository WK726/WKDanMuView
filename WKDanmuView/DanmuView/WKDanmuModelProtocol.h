//
//  WKDanmuModelProtocol.h
//  WKDanmuView
//
//  Created by 王开 on 2018/7/18.
//  Copyright © 2018年 com.wk. All rights reserved.
//

//用协议来写是为了能够方便扩展不同的数据模型
#import <Foundation/Foundation.h>

@protocol WKDanmuModelProtocol <NSObject>
@required
@property (nonatomic, readonly) NSTimeInterval beginTime;
@property (nonatomic, readonly) NSTimeInterval liveTime;
@end
