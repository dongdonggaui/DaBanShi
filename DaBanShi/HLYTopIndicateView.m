//
//  HLYTopIndicateView.m
//  Haoweidao
//
//  Created by huangluyang on 13-12-29.
//  Copyright (c) 2013年 whu. All rights reserved.
//

#import "HLYTopIndicateView.h"

#import "UIColor+Convenience.h"

@interface HLYTopIndicateView ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation HLYTopIndicateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)topIndicateWithMessage:(NSString *)theMessage
{
    HLYTopIndicateView *top = [[self alloc] initWithFrame:CGRectMake(0, 44, 320, 0)];
    top.message = theMessage;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [top addSubview:label];
    top.messageLabel = label;
    
    return top;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.backgroundColor = [UIColor colorWithRed:0xFF/255.0 green:0xC0/255.0 blue:0x94/255.0 alpha:0xFF/255.0]/* FFC094FF */;
    self.backgroundColor = [UIColor HLY_mainTintColorWithAlpha:0.8];
    self.clipsToBounds = YES;
    self.opaque = NO;
    
    self.messageLabel.frame = CGRectMake(0, 10, 320, 20);
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont boldSystemFontOfSize:15];
    self.messageLabel.text = self.message;
    self.messageLabel.textColor = [UIColor whiteColor];
}

- (void)setHeight:(CGFloat)theHeight
{
    CGRect frame = self.frame;
    frame.size.height = theHeight;
    self.frame = frame;
}

- (void)showMessage:(NSString *)theMessage
{
    self.message = theMessage;
    self.messageLabel.text = theMessage;
    [UIView animateWithDuration:0.25 animations:^{
        [self setHeight:40];
    } completion:^(BOOL finished) {
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 delay:1 options:0 animations:^{
                    [self setHeight:0];
                } completion:nil];
            });
        }
    }];
}

- (void)hide
{
    
}

@end
