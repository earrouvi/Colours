//
//  SavedViewController.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 17/07/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"
#import "PaletteView.h"

@class SavedViewController;

@protocol SavedViewControllerDelegate <NSObject>

-(void) controller:(SavedViewController*)svc didChargePalette:(Palette*)pal;
-(void) controllerDidCancel:(SavedViewController*)svc;

@end

@interface SavedViewController : UITableViewController {
    
    XMLParser *parser;
    id<SavedViewControllerDelegate> delegate;
    
}

@property(assign) id<SavedViewControllerDelegate> delegate;

-(void) addCancelButton;
-(void) cancel;

@end
