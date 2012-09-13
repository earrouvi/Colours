//
//  WallpaperViewController.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 25/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"


@interface WallpaperViewController : UIViewController {
	
	int nbColours;
	NSArray * colours;
	UIView * coloursView;
	UISegmentedControl * controlV;
	UIButton * button;
    int slideNb;

}

-(id) initWithArrayOfColours:(NSMutableArray*)col;
//---
-(void) addViewControl;
-(void) controlView;
-(void) addNumberControl;
-(void) controlNumber;
-(void) addSaveButton;
-(void) saveButtonPressed;
-(void) slideListener;
//---
-(void) createVerticalView;
-(void) createHorizontalView;
-(void) createMosaicView;
//---
-(void) alert;
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
