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
@synthesize fix;

#pragma mark Init & building the view

- (id)initWithColour:(NSString*)hexString rank:(int)rank andHeight:(int)height {
    self = [super initWithFrame:CGRectMake(10, 0+rank*height, 290, height)];
    if (self) {
        // init buttons and block colour
        colourBlock = [[UIView alloc] initWithFrame:CGRectMake(0, height*0.05, 290, height*0.9)];
        colourBlock.backgroundColor = [Utils convertHexToRGB:hexString];

        [self addSubview:colourBlock];
        hexCode = [hexString copy];
        [self addButtons];
        
        fixView = [[UIView alloc] initWithFrame:CGRectMake(295, height*0.2, 10, 10)];
        [fixView setBackgroundColor:[UIColor redColor]];
        [self addSubview:fixView];
        [fixView setHidden:YES];
    }
    return self;
}

-(void) addButtons {
    int height = colourBlock.frame.size.height;
    
    // transparent button to fix a colour
    UIButton *fixed = [UIButton buttonWithType:UIButtonTypeCustom];
    fixed.frame = CGRectMake(20, height*0.05, 290, height*0.9);
    [fixed addTarget:self action:@selector(fixed) forControlEvents:UIControlEventTouchUpInside];
    [colourBlock addSubview:fixed];
    
    // change button
    UIButton *change = [SmallButton buttonWithFrame:CGRectMake(220, height*0.1, 30, 30)];
    //change.frame = CGRectMake(220, height*0.1, 30, 30);
    [change addTarget:self action:@selector(changeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [change setImage:[UIImage imageNamed:@"refresh_bouton90.png"] forState:UIControlStateNormal];
    [colourBlock addSubview:change];
    
    // minus button
    UIButton *minus = [SmallButton buttonWithFrame:CGRectMake(185, height*0.1, 30, 30)];
    //minus.frame = CGRectMake(185, height*0.1, 30, 30);
    [minus addTarget:self action:@selector(minusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [minus setImage:[UIImage imageNamed:@"suppr_bouton90.png"] forState:UIControlStateNormal];
    [colourBlock addSubview:minus];
    
    // picker button
    UIButton *pick = [SmallButton buttonWithFrame:CGRectMake(255, height*0.1, 30, 30)];
    //pick.frame = CGRectMake(255, height*0.1, 30, 30);
    [pick addTarget:self action:@selector(pickColour) forControlEvents:UIControlEventTouchUpInside];
    [pick setImage:[UIImage imageNamed:@"hue_bouton905.png"] forState:UIControlStateNormal];
    [colourBlock addSubview:pick];
    
    // hex code
    code = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    NSString *sharp = [NSString stringWithFormat:@"%@%@", @" #", hexCode];
    code.text = sharp;
    code.font = [UIFont systemFontOfSize:10];
    code.inputView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    code.backgroundColor = [Utils getColourFor:ColourTypeBG];
    code.textColor = [Utils getColourFor:ColourTypeFont];
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
    self.frame = CGRectMake(10, 0+rank*height, 290, height);
    colourBlock.frame = CGRectMake(0, height*0.05, 290, height*0.9);
    
    UIView *fixed = [[colourBlock subviews] objectAtIndex:0];
    [fixed setFrame:colourBlock.frame];
    for (int i=1;i<4;i++) {
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
    [code setBackgroundColor:[Utils getColourFor:ColourTypeBG]];
    [code setTextColor:[Utils getColourFor:ColourTypeFont]];
}

-(void) changeButtonPressed {
    if (!fix) {
        [self changeColour:[Utils generateColour]];
    }
}

-(void) fixed {
    // set the colour, which won't be modified until the button is pressed again
    if (!fix) {
        fix = YES;
        [fixView setHidden:NO];
    } else if (fix) {
        fix = NO;
        [fixView setHidden:YES];
    }
    
}

#pragma mark Calls to delegate

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
    [fixView release];
    [hexCode release];
    [super dealloc];
}

@end
