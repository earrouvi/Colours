//
//  RootViewController.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 12/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColoursViewController.h"
#import "ColorPickerViewController.h"
#import "Utils.h"

@interface RootViewController : UIViewController <ColorPickerViewControllerDelegate> {
	
	UIButton *button;
	UISegmentedControl *control;
	UIColor *colorSwatch;
    
}

-(void) addBorderAtY:(int)y withName:(NSString*)filename;
-(void) addNewButton;
-(void) buttonPressed;
-(void) addPickerButton;
-(void) pickerPressed;
//
- (void)colorPickerViewController:(ColorPickerViewController*)colorPicker didSelectColor:(UIColor*)color;
//
-(void) addSegmentedControl;

@end
