//
//  Person.h
//  TestProject
//
//  Created by ZZ on 16/2/10.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject{
    @package
    NSString *_name;
    NSString *name;
}

@property (nonatomic) NSString *gender;
@property (nonatomic,assign) int age;

@end
