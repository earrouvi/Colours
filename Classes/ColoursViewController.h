//
//  ColoursViewController.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 12/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>
#import "WallpaperViewController.h"
#import "Utils.h"
#import "ColourUnitView.h"


@interface ColoursViewController : UIViewController {
	
	int nbColours;
    UIColor *firstColour;//plus besoin
	UIButton *button;
	UIView *comboView;
    UIView *hexView;//plus besoin
    UIView *buttonsView;//plus besoin
	NSMutableArray *colours;
    int change;//plus besoin

}

-(id) initWithNumberOfColours:(int)col andFirstColour:(UIColor*)first;
//---
-(void) addSaveButton;
-(void) saveButtonPressed;
-(void) addSendButton;
-(void) sendButtonPressed;
-(void) addNewButton;
-(void) newButtonPressed;
-(void) changeButtonPressed:(id)sender;
//---
-(void) generateCombo;
-(void) createColourBlock:(NSString*)hexString atIndex:(int)i withWidth:(int)width andBlank:(int)blank;
-(void) createChangeButton:(NSString*)hexString atIndex:(int)i withWidth:(int)width andBlank:(int)blank;
//---
-(void) sendEmailTo:(NSString*)to withSubject:(NSString*)subject andBody:(NSString*)body;

@end
