//
//  TFInputViewShowViewController.h
//  TFGridInputView
//
//  Created by shiwei on 17/5/13.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TFInputViewShowType){
    TFInputViewShowTypeSingleLine,      //单行
    TFInputViewShowTypeMultiLine,       //多行
    TFInputViewShowTypeBorder,          //边框
    TFInputViewShowTypeNoGapAndBorder,   //cell无间隙且带边框
    TFInputViewShowTypeSercetInput,     //密码输入
    TFInputViewShowTypeBecomeFirstResponder     //一进页面就弹出输入
};

@interface TFInputViewShowViewController : UIViewController

@property (nonatomic, assign) TFInputViewShowType showType;

@end
