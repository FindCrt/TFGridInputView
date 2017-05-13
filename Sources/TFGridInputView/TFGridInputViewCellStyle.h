//
//  TFGridInputViewCellStyle.h
//  TFGridInputView
//
//  Created by wei shi on 2017/5/10.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFGridInputViewCellStyle : NSObject<NSCopying>

@property (nonatomic, strong) UIImage *backImage;

@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@end
