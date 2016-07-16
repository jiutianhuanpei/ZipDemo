//
//  ViewController.m
//  ZipDemo
//
//  Created by shenhongbang on 16/7/16.
//  Copyright © 2016年 中移(杭州)信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "SHBManager.h"
#import <SSZipArchive.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SHBManager *manager = [SHBManager defaultManager];
    manager.destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject] stringByAppendingPathComponent:@"bbb"];

    [manager unzipUrlStr:@"http://127.0.0.1/1122.zip" complete:^(NSString *filePath, NSError *error) {
        if (error == nil) {
            NSLog(@"filePath:%@", filePath);
        } else {
            NSLog(@"error:%@", error);
        }
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
