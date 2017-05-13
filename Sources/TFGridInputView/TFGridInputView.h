//
//  TFGridInputView.h
//  TFGridInputView
//
//  Created by wei shi on 2017/5/9.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFGridInputViewCell.h"

#define KSecretTextDefault  @"*"
#define TFGridInputViewLayoutNotification  @"TFGridInputViewLayoutNotification"

/*
 布局规则：
 1.cell大小不会改变，根据父视图(TFGridInputView)的宽高压缩间距；如果间距小于最小间距，则以最小间距为准。
 2.如果使用最小间距，则内容可能会超出原本父视图(TFGridInputView)的frame,如果超出，则把父视图的大小拉伸到满足cell大小和间距。即frame是会被调整的。
 3.如果是TFGridInputViewLayoutStyleNoGap类型，虽然没有间隙，但cell本身大小依然可能会撑爆父视图，调整原理同上
 4.在调整父视图的frame后，发出通知TFGridInputViewLayoutNotification，以便使用它的部分可以匹配修改
 */

typedef NS_ENUM(NSInteger, TFGridInputViewLayoutStyle){
    TFGridInputViewLayoutStyleDefault,         //默认样式
    TFGridInputViewLayoutStyleNoGap            //cell之间没有间距的样式，一般和边框同时使用
};

@class TFGridInputView;
@protocol TFGridInputViewDelegate <NSObject>

@optional
-(void)GridInputView:(TFGridInputView *)inputView didFillCell:(TFGridInputViewCell *)cell;

-(void)GridInputView:(TFGridInputView *)inputView didClearCell:(TFGridInputViewCell *)cell;

@end

#pragma mark -

/**
 自定义的分散的字符输入框，可设置大小、个数以及颜色变化等
 */
@interface TFGridInputView : UIView<UIKeyInput>


/**
 使用确定的行数和列数来初始化，可以在初始化时就确定构建cell，避免重复构建，推荐使用
 @param row 行数
 @param column 列数
 */
-(instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row column:(NSInteger)column;

@property (nonatomic, weak) id<TFGridInputViewDelegate> delegate;

@property (nonatomic, copy) NSString *text;

/**
 是否使用密文显示
 */
@property (nonatomic, assign) BOOL secretText;

#pragma mark - 布局

/**
 整体布局风格
 */
@property (nonatomic, assign) TFGridInputViewLayoutStyle layoutStyle;

/**
 行数，设置会重新布局cell；默认值1
 */
@property (nonatomic, assign) NSInteger row;

/**
 行数，设置会重新布局cell；默认值6
 */
@property (nonatomic, assign) NSInteger column;



/**
 cell之间最小水平间距，默认值8
 */
@property (nonatomic, assign) CGFloat minSpaceX;

/**
 cell之间最小竖直间距，默认值8
 */
@property (nonatomic, assign) CGFloat minSpaceY;


/**
 cell的大小
 */
@property (nonatomic, assign) CGSize cellSize;

//边界颜色
@property (nonatomic, strong) UIColor * DIVBorderColor;

//边界宽度
@property (nonatomic, assign) CGFloat DIVBorderWidth;

/**
 圆角大小
 layoutStyle为默认时，每个cell都有圆角；使用NoGap样式时，只有大外框有圆角
 */
@property (nonatomic, assign) CGFloat DIVCornerRadius;

#pragma mark - cell样式

/**
 设置不同状态下的cell样式
 @param style 对应state的样式
 @param state cell的状态，具体参考枚举TFGridInputViewCellState注释
 */
-(void)setStyle:(TFGridInputViewCellStyle *)style forState:(TFGridInputViewCellState)state;

/**
 获取对应state的样式
 @param state cell的状态，具体参考枚举TFGridInputViewCellState注释
 @return 对应state的样式
 */
-(TFGridInputViewCellStyle *)styleForState:(TFGridInputViewCellState)state;

/**
 只在编辑的时候才显示高亮，退出编辑就关闭显示;默认为YES
 */
@property (nonatomic, assign) BOOL highlightOnlyEditing;

@end
