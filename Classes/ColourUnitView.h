//
//  ColourUnitView.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 22/05/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ColorPickerViewController.h"

@interface ColourUnitView : UIView <ColorPickerViewControllerDelegate> {

    NSMutableString *hexCode;
    //UIButton *deleteColour;
    //UIButton *pickColour;
    //UIButton *changeColour;
    UIView *colourBlock;
    UIColor *colorSwatch;
    
}

- (id)initWithColour:(NSString*)colour rank:(int)rank andHeight:(int)height;
-(void) addChangeButton;

-(void) changeRank:(int)rank andHeight:(int)height;
-(void) changeColour:(NSString*)hexString;
-(void) changeButtonPressed;

- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color;

@end
