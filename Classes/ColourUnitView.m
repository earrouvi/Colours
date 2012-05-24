//
//  ColourUnitView.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 22/05/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "ColourUnitView.h"

@implementation ColourUnitView

- (id)initWithColour:(NSString*)hexString rank:(int)rank andHeight:(int)height {
    self = [super initWithFrame:CGRectMake(0, rank, 300, height)];
    if (self) {
        // init buttons and block colour
        [colourBlock initWithFrame:CGRectMake(20, 0, 260, height)];
        colourBlock.backgroundColor = [Utils convertHexToRGB:hexString];
    }
    return self;
}

-(void) changeRank:(int)rank andHeight:(int)height {
    self.frame = CGRectMake(0, rank, 300, height);
}

-(void) changeColour:(NSString*)hexString {
    colourBlock.backgroundColor = [Utils convertHexToRGB:hexString];
}

@end
