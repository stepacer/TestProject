//
//  Account.h
//  TestProject
//
//  Created by ZZ on 16/1/25.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Account : NSObject

@property (nonatomic,copy) NSString *accountNo;
@property (nonatomic,readonly) CGFloat balance;

- (id)initWithAccountNo:(NSString *)account balance:(CGFloat)balance;
- (void)draw:(CGFloat)drawAmount;
- (void)deposit:(CGFloat)depositAmount;

@end
