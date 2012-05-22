//
//  coloursAppDelegate.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 12/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StandinViewController.h"

@interface coloursAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    StandinViewController *pickerController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet StandinViewController *pickerController;

@end

