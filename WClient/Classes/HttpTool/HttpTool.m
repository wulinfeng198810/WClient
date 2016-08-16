//
//  HttpTool.m
//  02-文件上传下载工具抽取
//
//  Created by Vincent_Guo on 14-6-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HttpTool.h"

#import <AFNetworking/AFNetworking.h>

#define kTimeOut 1.0

@interface HttpTool()
{
    //下载
    ProgressBlock _dowloadProgressBlock;
    CompletionBlock _downladCompletionBlock;
    NSString *_savePath;
    
    
    //上传
    ProgressBlock _uploadProgressBlock;
    CompletionBlock _uploadCompletionBlock;
    
    NSURLSessionDownloadTask *_downloadTask;
}

@end


@implementation HttpTool

#pragma mark - 下载

-(void)downLoadFromURL:(NSURL *)url
              savePath:(NSString *)savePath
         progressBlock:(ProgressBlock)progressBlock
            completion:(CompletionBlock)completionBlock {
    
    if ( !url ) {
        return;
    }
    
    __block ProgressBlock dowloadProgressBlock = [progressBlock copy];
    __block CompletionBlock downladCompletionBlock = [completionBlock copy];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:savePath] ) {
        if ( downladCompletionBlock ) {
            downladCompletionBlock(@"Download Successed!", nil);
        }
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    
    AFHTTPSessionManager *afManager = [AFHTTPSessionManager manager];
    afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _downloadTask  = [afManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if ( dowloadProgressBlock ) {
            CGFloat progress = downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            dowloadProgressBlock(progress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        NSError *error = nil;
        if(![fileManager fileExistsAtPath:[savePath stringByDeletingLastPathComponent]]){
            [fileManager createDirectoryAtPath:[savePath stringByDeletingLastPathComponent]
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:&error];
        }
        return [NSURL fileURLWithPath:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if ( !downladCompletionBlock ) {
            return;
        }
        if ( !error  ) {
            downladCompletionBlock(@"Download Successed!", nil);
        } else {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:savePath error:nil];
            
            downladCompletionBlock(nil, error);
        }
    }];
    
    [_downloadTask resume];
}

- (void)cancel
{
    if ( _downloadTask ) {
        [_downloadTask cancel];
        _downloadTask = nil;
    }
}

@end
