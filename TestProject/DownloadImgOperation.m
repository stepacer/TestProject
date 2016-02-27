//
//  DownloadImgOperation.m
//  TestProject
//
//  Created by ZZ on 16/2/5.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "DownloadImgOperation.h"

@implementation DownloadImgOperation

- (id)initWith:(NSURL *)url imageView:(UIImageView *)imageView{
    self = [super init];
    if (self) {
        self.url = url;
        self.imageView = imageView;
    }
    return self;
}

- (void)main{
    NSData *data = [[NSData alloc] initWithContentsOfURL:self.url];
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }else{
        NSLog(@"下载图片出错、、、");
    }
}

@end
