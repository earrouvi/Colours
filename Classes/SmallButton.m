//
//  SmallButton.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 15/07/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "SmallButton.h"

@implementation SmallButton

+ (id)buttonWithFrame:(CGRect)frame {
    return [[[self alloc] initWithFrame:frame] autorelease];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // do my additional initialization here
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    int errorMargin = 10;
    CGRect largerFrame = CGRectMake(0 - errorMargin, 0 - errorMargin, self.frame.size.width + errorMargin*2, self.frame.size.height + errorMargin*2);
    return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
}

@end
