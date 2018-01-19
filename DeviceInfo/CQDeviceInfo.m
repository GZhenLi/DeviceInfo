//
//  CQDeviceInfo.m
//  CQDeviceInfo
//
//  Created by 郭振礼 on 2017/12/13.
//  Copyright © 2017年 郭振礼. All rights reserved.
//

#import "CQDeviceInfo.h"
#import <AdSupport/AdSupport.h>
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <mach/mach.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <objc/runtime.h>
@implementation CQDeviceInfo

/*
 获取广告标识符IDFA
 */
+ (NSString *)getIDFA{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

/*
 获取APP版本号
 */
+ (NSString *)getAppVersion{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}
/*
 获取系统版本号
 */
+ (NSString *)getSystemVersion{
    return [UIDevice currentDevice].systemVersion;
}
/*
获取系统名称
*/
+ (NSString *)getSystemName{
    return [UIDevice currentDevice].systemName;
}
/*
 获取bundleID
 */
+ (NSString *)getBundleID{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
}
/*
 获取APP名称
 */
+ (NSString *)getAppName
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
}
// 获取app Build号
+ (NSString *)getAppBuild
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
}

/*
 获取唯一标识符IDFV
 */
+ (NSString *)getIDFV{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}
/*
获取ip地址
*/
+ (NSString *)getIpAddress{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}
#pragma mark -- 用户设备信息
//获取设备名称
+ (NSString *)getDeviceName
{
    return [UIDevice currentDevice].name;
}

// 获取设备的类型 e.g. iPhone Or iPod touch..
+ (NSString *)getDeviceModel
{
    return [UIDevice currentDevice].model;
}

// 获取设备的型号标识符  e.g. iPhone6,2
+ (NSString *)getDeviceModelID
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return deviceModel;
}


#pragma mark --
// 屏幕亮度
+ (NSString *)getScreenBrightness
{
    return [NSString stringWithFormat:@"%zd",[UIScreen mainScreen].brightness * 100];
}

// 磁盘总容量
+ (NSString *)getTotalDiskCapacity
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
#pragma clang diagnostic pop
    NSString *diskTotalSize = [systemAttributes objectForKey:@"NSFileSystemSize"];
    return [NSString stringWithFormat:@"%f",[diskTotalSize floatValue]/1000/1000];
}

// 磁盘未使用容量
+ (NSString *)getFreeDiskCapacity
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
#pragma clang diagnostic pop
    NSString *diskFreeSize = [systemAttributes objectForKey:@"NSFileSystemFreeSize"];
    return  [NSString stringWithFormat:@"%f",[diskFreeSize floatValue]/1000/1000];
}
#pragma mark -- 网络

// 获取WiFi的SSID 也就是WiFi名称
+ (NSString *)getWifiSSID
{
    NSString *ssid = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil)
    {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray,0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];//Mac Name
        }
    }
    return ssid;
}

// 获取WiFi的BSSID 也就是Mac地址
+ (NSString *)getWifiBSSID
{
    NSString *macIp = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil)
    {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray,0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            macIp = [dict valueForKey:@"BSSID"];//Mac address
        }
    }
    return macIp;
}

// 获取SIM卡运营商
+ (NSString *)getSIMCarrierName
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *carrierName = networkInfo.subscriberCellularProvider.carrierName;
    //    if ([carrierName isEqualToString:@"中国移动"]) {
    //        return SIMCarrierNameChinaMobile;
    //    }
    //    else if([carrierName isEqualToString:@"中国联通"]) {
    //        return SIMCarrierNameChinaUnicon;
    //    }
    //    else if([carrierName isEqualToString:@"中国电信"]) {
    //        return SIMCarrierNameChinaTelecom;
    //    }
    //    else {
    //        return SIMCarrierNameUnknow;
    //    }
    return carrierName;
}
@end
