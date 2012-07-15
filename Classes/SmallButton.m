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

-(void) makeButtonOfType:(int)type {
    switch (type) {
        case 0:
            //do sth
            break;
            
        default:
            break;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    int errorMargin = 30;
    CGRect largerFrame = CGRectMake(0 - errorMargin, 0 - errorMargin, self.frame.size.width + errorMargin, self.frame.size.height + errorMargin);
    return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
}

@end
