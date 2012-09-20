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
#import "SavedViewController.h"
// in app settings kit
#import "IASKAppSettingsViewController.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

@interface RootViewController : UIViewController <ColorPickerViewControllerDelegate, ColourUnitViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,SavedViewControllerDelegate,IASKSettingsDelegate, MFMailComposeViewControllerDelegate> {
	
	int nbColours;
	UIView *comboView;
	NSMutableArray *colours;
    UIView *minusButtons;
    UIView *pickButtons;
    ColourUnitView *colourReceiver;
    
    // view controllers - made attributes so they won't cause a memory leak
    SavedViewController *pvc;
    
    IASKAppSettingsViewController *appSettingsViewController;
    
}

-(void) addSaveButton;
-(void) addNewButton;
-(void) addPlusButton;
//---
-(void) newButtonPressed;
-(void) plusButtonPressed;
-(void) chargeButtonPressed;
-(void) alert;
-(void) alertInput;
//---
-(void) generateCombo;
-(void) generateComboFromRank:(int)rank;
-(void) createColourBlock:(NSString*)hexString atIndex:(int)i withHeight:(int)height;
-(void) comboLayout;
//---
-(void) writeEmail;
-(void) sendEmailTo:(NSString*)to withSubject:(NSString*)subject andBody:(NSString*)body andImage:(NSData*)data;
//---
- (IASKAppSettingsViewController*)appSettingsViewController;
- (void)settingDidChange:(NSNotification*)notification;

@end
