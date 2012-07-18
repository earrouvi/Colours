//
//  PaletteView.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 16/07/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "PaletteView.h"

@implementation PaletteView

- (id)initWithFrame:(CGRect)frame andPalette:(Palette*)pal {
    self = [super initWithFrame:frame];
    if (self) {
        int nb = [pal.colours count];
        int i = 0;
        int width = 280/nb;
        for (NSString *colour in pal.colours) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i++*width, 0, width, frame.size.height)];
            view.backgroundColor = [Utils convertHexToRGB:colour];
            [self addSubview:view];
            [view release];
        }
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width*nb, 20)];
        lab.text = pal.name;
        [lab setBackgroundColor:[UIColor underPageBackgroundColor]];
        lab.textColor = [UIColor blackColor];
        [self addSubview:lab];
        [lab release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
