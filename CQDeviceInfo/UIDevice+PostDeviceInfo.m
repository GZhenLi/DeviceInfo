//
//  UIDevice+PostDeviceInfo.m
//  CQDeviceInfo
//
//  Created by 郭振礼 on 2017/12/13.
//  Copyright © 2017年 郭振礼. All rights reserved.
//

#import "UIDevice+PostDeviceInfo.h"
#import "CQDeviceInfo.h"
@implementation UIDevice (PostDeviceInfo)
+ (void)postDeviceInfoWithUrl:(NSString *)url  success:(successBlock)success failure:(failureBlock)failure item:(NSString *)firstItem,...{
    NSString *other = nil;
    va_list args;
    NSMutableArray *itemArray = [NSMutableArray array];
    if(firstItem){
        if ([firstItem isEqualToString:@"all"]) {
            [itemArray addObjectsFromArray:@[@"IDFA",@"IDFV",@"AppVersion",@"SystemVersion",@"SystemName",@"BundleID",@"AppName",@"AppBuild",@"DeviceName",@"DeviceModel",@"DeviceModelID",@"IpAddress",@"ScreenBrightness",@"TotalDiskCapacity",@"FreeDiskCapacity",@"WifiSSID",@"WifiBSSID",@"SIMCarrierName"]];
        } else {
            [itemArray addObject:firstItem];
            va_start(args, firstItem);
            while((other = va_arg(args, NSString*))){
                [itemArray addObject:other];
            }
            va_end(args);
        }
        
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    NSMutableString *bodyStr = [NSMutableString new];
    for (NSInteger i = 0; i < itemArray.count; i++) {
        NSString *funcStr = [NSString stringWithFormat:@"get%@",itemArray[i]];
        SEL selector = NSSelectorFromString(funcStr);
        if (![CQDeviceInfo respondsToSelector:selector]) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:9998 userInfo:@{NSLocalizedDescriptionKey:@"Error of device information parameter"}];
            failure(error);
            return;
        }
        [bodyStr appendFormat:@"%@=%@",itemArray[i],[CQDeviceInfo performSelector:selector]];
        if (i < itemArray.count - 1) {
            [bodyStr appendString:@"&"];
        }
    }
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(error);
            return;
        }
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        success(responseDic);
    }];
    [task resume];
}
@end
