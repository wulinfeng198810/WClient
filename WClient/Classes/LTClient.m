//
//  LTClient.m
//  LTClient
//
//  Created by 吴林峰 on 16/8/4.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "LTClient.h"
#import "HttpTool/HttpTool.h"

@implementation LTClient

+ (void)down {

    NSString *savePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    savePath = [savePath stringByAppendingPathComponent:@"1.jpg"];
    
    [[HttpTool new] downLoadFromURL:[NSURL URLWithString:@"http://img2.3lian.com/2014/c7/12/d/77.jpg"] savePath:savePath progressBlock:^(float progress) {
        NSLog(@"%f",progress);
    } completion:^(id data, NSError *error) {
        ;
    }];
    
}

@end
