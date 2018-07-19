//
//  WKDanmuModel.h
//  WKDanmuView
//
//  Created by 王开 on 2018/7/19.
//  Copyright © 2018年 com.wk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKDanmuModelProtocol.h"
@interface WKDanmuModel : NSObject<WKDanmuModelProtocol>
//**弹幕的开始时间*/
@property (nonatomic, assign) NSTimeInterval beginTime;
//**弹幕的存活时间*/
@property (nonatomic, assign) NSTimeInterval liveTime;

//内容
@property (nonatomic, copy) NSString *content;
@end
