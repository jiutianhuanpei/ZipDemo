//
//  SHBManager.m
//  ZipDemo
//
//  Created by shenhongbang on 16/7/16.
//  Copyright © 2016年 中移(杭州)信息技术有限公司. All rights reserved.
//

#import "SHBManager.h"
#import <AFNetworking.h>
#import <SSZipArchive.h>

@implementation SHBManager {
    AFHTTPSessionManager        *_manager;
}

+ (SHBManager *)defaultManager {
    static SHBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SHBManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _manager = [[AFHTTPSessionManager alloc] init];
        
    }
    return self;
}

/**
 *  下载文件
 *
 *  @param urlString 文件 url
 *  @param complete  结果回调
 */
- (void)downloadDataWithUrlStr:(NSString *)urlString complete:(void (^)(NSURL *, NSError *))complete {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionDownloadTask *downTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        return url;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error == nil) {
            if (complete) {
                complete(filePath, nil);
            }
        } else {
            if (complete) {
                complete(nil, error);
            }
        }
    }];
    
    [downTask resume];
}

- (void)unzipUrlStr:(NSString *)urlString complete:(void (^)(NSString *, NSError *))complete {
    
    [self downloadDataWithUrlStr:urlString complete:^(NSURL *fileUrl, NSError *er) {
        
        if (er != nil) {
            if (complete) {
                complete(nil, er);
            }
            return ;
        }
        
        NSString *zipPath = fileUrl.absoluteString;
        zipPath = [zipPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        
        NSString *destinationPath = self.destinationPath;
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:destinationPath]) {
            NSError *er = nil;
            [manager createDirectoryAtPath:destinationPath withIntermediateDirectories:true attributes:nil error:&er];
            
            if (er != nil) {
                if (complete) {
                    complete(nil, er);
                }
                return;
            }
        }
        
        BOOL flag = [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
        if (flag) {
            NSLog(@"true");
            if (complete) {
                complete(destinationPath, nil);
                
                /**
                 *  解压缩文件成功后自动删除 zip压缩包
                 */
                [manager removeItemAtPath:zipPath error:nil];
            }
        } else {
            NSLog(@"false");
            if (complete) {
                complete(nil, [NSError errorWithDomain:@"解压失败" code:300 userInfo:@{@"zipPath" : fileUrl}]);
            }
        }
    }];
}



#pragma mark - getter
- (NSString *)destinationPath {
    if (_destinationPath.length == 0) {
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"aaaa"];
        return path;
    }
    return _destinationPath;
}


@end
