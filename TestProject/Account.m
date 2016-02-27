//
//  Account.m
//  TestProject
//
//  Created by ZZ on 16/1/25.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "Account.h"

@implementation Account{
    NSCondition *_condition;
    BOOL _flag;
}

-(id)initWithAccountNo:(NSString *)account balance:(CGFloat)balance{
    self = [super init];
    if (self) {
        _condition = [[NSCondition alloc] init];
        _accountNo = account;
        _balance = balance;
    }
    return self;
}

- (void)draw:(CGFloat)drawAmount{
//    @synchronized(self){
//        if (self.balance >= drawAmount) {
//            NSLog(@"%@取钱成功！吐出钞票%g",[[NSThread currentThread] name],drawAmount);
//            [NSThread sleepForTimeInterval:0.001];
//            _balance = _balance - drawAmount;
//            NSLog(@"余额为：%g",_balance);
//        }else{
//            NSLog(@"%@余额不足",[[NSThread currentThread] name]);
//        }
//    }
    
    [_condition lock];
    if (!_flag) {
        [_condition wait];
    }else{
        NSLog(@"%@取钱%g",[[NSThread currentThread] name],drawAmount);
        _balance -= drawAmount;
        NSLog(@"账户余额为：%g",_balance);
        _flag = NO;
        [_condition broadcast];
    }
    [_condition unlock];
}

- (void)deposit:(CGFloat)depositAmount{
    [_condition lock];
    if (_flag) {
        [_condition wait];
    }else{
        NSLog(@"%@存钱%g",[[NSThread currentThread] name],depositAmount);
        _balance += depositAmount;
        NSLog(@"账户余额为：%g",_balance);
        _flag = YES;
        [_condition broadcast];
    }
    [_condition unlock];
}

@end
