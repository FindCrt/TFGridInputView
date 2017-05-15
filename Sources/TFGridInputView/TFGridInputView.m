//
//  TFGridInputView.m
//  TFGridInputView
//
//  Created by wei shi on 2017/5/9.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import "TFGridInputView.h"
#import "TFGridInputViewCell.h"

#pragma mark - TFGridInputView

@interface TFGridInputView (){
    NSMutableArray *_textCells;
    CGFloat _actualSpaceX;
    CGFloat _actualSpaceY;
    
    UIKeyboardType _keyboardType;
    NSMutableDictionary *_stateStyleDic;
    
    CAShapeLayer *_borderLineLayer;
    
    
}

@property (nonatomic, strong, readonly) NSMutableString *textStore;

@end

@implementation TFGridInputView

-(instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row column:(NSInteger)column{
    if (self = [super initWithFrame:frame]) {
        
        [self customInit];
        
        self.row = row;
        self.column = column;
        
        [self setupSubViews];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self customInit];
        [self setupSubViews];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
        [self setupSubViews];
    }
    
    return self;
}

-(void)customInit{
    //default settings
    _layoutStyle = TFGridInputViewLayoutStyleDefault;
    _row = 1;
    _column = 6;
    _minSpaceX = 8;
    _minSpaceY = 8;
    _cellSize = CGSizeMake(40, 40);
    
    _stateStyleDic = [[NSMutableDictionary alloc]init];
    _highlightOnlyEditing = YES;
    
    //默认样式
    TFGridInputViewCellStyle *defaultStyle = [[TFGridInputViewCellStyle alloc] init];
    [self setStyle:defaultStyle forState:TFGridInputViewCellStateEmpty];
    
    _textCells = [[NSMutableArray alloc] init];
    _textStore = [[NSMutableString alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeFirstResponder)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showActionMenus:)];
    [self addGestureRecognizer:longPress];
}

-(void)setupSubViews{
    
    [_textCells makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_textCells removeAllObjects];
    
    if (_layoutStyle == TFGridInputViewLayoutStyleNoGap) {
        _actualSpaceX = 0;
        _actualSpaceY = 0;
    }else{
        _actualSpaceX = MAX(_minSpaceX,(self.frame.size.width - _column * _cellSize.width)/(_column+1));
        _actualSpaceY = MAX(_minSpaceY, (self.frame.size.height - _row * _cellSize.height)/(_row+1));
    }
    
    
    for (int i = 0; i<_row; i++) {
        for (int j = 0; j<_column; j++) {
            
            TFGridInputViewCell *cell = [[TFGridInputViewCell alloc] initWithFrame:CGRectMake(_actualSpaceX + (_actualSpaceX + _cellSize.width)*j, _actualSpaceY+(_actualSpaceY + _cellSize.height)*i, _cellSize.width, _cellSize.height)];
            TFGridInputCellPosition position = {i,j};
            cell.position = position;
            
            [_textCells addObject:cell];
            [self addSubview:cell];
        }
    }
}

-(void)setLayoutStyle:(TFGridInputViewLayoutStyle)layoutStyle{
    if (_layoutStyle == layoutStyle) {
        return;
    }
    _layoutStyle = layoutStyle;
    [self setNeedsLayout];
    [self drawBorders];
}

-(NSString *)text{
    return [_textStore copy];
}

-(void)setText:(NSString *)text{
    [_textStore deleteCharactersInRange:NSMakeRange(0, _textStore.length)];
    [self insertText:text];
}

-(void)setRow:(NSInteger)row{
    if (_row == row) {
        return;
    }
    _row = row;
    
    //非init时，后面重设row/column，重新布置cell
    if (_textCells != nil) {
        [self setupSubViews];
    }
}

-(void)setColumn:(NSInteger)column{
    if (_column == column) {
        return;
    }
    _column = column;
    if (_textCells != nil) {
        [self setupSubViews];
    }
}

-(void)setDIVBorderColor:(UIColor *)DIVBorderColor{
    if (_DIVBorderColor == DIVBorderColor) {
        return;
    }
    _DIVBorderColor = DIVBorderColor;
    if (_DIVBorderWidth <= 0 ) {
        return;
    }
    
    [self drawBorders];
}

-(void)setDIVBorderWidth:(CGFloat)DIVBorderWidth{
    if (_DIVBorderWidth == DIVBorderWidth) {
        return;
    }
    _DIVBorderWidth = DIVBorderWidth;
    [self drawBorders];
}

-(void)setDIVCornerRadius:(CGFloat)DIVCornerRadius{
    if (_DIVCornerRadius == DIVCornerRadius) {
        return;
    }
    _DIVCornerRadius = DIVCornerRadius;
    [self drawBorders];
}

