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
    
    // change button
    UIButton *change = [UIButton buttonWithType:UIButtonTypeCustom];
    change.frame = CGRectMake(200, height*0.1, 30, 30);
    [change addTarget:self action:@selector(changeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [change setImage:[UIImage imageNamed:@"refresh_bouton90.png"] forState:UIControlStateNormal];
    [colourBlock addSubview:change];
    
    // minus button
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    minus.frame = CGRectMake(160, height*0.1, 30, 30);
    [minus addTarget:self action:@selector(minusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [minus setImage:[UIImage imageNamed:@"suppr_bouton90.png"] forState:UIControlStateNormal];
    [colourBlock addSubview:minus];
    
    // picker button
    UIButton *pick = [UIButton buttonWithType:UIButtonTypeCustom];
    pick.frame = CGRectMake(240, height*0.1, 30, 30);
    [pick addTarget:self action:@selector(pickColour) forControlEvents:UIControlEventTouchUpInside];
    [pick setImage:[UIImage imageNamed:@"hue_bouton904.png"] forState:UIControlStateNormal];
    [colourBlock addSubview:pick];
    
    // hex code
    code = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    NSString *sharp = [NSString stringWithFormat:@"%@%@", @" #", hexCode];
    code.text = sharp;
    code.font = [UIFont systemFontOfSize:10];
    code.inputView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    code.backgroundColor = [Utils getColorFor:ColourTypeBG];
    code.textColor = [Utils getColorFor:ColourTypeFont];
    // 90° rotation
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
    code.transform = transform;
    CGRect frame = CGRectMake(0, -1, 20, height+2);
    code.frame = frame;
    code.textAlignment = UITextAlignmentCenter;
    [colourBlock addSubview:code];
}

#pragma mark -
#pragma mark Modifications

-(void) changeRank:(int)rank andHeight:(int)height {
    self.frame = CGRectMake(20, 0+rank*height, 280, height);
    colourBlock.frame = CGRectMake(0, height*0.05, 280, height*0.9);
    
    for (int i=0;i<3;i++) {
        UIView *v = [[colourBlock subviews] objectAtIndex:i];
        [v setFrame:CGRectMake(v.frame.origin.x, height*0.1, 30, 30)];
    }
    [code setFrame:CGRectMake(0, -1, 20, height+2)];
}

-(void) changeColour:(NSString*)hexString {
    colourBlock.backgroundColor = [Utils convertHexToRGB:hexString];
    [hexCode release];
    hexCode = [hexString copy];
    NSString *sharp = [NSString stringWithFormat:@"%@%@", @"#", hexCode];
    code.text = sharp;
}

-(void) update {
    [code setBackgroundColor:[Utils getColorFor:ColourTypeBG]];
    [code setTextColor:[Utils getColorFor:ColourTypeFont]];
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

-(void) dealloc {
    [code release];
    [colourBlock release];
    [hexCode release];
    [super dealloc];
}

@end
