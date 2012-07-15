//
//  ColourUnitView.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 22/05/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "ColourUnitView.h"

@implementation ColourUnitView

@synthesize delegate;
@synthesize hexCode;

#pragma mark Init & building the view

- (id)initWithColour:(NSString*)hexString rank:(int)rank andHeight:(int)height {
    self = [super initWithFrame:CGRectMake(20, 0+rank*height, 280, height)];
    if (self) {
        // init buttons and block colour
        colourBlock = [[UIView alloc] initWithFrame:CGRectMake(0, height*0.05, 280, height*0.9)];
        colourBlock.backgroundColor = [Utils convertHexToRGB:hexString];
        [self addSubview:colourBlock];
        hexCode = [hexString copy];
        [self addButtons];
    }
    return self;
}

-(void) addButtons {
    int height = colourBlock.frame.size.height;
    int bottom = colourBlock.frame.origin.y+colourBlock.frame.size.height;
    
    // change button
    UIButton *change = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    change.frame = CGRectMake(100, height*0.2, 80, 20);
    [change setTitle:@"Change" forState:UIControlStateNormal];
    [change addTarget:self action:@selector(changeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [colourBlock addSubview:change];
    
    // minus button
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    minus.frame = CGRectMake(30, height*0.2, 20, 20);
    [minus setTitle:@"-" forState:UIControlStateNormal];
    [minus addTarget:self action:@selector(minusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [colourBlock addSubview:minus];
    
    // picker button
    UIButton *pick = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pick.frame = CGRectMake(230, height*0.2, 20, 20);
    [pick setTitle:@"P" forState:UIControlStateNormal];
    [pick addTarget:self action:@selector(pickColour) forControlEvents:UIControlEventTouchUpInside];
    [colourBlock addSubview:pick];
    
    // hex code
    code = [[UITextField alloc] initWithFrame:CGRectMake(0, bottom-19, 70, 15)];
//    code.editable = NO;
//    code.scrollEnabled = NO;
//    BOOL luc = [code canBecomeFirstResponder];
//    NSLog(@"%d",luc);
    NSString *sharp = [NSString stringWithFormat:@"%@%@", @" #", hexCode];
    code.text = sharp;
    code.font = [UIFont systemFontOfSize:14];
    code.inputView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    code.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    code.textColor = [UIColor whiteColor];
    [colourBlock addSubview:code];
}

#pragma mark -
#pragma mark Modifications

-(void) changeRank:(int)rank andHeight:(int)height {
    self.frame = CGRectMake(20, 0+rank*height, 280, height);
    colourBlock.frame = CGRectMake(0, height*0.05, 280, height*0.9);
    
    int bottom = colourBlock.frame.origin.y+colourBlock.frame.size.height;
    for (int i=0;i<3;i++) {
        UIView *v = [[colourBlock subviews] objectAtIndex:i];
        [v setFrame:CGRectMake(v.frame.origin.x, height*0.2, v.frame.size.width, 20)];
    }
    UIView *v = [[colourBlock subviews] objectAtIndex:3];
    [v setFrame:CGRectMake(0, bottom-19, 70, 15)];
}

-(void) changeColour:(NSString*)hexString {
    colourBlock.backgroundColor = [Utils convertHexToRGB:hexString];
    [hexCode release];
    hexCode = [hexString copy];
    NSString *sharp = [NSString stringWithFormat:@"%@%@", @"#", hexCode];
    code.text = sharp;
}

-(void) changeButtonPressed {
    [self changeColour:[Utils generateColour]];
}

-(void) minusButtonPressed {
    [delegate didClickOnDelete:self];
}

-(void) pickColour {
    [delegate didClickOnColorPicker:self];
}

#pragma mark -
#pragma mark Color Picker

// useless now
- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    if (color!=colorSwatch) {
        [colorSwatch release];
        colorSwatch = [color retain];
    }
    
    [colorPicker dismissModalViewControllerAnimated:YES];
}
#pragma mark -

-(void) dealloc {
    [code release];
    [colourBlock release];
    [hexCode release];
    [super dealloc];
}

@end
