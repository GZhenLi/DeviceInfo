//
//  CQDeviceInfo.h
//  CQDeviceInfo
//
//  Created by 郭振礼 on 2017/12/13.
//  Copyright © 2017年 郭振礼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQDeviceInfo : NSObject
/*
 获取广告标识符IDFA
 */
+ (NSString *)getIDFA;
/*
 获取APP版本号
 */
+ (NSString *)getAppVersion;
/*
 获取系统版本号
 */
+ (NSString *)getSystemVersion;
/*
 获取系统名称
 */
+ (NSString *)getSystemName;
/*
 获取bundleID
 */
+ (NSString *)getBundleID;
/*
 获取APP名称
 */
+ (NSString *)getAppName;
// 获取app Build号
+ (NSString *)getAppBuild;

/*
 获取唯一标识符IDFV
 */
+ (NSString *)getIDFV;
//获取设备名称
+ (NSString *)getDeviceName;
// 获取设备的类型 e.g. iPhone Or iPod touch..
+ (NSString *)getDeviceModel;
// 获取设备的型号标识符  e.g. iPhone6,2
+ (NSString *)getDeviceModelID;

/*
 获取ip地址
 */
+ (NSString *)getIpAddress;

// 屏幕亮度
+ (NSString *)getScreenBrightness;

// 磁盘总容量
+ (NSString *)getTotalDiskCapacity;

// 磁盘未使用容量
+ (NSString *)getFreeDiskCapacity;

// 获取WiFi的SSID 也就是WiFi名称
+ (NSString *)getWifiSSID;

// 获取WiFi的BSSID 也就是Mac地址
+ (NSString *)getWifiBSSID;
// 获取SIM卡运营商
+ (NSString *)getSIMCarrierName;

@end
