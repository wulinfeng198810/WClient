//
//  HttpTool.h
//  02-文件上传下载工具抽取
//
//  Created by Vincent_Guo on 14-6-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProgressBlock)(float progress);
typedef void (^CompletionBlock)(id data, NSError *error);

@interface HttpTool : NSObject


/**
 下载数据
 */
- (void)downLoadFromURL:(NSURL *)url
              savePath:(NSString *)savePath
         progressBlock:(ProgressBlock)progressBlock
            completion:(CompletionBlock) completionBlock;

// 取消当前任务
- (void)cancel;

@end
