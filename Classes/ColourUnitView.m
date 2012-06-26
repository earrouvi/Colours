//
//  ColourUnitView.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 22/05/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "ColourUnitView.h"

@implementation ColourUnitView

#pragma mark Init & building the view

- (id)initWithColour:(NSString*)hexString rank:(int)rank andHeight:(int)height {
    self = [super initWithFrame:CGRectMake(20, 0+rank*height, 280, height)];
    if (self) {
        // init buttons and block colour
        colourBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 280, height-10)];
        colourBlock.backgroundColor = [Utils convertHexToRGB:hexString];
        [self addSubview:colourBlock];
        
        [self addChangeButton];
        
        hexCode = [hexString copy];
    }
    return self;
}

-(void) addChangeButton {
    UIButton *change = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    change.frame = CGRectMake(60, 10, 170, 30);
    [change setTitle:@"Change" forState:UIControlStateNormal];
    [change addTarget:self action:@selector(changeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [colourBlock addSubview:change];
}

#pragma mark -
#pragma mark Modifications

-(void) changeRank:(int)rank andHeight:(int)height {
    self.frame = CGRectMake(20, 0+rank*height, 280, height);
    colourBlock.frame = CGRectMake(0, 5, 280, height-10);
}

-(void) changeColour:(NSString*)hexString {
    colourBlock.backgroundColor = [Utils convertHexToRGB:hexString];
}

-(void) changeButtonPressed {
    [self changeColour:[Utils generateColour]];
}

#pragma mark -
#pragma mark Color Picker
- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    if (color!=colorSwatch) {
        [colorSwatch release];
        colorSwatch = [color retain];
    }
    
    [colorPicker dismissModalViewControllerAnimated:YES];
}
#pragma mark -

-(void) dealloc {
    [colourBlock release];
    [hexCode release];
    [super dealloc];
}

@end