-(void)drawBorders{
    if (_DIVBorderWidth <= 0) {
        return;
    }
    
    if (_layoutStyle == TFGridInputViewLayoutStyleNoGap) {
        
        for (TFGridInputViewCell *cell in _textCells) {
            cell.layer.borderWidth = 0;
            cell.layer.cornerRadius = 0;
        }
        
        self.layer.cornerRadius = _DIVCornerRadius;
        self.clipsToBounds = YES;
        
        if (_borderLineLayer == nil) {
            _borderLineLayer = [[CAShapeLayer alloc] init];
            _borderLineLayer.frame = self.bounds;
            [self.layer addSublayer:_borderLineLayer];
        }
        
        _borderLineLayer.lineWidth = _DIVBorderWidth;
        _borderLineLayer.strokeColor = [_DIVBorderColor CGColor];
        _borderLineLayer.fillColor = nil;
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        CGFloat totalWidth = _column*_cellSize.width;
        CGFloat totalHeight = _row*_cellSize.height;
        
        
        //内部线条
        for (int i = 1; i<_column; i++) {
            
            [path moveToPoint:CGPointMake(i*_cellSize.width, 0)];
            [path addLineToPoint:CGPointMake(i*_cellSize.width, totalHeight)];
        }
        
        for (int i = 1; i<_row; i++) {
            [path moveToPoint:CGPointMake(0, i*_cellSize.height)];
            [path addLineToPoint:CGPointMake(totalWidth, i*_cellSize.height)];
        }
        
        //边界线，避开圆角先
        //上
        _DIVBorderWidth /= 2.0;
        [path moveToPoint:CGPointMake(_DIVCornerRadius, _DIVBorderWidth)];
        [path addLineToPoint:CGPointMake(totalWidth - _DIVCornerRadius, _DIVBorderWidth)];
        
        //右
        [path moveToPoint:CGPointMake(totalWidth-_DIVBorderWidth, _DIVCornerRadius)];
        [path addLineToPoint:CGPointMake(totalWidth-_DIVBorderWidth, totalHeight-_DIVCornerRadius)];
        
        //下
        [path moveToPoint:CGPointMake(totalWidth-_DIVCornerRadius, totalHeight-_DIVBorderWidth)];
        [path addLineToPoint:CGPointMake(_DIVCornerRadius, totalHeight-_DIVBorderWidth)];
        
        //左
        [path moveToPoint:CGPointMake(_DIVBorderWidth, totalHeight-_DIVCornerRadius)];
        [path addLineToPoint:CGPointMake(_DIVBorderWidth, _DIVCornerRadius)];
        
        if (_DIVCornerRadius > 0) {
            [path addArcWithCenter:CGPointMake(_DIVBorderWidth+_DIVCornerRadius, _DIVBorderWidth+_DIVCornerRadius) radius:_DIVCornerRadius startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
            [path addArcWithCenter:CGPointMake(totalWidth-(_DIVBorderWidth+_DIVCornerRadius), _DIVBorderWidth+_DIVCornerRadius) radius:_DIVCornerRadius startAngle:M_PI_2*3 endAngle:M_PI*2 clockwise:YES];
            [path addArcWithCenter:CGPointMake(totalWidth-(_DIVBorderWidth+_DIVCornerRadius), totalHeight-(_DIVBorderWidth+_DIVCornerRadius)) radius:_DIVCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [path addArcWithCenter:CGPointMake(_DIVBorderWidth+_DIVCornerRadius, totalHeight-(_DIVBorderWidth+_DIVCornerRadius)) radius:_DIVCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        }
        
        
        //[path moveToPoint:CGPointMake(_cellSize.width, 0)];
        
        _borderLineLayer.path = path.CGPath;
        
    }else{
        for (TFGridInputViewCell *cell in _textCells) {
            cell.layer.borderColor = [_DIVBorderColor CGColor];
            cell.layer.borderWidth = _DIVBorderWidth;
            
            cell.layer.cornerRadius = _DIVCornerRadius;
            cell.clipsToBounds = YES;
        }
    }
}

/**
 1.cell大小不变，根据宽高压缩间距；如果间距小于最小间距，则以最小间距为准。
 2.如果使用最小间距，则内容可能会超出原本父视图frame,如果超出，则把父视图的大小拉伸到满足cell大小和间距
 */
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_layoutStyle == TFGridInputViewLayoutStyleNoGap) {
        _actualSpaceX = 0;
        _actualSpaceY = 0;
    }else{
        _actualSpaceX = MAX(_minSpaceX,(self.frame.size.width - _column * _cellSize.width)/(_column+1));
        _actualSpaceY = MAX(_minSpaceY, (self.frame.size.height - _row * _cellSize.height)/(_row+1));
    }
    
    for (TFGridInputViewCell *cell in _textCells) {
        NSInteger row = cell.position.row;
        NSInteger column = cell.position.column;
        
        cell.frame = CGRectMake(_actualSpaceX + (_actualSpaceX + _cellSize.width)*column, _actualSpaceY+(_actualSpaceY + _cellSize.height)*row, _cellSize.width, _cellSize.height);
        if (cell.state == 0) {
            [self changeCell:cell stateTo:(TFGridInputViewCellStateEmpty)];
        }
    }
    
    CGRect frame = self.frame;
    CGRect oldFrame = frame;
    frame.size.height = _row * _cellSize.height + (_row+1)*_actualSpaceY;
    frame.size.width = _column * _cellSize.width + (_column+1)*_actualSpaceX;
    self.frame = frame;
    
    //在调整父视图的frame后，发出通知，以便可以匹配修改
    if (!CGRectEqualToRect(frame, oldFrame)) {
        [[NSNotificationCenter defaultCenter]postNotificationName:TFGridInputViewLayoutNotification object:self];
    }
}

#pragma mark - 样式

-(void)setStyle:(TFGridInputViewCellStyle *)style forState:(TFGridInputViewCellState)state{
    [_stateStyleDic setObject:[style copy] forKey:@(state)];
}

-(TFGridInputViewCellStyle *)styleForState:(TFGridInputViewCellState)state{
    TFGridInputViewCellStyle *style = [_stateStyleDic objectForKey:@(state)];
    
    //empty状态的样式作为缺省值
    if (style == nil && state != TFGridInputViewCellStateEmpty) {
        style = [_stateStyleDic objectForKey:@(TFGridInputViewCellStateEmpty)];
    }
    return style;
}

-(void)changeCell:(TFGridInputViewCell *)cell stateTo:(TFGridInputViewCellState)state{
    cell.state = state;
    cell.style = [self styleForState:state];
}

#pragma mark - keyInput

-(BOOL)hasText{
    return _textStore.length > 0;
}

-(void)insertText:(NSString *)text{
    NSInteger breakIndex = -1;
    
    for (int i = 0; i < text.length; i++) {
        NSInteger index = i+_textStore.length;
        
        if (index >= _textCells.count) {
            breakIndex = i;
            break;
        }
        
        TFGridInputViewCell *cell = _textCells[index];
        if (_secretText) {
            cell.text = KSecretTextDefault;
        }else{
            cell.text = [text substringWithRange:NSMakeRange(i, 1)];
        }
        [self changeCell:cell stateTo:(TFGridInputViewCellStateFill)];
        
        if ([self.delegate respondsToSelector:@selector(GridInputView:didFillCell:)]) {
            [self.delegate GridInputView:self didFillCell:cell];
        }
    }
    
    //有一部分内容没有加入，截取
    if (breakIndex != -1) {
        [_textStore appendString:[text substringWithRange:NSMakeRange(0, breakIndex)]];
    }else{
        [_textStore appendString:text];
    }
    
    if (_textStore.length < _textCells.count) {
        TFGridInputViewCell *highlightCell = _textCells[_textStore.length];
        [self changeCell:highlightCell stateTo:(TFGridInputViewCellStateHighlight)];
    }
}

-(void)deleteBackward{
    
    if (_textStore.length == 0) {
        return;
    }
    
    //之前的去掉
    if (_textStore.length < _textCells.count) {
        TFGridInputViewCell *highlightCell = _textCells[_textStore.length];
        [self changeCell:highlightCell stateTo:(TFGridInputViewCellStateEmpty)];
    }

    TFGridInputViewCell *lastCell = _textCells[_textStore.length-1];
    lastCell.text = nil;
    [self changeCell:lastCell stateTo:(TFGridInputViewCellStateEmpty)];
    [_textStore deleteCharactersInRange:NSMakeRange(_textStore.length-1, 1)];
    
    if ([self.delegate respondsToSelector:@selector(GridInputView:didClearCell:)]) {
        [self.delegate GridInputView:self didClearCell:lastCell];
    }
    
    TFGridInputViewCell *highlightCell = _textCells[_textStore.length];
    [self changeCell:highlightCell stateTo:TFGridInputViewCellStateHighlight];
}

-(UIKeyboardType)keyboardType{
    return _keyboardType;
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)becomeFirstResponder{
    if (_highlightOnlyEditing && _textStore.length < _textCells.count ) {
        TFGridInputViewCell *highlightCell = _textCells[_textStore.length];
        [self changeCell:highlightCell stateTo:(TFGridInputViewCellStateHighlight)];
    }
    return [super becomeFirstResponder];
}

-(BOOL)resignFirstResponder{
    //之前的去掉
    if (_highlightOnlyEditing && _textStore.length < _textCells.count) {
        TFGridInputViewCell *highlightCell = _textCells[_textStore.length];
        [self changeCell:highlightCell stateTo:(TFGridInputViewCellStateEmpty)];
    }
   return [super resignFirstResponder];
}

#pragma mark - long press actions

-(void)showActionMenus:(UILongPressGestureRecognizer *)longPress{
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    CGPoint point = [longPress locationInView:self];
    
    [menu setTargetRect:CGRectMake(point.x, point.y, 0, 0) inView:self];
    [menu setMenuVisible:YES animated:YES];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)
        || action == @selector(paste:)) {
        return YES;
    }
    return NO;
}

-(void)copy:(id)menu{
    [UIPasteboard generalPasteboard].string = self.text;
}

-(void)paste:(id)menu{
    self.text = [UIPasteboard generalPasteboard].string;
}

@end
