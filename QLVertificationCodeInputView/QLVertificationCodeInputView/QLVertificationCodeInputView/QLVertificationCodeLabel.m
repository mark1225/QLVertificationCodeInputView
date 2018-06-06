//
//  QLVertificationCodeLabel.m
//  QLVertificationCodeInputView
//
//  Created by ql on 2018/6/6.
//  Copyright © 2018年 ql. All rights reserved.
//

#import "QLVertificationCodeLabel.h"

@implementation QLVertificationCodeLabel


- (void)setText:(NSString *)text{
    [super setText:text];
    //手动调用drawRect方法
    [self setNeedsDisplay];
}

-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth ;
    [self setNeedsDisplay];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

-(void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
    [self setNeedsDisplay];
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setH_fillColor:(UIColor *)h_fillColor {
    _h_fillColor = h_fillColor;
    [self setNeedsDisplay];
}

- (void)setInputType:(InpuViewType)inputType{
    _inputType = inputType;
    [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect {
    
    // 第一次drawRect rect的数值不正确，不知道为什么，麻烦有知道的issue下我。这里处理了一下。
    rect.size.width = rect.size.width > self.bounds.size.width ? self.bounds.size.width : rect.size.width;
    rect.size.height = rect.size.height > self.bounds.size.height ? self.bounds.size.height : rect.size.height;
    
    //计算每位验证码/密码的所在区域的宽和高
    float width = (rect.size.width - (self.numberOfVertificationCode -1) * self.spacing)/ (float)self.numberOfVertificationCode;;
    float height = rect.size.height;
    
    // 画矩形边框
    for (int i = 0; i < self.numberOfVertificationCode; i++) {
        CGRect tempRect;
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 计算每位验证码/密码的绘制区域
        if (_inputType == InpuViewTypeDefault) {
            tempRect = CGRectMake(i * (width +self.spacing) + self.lineWidth, self.lineWidth, width - self.lineWidth*2, height - self.lineWidth*2);
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
            
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:tempRect cornerRadius:self.cornerRadius];
            CGContextAddPath(context, bezierPath.CGPath);
            CGContextStrokePath(context);
        }else{
            // 底部下划线区域
            tempRect = CGRectMake(i * (width +self.spacing) + self.lineWidth, height - 2, width - self.lineWidth*2,2);
        }
        
        if (i < self.text.length) {
            CGContextSetFillColorWithColor(context,self.h_fillColor.CGColor);
            CGContextFillRect(context , tempRect);
        }else{
            CGContextSetFillColorWithColor(context,self.fillColor.CGColor);
            CGContextFillRect(context , tempRect);
        }
    }
    
    // 将每位验证码/密码绘制到指定区域
    for (int i = 0; i < self.text.length; i++) {
        
        CGRect tempRect = CGRectMake(i * (width +self.spacing) +self.lineWidth, self.lineWidth, width - self.lineWidth * 2, height - self.lineWidth*2);
        // 遍历验证码/密码的每个字符
        NSString *charecterString = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]];
        // 设置验证码/密码的现实属性
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        attributes[NSFontAttributeName] = self.font;
        attributes[NSForegroundColorAttributeName] = self.textColor;
        // 计算每位验证码的绘制起点
        // 计算每位验证码的在指定样式下的size
        CGSize characterSize = [charecterString sizeWithAttributes:attributes];
        CGPoint vertificationCodeDrawStartPoint = CGPointMake(CGRectGetMidX(tempRect) - characterSize.width /2, CGRectGetMidY(tempRect) - characterSize.height /2);
        // 绘制验证码
        [charecterString drawAtPoint:vertificationCodeDrawStartPoint withAttributes:attributes];
    }
    
}

@end
