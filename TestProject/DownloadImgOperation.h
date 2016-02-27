//
//  DownloadImgOperation.h
//  TestProject
//
//  Created by ZZ on 16/2/5.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownloadImgOperation : NSOperation

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,retain) UIImageView *imageView;

- (id)initWith:(NSURL *)url imageView:(UIImageView *)imageView;

@end
