//
//  RootViewController.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 12/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "WallpaperViewController.h"
#import "ColourUnitView.h"

@interface RootViewController : UIViewController {
	
	int nbColours;
	UIView *comboView;
	NSMutableArray *colours;
    UIColor *colorSwatch;
    
}

-(void) addSaveButton;
-(void) saveButtonPressed;
-(void) addNewButton;
-(void) newButtonPressed;
-(void) addPlusButton;
-(void) plusButtonPressed;
-(void) addMinusButtonAtY:(int)y;
-(void) minusButtonPressed;
//---
-(void) generateCombo;
-(void) createColourBlock:(NSString*)hexString atIndex:(int)i withHeight:(int)height;
-(void) comboLayout;
//---
-(void) writeEmail;
-(void) sendEmailTo:(NSString*)to withSubject:(NSString*)subject andBody:(NSString*)body;

@end
