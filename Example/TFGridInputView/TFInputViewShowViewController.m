//
//  TFInputViewShowViewController.m
//  TFGridInputView
//
//  Created by shiwei on 17/5/13.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import "TFInputViewShowViewController.h"
#import "TFGridInputView.h"

@interface TFInputViewShowViewController (){
    //输入控件
    TFGridInputView *_inputView;
    
    UIButton *_textGetButton;
}

@end

@implementation TFInputViewShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"展示";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    switch (_showType) {
        case TFInputViewShowTypeSingleLine:
            [self singleLineConfig];
            break;
            
        case TFInputViewShowTypeMultiLine:
            [self multiLineConfig];
            break;
            
        case TFInputViewShowTypeBorder:
            [self borderConfig];
            break;
            
        case TFInputViewShowTypeNoGapAndBorder:
            [self noGapAndBorderConfig];
            break;
            
        case TFInputViewShowTypeSercetInput:
            [self secretConfig];
            break;
            
        case TFInputViewShowTypeBecomeFirstResponder:
            [self firstResponderConfig];
            break;
            
        default:
            break;
    }
    
    //用这个按钮来获取输入框的文本，测试文本是否正确
    _textGetButton = [[UIButton alloc] initWithFrame:(CGRectMake(30, 70, 300, 30))];
    _textGetButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [_textGetButton setTitleColor:[UIColor darkTextColor] forState:(UIControlStateNormal)];
    [_textGetButton addTarget:self action:@selector(getInputViewText) forControlEvents:(UIControlEventTouchUpInside)];
    [_textGetButton setTitle:@"点击获取文本" forState:(UIControlStateNormal)];
    [self.view addSubview:_textGetButton];
}

-(void)singleLineConfig{
    //使用默认大小会拉大高宽，虽然设置100，但实际是6*40+(6+1)*8 = 296，参考布局规则
    _inputView = [[TFGridInputView alloc] initWithFrame:CGRectMake(30, 120, 100, 200) row:1 column:6];
    _inputView.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:_inputView];
}

-(void)multiLineConfig{
    //多行
    _inputView = [[TFGridInputView alloc] initWithFrame:CGRectMake(30, 120, 100, 200) row:3 column:6];
    
    //输入后颜色变化
    TFGridInputViewCellStyle *style = [[TFGridInputViewCellStyle alloc] init];
    style.backColor = [UIColor colorWithWhite:0.8 alpha:1];
    style.textColor = [UIColor whiteColor];
    [_inputView setStyle:style forState:(TFGridInputViewCellStateEmpty)];
    
    style.backColor = [UIColor colorWithRed:0.36 green:0.67 blue:0.9 alpha:1];
    [_inputView setStyle:style forState:(TFGridInputViewCellStateFill)];
    
    //带输入的cell高亮
    style.backColor = [UIColor redColor];
    [_inputView setStyle:style forState:(TFGridInputViewCellStateHighlight)];
    
    [self.view addSubview:_inputView];
}

-(void)borderConfig{
    //构建一个输入框
    _inputView = [[TFGridInputView alloc] initWithFrame:CGRectMake(30, 120, 100, 200) row:3 column:6];
    
    //构建一个样式，并调整各种格式
    TFGridInputViewCellStyle *style = [[TFGridInputViewCellStyle alloc] init];
    style.backColor = [UIColor colorWithWhite:0.9 alpha:1];
    style.textColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    //如果各个状态样式一致，可以只设置empty状态，它会作为缺省值使用
    [_inputView setStyle:style forState:(TFGridInputViewCellStateEmpty)];
    
    [self.view addSubview:_inputView];
    
    //设置边框和圆角
    _inputView.DIVBorderColor = [UIColor lightGrayColor];
    _inputView.DIVBorderWidth = 0.5;
}

-(void)noGapAndBorderConfig{
    //构建一个输入框
    _inputView = [[TFGridInputView alloc] initWithFrame:CGRectMake(30, 120, 100, 200) row:3 column:6];
    
    //构建一个样式，并调整各种格式
    TFGridInputViewCellStyle *style = [[TFGridInputViewCellStyle alloc] init];
    style.backColor = [UIColor colorWithWhite:0.9 alpha:1];
    style.textColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    //如果各个状态样式一致，可以只设置empty状态，它会作为缺省值使用
    [_inputView setStyle:style forState:(TFGridInputViewCellStateEmpty)];
    
    [self.view addSubview:_inputView];
    
    //设置边框和圆角
    _inputView.DIVBorderColor = [UIColor lightGrayColor];
    _inputView.DIVBorderWidth = 0.5;
    
    //设置圆角
    _inputView.DIVCornerRadius = 5;
    
    //设置布局样式
    _inputView.layoutStyle = TFGridInputViewLayoutStyleNoGap;
}

-(void)secretConfig{
    [self multiLineConfig];
    
    //样式和其他一样，只是设置secretText为YES即可
    _inputView.secretText = YES;
}

-(void)firstResponderConfig{
    [self multiLineConfig];
    
    //自动弹出输入
    [_inputView becomeFirstResponder];
    
    //代码输入部分值
    _inputView.text = @"头部的一点文字:";
}

-(void)getInputViewText{
    [_textGetButton setTitle:_inputView.text forState:(UIControlStateNormal)];
}


@end
