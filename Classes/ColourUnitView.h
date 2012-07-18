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

@class ColourUnitView;

@protocol ColourUnitViewDelegate <NSObject>

-(void) didClickOnDelete:(ColourUnitView*)unit;
-(void) didClickOnColorPicker:(ColourUnitView*)unit;

@end

@interface ColourUnitView : UIView <ColorPickerViewControllerDelegate> {

    id<ColourUnitViewDelegate> delegate;
    
    NSMutableString *hexCode;
    UIView *colourBlock;
    UIColor *colorSwatch;
    UITextField *code;
    
}

@property(assign) id<ColourUnitViewDelegate> delegate;
@property(retain) NSMutableString *hexCode;

- (id)initWithColour:(NSString*)colour rank:(int)rank andHeight:(int)height;
-(void) addButtons;

-(void) changeRank:(int)rank andHeight:(int)height;
-(void) changeColour:(NSString*)hexString;
-(void) changeButtonPressed;
-(void) minusButtonPressed;
-(void) pickColour;

-(void) colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color;

@end
