//
//  CLMBProgressHUD+CLAnimation.h
//  MBProgress_使用
//
//  Created by JmoVxia on 2017/11/8.
//  Copyright © 2017年 sunshine. All rights reserved.
//

#import "CLMBProgressHUD.h"

typedef void (^CLCompletionBlock)(void);


@interface CLMBProgressHUD (CLAnimation)

+ (void)drawErrorViewWithText:(NSString *)text view:(UIView *)view completionBlock:(CLCompletionBlock)completionBlock;
+ (void)drawRightViewWithText:(NSString *)text view:(UIView *)view completionBlock:(CLCompletionBlock)completionBlock;
+ (CLMBProgressHUD *)drawRoundLoadingView:(NSString *)tex view:(UIView *)view;
@end
