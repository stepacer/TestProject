//
//  Person.m
//  TestProject
//
//  Created by ZZ on 16/2/10.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "Person.h"

@implementation Person{
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"您设置的key:【%@】并不存在",key);
    NSLog(@"您尝试设置的value为:%@",value);
}

- (id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"您访问的key:【%@】并不存在",key);
    
    return nil;
}

- (void)setNilValueForKey:(NSString *)key{
    if ([key isEqualToString:@"age"]) {
        _age = 0;
    }else{
        [super setNilValueForKey:key];
    }
}

@end
