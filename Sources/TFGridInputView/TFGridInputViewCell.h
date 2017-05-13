//
//  TFGridInputViewCell.h
//  TFGridInputView
//
//  Created by wei shi on 2017/5/9.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFGridInputViewCellStyle.h"

typedef struct{
    NSInteger row;
    NSInteger column;
}TFGridInputCellPosition;

typedef NS_ENUM(NSInteger, TFGridInputViewCellState){
    TFGridInputViewCellStateEmpty = 1,           //未输入内容时;如果其他状态没有设置样式，则使用它
    TFGridInputViewCellStateFill,            //输入了内容时
    TFGridInputViewCellStateHighlight,       //正在输入的那一个，类似光标作用，会覆盖empty状态
    TFGridInputViewCellStateMax              //用来计数
};



@interface TFGridInputViewCell : UIView



@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) TFGridInputCellPosition position;

@property (nonatomic, assign) TFGridInputViewCellState state;

@property (nonatomic, assign) TFGridInputViewCellStyle *style;

@end
