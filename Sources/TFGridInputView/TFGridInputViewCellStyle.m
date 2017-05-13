//
//  TFGridInputViewCellStyle.m
//  TFGridInputView
//
//  Created by wei shi on 2017/5/10.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import "TFGridInputViewCellStyle.h"

@implementation TFGridInputViewCellStyle

-(instancetype)init{
    if (self = [super init]) {
        _font = [UIFont systemFontOfSize:17];
        _textColor = [UIColor darkTextColor];
        _backColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    TFGridInputViewCellStyle *copyItem = [[TFGridInputViewCellStyle allocWithZone:zone]init];
    copyItem.backColor = self.backColor;
    copyItem.backImage = self.backImage;
    copyItem.font = self.font;
    copyItem.textColor = self.textColor;
    
    return copyItem;
}

@end
