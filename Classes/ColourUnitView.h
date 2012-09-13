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
#import "SmallButton.h"

@class ColourUnitView;

@protocol ColourUnitViewDelegate <NSObject>

-(void) didClickOnDelete:(ColourUnitView*)unit;
-(void) didClickOnColorPicker:(ColourUnitView*)unit;

@end

@interface ColourUnitView : UIView {

    id<ColourUnitViewDelegate> delegate;
    
    NSMutableString *hexCode;
    UIView *colourBlock;
    UITextField *code;
    SmallButton *fixed;
    
    Boolean fix;
    
}

@property(assign) id<ColourUnitViewDelegate> delegate;
@property(retain) NSMutableString *hexCode;
@property(assign) Boolean fix;

- (id)initWithColour:(NSString*)colour rank:(int)rank andHeight:(int)height;
-(void) addButtons;

-(void) changeRank:(int)rank andHeight:(int)height;
-(void) changeColour:(NSString*)hexString;
-(void) update;
-(void) changeButtonPressed;
-(void) fixed;

-(void) minusButtonPressed;
-(void) pickColour;

@end
