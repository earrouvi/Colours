//
//  RootViewController.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 12/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    nbColours = 3;
    comboView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 316)];
    colours = [[NSMutableArray alloc] init];
    
	[self.view addSubview:comboView];
	[self addNewButton];
    [self addPlusButton];
	[self generateCombo];
}

#pragma mark -
#pragma mark Adding subviews

// Button for saving image
-(void) addSaveButton {
	//create the button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//set the position of the button
	button.frame = CGRectMake(70, 366, 50, 30);
	
	//set the button's title
	[button setTitle:@"Save!" forState:UIControlStateNormal];
	
	//listen for clicks
	[button addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) saveButtonPressed {
	// Pass the selected object to the new view controller.
	WallpaperViewController *wallpaperViewController = [[WallpaperViewController alloc] initWithArrayOfColours:colours];
	[self.navigationController pushViewController:wallpaperViewController animated:YES];
}

// Button for new colour combo
-(void) addNewButton {
	//create the button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//set the position of the button
	button.frame = CGRectMake(70, 10, 180, 30);
	
	//set the button's title
	[button setTitle:@"New combo!" forState:UIControlStateNormal];
	
	//listen for clicks
	[button addTarget:self action:@selector(newButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) newButtonPressed {
    for (UIView *v in comboView.subviews) {
        [v removeFromSuperview];
    }
	[colours release];
	colours = [[NSMutableArray alloc] init];
	[self generateCombo];
}

-(void) addPlusButton {
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    plus.frame = CGRectMake(20, 30, 20, 20);
    [plus setTitle:@"+" forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(plusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plus];
}

-(void) plusButtonPressed {
    if (nbColours<9) {
        nbColours++;
        [self createColourBlock:[Utils generateColour] atIndex:nbColours-1 withHeight:316/nbColours];
        [self comboLayout];
    }
}

-(void) addMinusButtonAtY:(int)y {
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    plus.frame = CGRectMake(300, y, 20, 20);
    [plus setTitle:@"-" forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(minusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plus];
}

-(void) minusButtonPressed {
    if (nbColours>2) {
        nbColours--;
        // delete corresponding view
        [self comboLayout];
    }
}

#pragma mark -
#pragma mark Combo view

-(void) generateCombo {
    int height = 316/nbColours;
	for (int i=0; i<nbColours; i++) {
		NSString * hexString = [Utils generateColour];
        [self createColourBlock:hexString atIndex:i withHeight:height];
	}
}

-(void) createColourBlock:(NSString*)hexString atIndex:(int)i withHeight:(int)height {
    ColourUnitView *unit = [[ColourUnitView alloc] initWithColour:hexString rank:i andHeight:height];
    [comboView addSubview:unit];
    [unit release];
    [self addMinusButtonAtY:60+i*height];
}

-(void) comboLayout {
    for (int i=0;i<nbColours;i++) {
        [[[comboView subviews] objectAtIndex:i] changeRank:i andHeight:316/nbColours];
    }
}

#pragma mark -
#pragma mark Sending Emails

-(void) writeEmail {
    
}

-(void) sendEmailTo:(NSString*)to withSubject:(NSString*)subject andBody:(NSString*)body {
	NSString * mail = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
					   [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					   [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					   [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
}

#pragma mark -

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [comboView release];
}


- (void)dealloc {
    [colorSwatch release];
	[colours release];
    [super dealloc];
}

@end

