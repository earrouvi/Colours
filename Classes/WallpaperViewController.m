//
//  WallpaperViewController.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 25/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "WallpaperViewController.h"


@implementation WallpaperViewController

-(id) initWithArrayOfColours:(NSMutableArray*)col {
    [super init];
	nbColours = [col count];
	colours = [col retain];
	coloursView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	[self.view addSubview:coloursView];
	[self addViewControl];
	[self addNumberControl];
	[self addSaveButton];
	[self createVerticalView];
	return self;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

#pragma mark Buttons and controls

// controlling vertical/horizontal/mosaic view
-(void) addViewControl {
	//create the array of items with images
	NSArray *items = [NSArray arrayWithObjects:
					  [UIImage imageNamed:@"vertical30.png"],
					  [UIImage imageNamed:@"horizontal30.png"],
					  [UIImage imageNamed:@"mosaic30.png"],
					  nil];	
	
	//create the control
	controlV = [[UISegmentedControl alloc]  initWithItems:items];
	//controlV.frame = CGRectMake(115, 10, 90, 30);
    controlV.frame = CGRectMake(100, 10, 120, 40);
	
	// init with first item selected
	controlV.selectedSegmentIndex = 0;
	
	//listen for clicks
	[controlV addTarget:self action:@selector(controlView) forControlEvents:UIControlEventValueChanged];
	
	//add the control to the view
	[self.view addSubview:controlV];
}

-(void) controlView {
	for (UIView *view in [coloursView subviews]) {
		[view removeFromSuperview];
	}
	switch(controlV.selectedSegmentIndex) {
		case 0:
			[self createVerticalView];
			break;
		case 1:
			[self createHorizontalView];
			break;
		case 2:
			[self createMosaicView];
			break;
	}
}

// controlling number of loop for colours
-(void) addNumberControl {
    UISlider *slide = [[UISlider alloc] init];
    [slide setMaximumValue:10]; [slide setMinimumValue:1];
	slide.frame = CGRectMake(50, 60, 220, 30);
    [slide addTarget:self action:@selector(slideListener) forControlEvents:UIControlEventValueChanged];
    slide.continuous = YES;
	
	//add the control to the view
	[self.view addSubview:slide];
    slideNb = slide.value;
}

-(void) controlNumber {
	for (UIView *view in [coloursView subviews]) {
		[view removeFromSuperview];
	}
	switch(controlV.selectedSegmentIndex) {
		case 0:
			[self createVerticalView];
			break;
		case 1:
			[self createHorizontalView];
			break;
		case 2:
			[self createMosaicView];
			break;
	}
}

// Button for saving image
-(void) addSaveButton {
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//set the position of the button
	button.frame = CGRectMake(80, 350, 160, 30);
	
	//set the button's title
	[button setTitle:@"Save this image!" forState:UIControlStateNormal];
	
	//listen for clicks
	[button addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) saveButtonPressed {
	// alert pops up
	[self alert];
}

-(void) slideListener {
    slideNb = ((UISlider*)[self.view.subviews objectAtIndex:2]).value;
    [self controlView];
}

#pragma mark -
#pragma mark Views creation

-(void) createVerticalView {
	int loop = floor(slideNb);
	double width = 320.0/(nbColours*loop);
	
	for (int l=0; l<loop; l++) {
		for (int i=0; i<nbColours; i++) {
			NSString * hexString = [colours	objectAtIndex:i];
			
			
			UIView * colourView = [[UIView alloc] initWithFrame:CGRectMake((i+l*nbColours)*width, 0, width, 460)];
			colourView.backgroundColor = [Utils convertHexToRGB:hexString];
			[coloursView addSubview:colourView];
		}		
	}
}

-(void) createHorizontalView {
	int loop = floor(slideNb);
	double height = 460.0/(nbColours*loop);
	
	for (int l=0; l<loop; l++) {
		for (int i=0; i<nbColours; i++) {
			NSString * hexString = [colours	objectAtIndex:i];
			
			
			UIView * colourView = [[UIView alloc] initWithFrame:CGRectMake(0, (i+l*nbColours)*height, 320, height)];
			colourView.backgroundColor = [Utils convertHexToRGB:hexString];
			[coloursView addSubview:colourView];
		}
	}
}

-(void) createMosaicView {
	int loop = floor(slideNb);
	double width = 320.0/(nbColours*loop);
	int plus = (460-320)/width+1;
	
	for (int i=0; i<(loop*nbColours+plus); i++) {
		for (int l=0; l<loop; l++) {
			for (int j=0; j<nbColours; j++) {
				NSString * hexString = [colours	objectAtIndex:j];
				
				UIView * colourView = [[UIView alloc] initWithFrame:CGRectMake(((i+j)%nbColours+l*nbColours)*width, 
																			   i*width, width, width)];
				colourView.backgroundColor = [Utils convertHexToRGB:hexString];
				[coloursView addSubview:colourView];
			}
		}
	}
}

#pragma mark -
#pragma mark Alert view

// Create YES/NO alert view
-(void) alert {
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Save this image to your Photos Album?"];
	[alert setMessage:@"You will then be able to set is as wallpaper."];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert show];
	[alert release];
}

// Delegate method for alert view
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
	{
		[Utils createImageFromView:coloursView];
	}
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
}


- (void)dealloc {
	[colours release];
	[coloursView release];
	[controlV release];
	[button release];
    [super dealloc];
}


@end
