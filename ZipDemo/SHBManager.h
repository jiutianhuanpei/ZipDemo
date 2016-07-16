//
//  SHBManager.h
//  ZipDemo
//
//  Created by shenhongbang on 16/7/16.
//  Copyright © 2016年 中移(杭州)信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHBManager : NSObject

+ (SHBManager *)defaultManager;

/**
 *  解压缩目的目录
 */
@property (nonatomic, copy) NSString    *destinationPath;


/**
 *  解压缩文件
 *
 *  @param urlString 文件的下载url
 *  @param complete  结果回调
 */
- (void)unzipUrlStr:(NSString *)urlString complete:(void(^)(NSString *filePath, NSError *error))complete;


@end
