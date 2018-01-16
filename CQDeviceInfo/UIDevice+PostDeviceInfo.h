//
//  UIDevice+PostDeviceInfo.h
//  CQDeviceInfo
//
//  Created by 郭振礼 on 2017/12/13.
//  Copyright © 2017年 郭振礼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)(id obj);
typedef void(^failureBlock)(NSError *error);

@interface UIDevice (PostDeviceInfo)

+ (void)postDeviceInfoWithUrl:(NSString *)url success:(successBlock)success failure:(failureBlock)failure item:(NSString *)firstItem,...;

@end
