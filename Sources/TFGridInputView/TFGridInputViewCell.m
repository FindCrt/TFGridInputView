//
//  TFGridInputViewCell.m
//  TFGridInputView
//
//  Created by wei shi on 2017/5/9.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import "TFGridInputViewCell.h"



@interface TFGridInputViewCell (){
    UILabel *_textLabel;
    UIImageView *_backImageView;
    
    
}

@end

@implementation TFGridInputViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.hidden = YES;
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backImageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_textLabel];
    }
    
    return self;
}



#pragma mark -

-(void)setText:(NSString *)text{
    _textLabel.text = text;
}

-(void)setStyle:(TFGridInputViewCellStyle *)style{
    _style = style;
    _textLabel.font = style.font;
    _textLabel.textColor = style.textColor;
    
    if (style.backImage) {
        _backImageView.image = style.backImage;
    }else{
        self.backgroundColor = style.backColor;
    }
}

@end
