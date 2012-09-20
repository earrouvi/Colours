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
    [self loadMosaics];
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
    [slide setMaximumValue:9]; [slide setMinimumValue:1];
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
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//set the position of the button
	button.frame = CGRectMake(80, 350, 160, 30);
	
	//set the button's title
	[button setTitle:@"Save this picture!" forState:UIControlStateNormal];
	
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
	[coloursView addSubview:[verticals objectAtIndex:loop-1]];
}

-(void) createHorizontalView {
	int loop = floor(slideNb);
    [coloursView addSubview:[horizontals objectAtIndex:loop-1]];
}

-(void) createMosaicView {
    int loop = floor(slideNb);
    [coloursView addSubview:[mosaics objectAtIndex:loop-1]];
}

-(void) loadMosaics {
    mosaics = [[NSMutableArray alloc] init];
    verticals = [[NSMutableArray alloc] init];
    horizontals = [[NSMutableArray alloc] init];
    
    for (int i=1;i<11;i++) {
        int width = ceil(320.0/(nbColours*i));
        int plus = (460-320)/width+1;
        NSArray *arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:i], [NSNumber numberWithDouble:width], [NSNumber numberWithInt:plus], [NSNumber numberWithInt:nbColours], colours, [NSNumber numberWithInt:2], nil];
        WallpaperView *wv = [[WallpaperView alloc] initWithParameters:arr];
        
        [mosaics addObject:wv];
        
        [arr release];
        arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:i], [NSNumber numberWithDouble:width], [NSNumber numberWithInt:plus], [NSNumber numberWithInt:nbColours], colours, [NSNumber numberWithInt:0], nil];
        WallpaperView *wv2 = [[WallpaperView alloc] initWithParameters:arr];
        
        [verticals addObject:wv2];
        
        [arr release];
        arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:i], [NSNumber numberWithDouble:width], [NSNumber numberWithInt:plus], [NSNumber numberWithInt:nbColours], colours, [NSNumber numberWithInt:1], nil];
        WallpaperView *wv3 = [[WallpaperView alloc] initWithParameters:arr];
        
        [horizontals addObject:wv3];
        
        [arr release];
        [wv release];
        [wv2 release];
        [wv3 release];
    }
    for (int i=0;i<5;i++) {
        [coloursView addSubview:[mosaics objectAtIndex:i]];
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
    [mosaics release];
    [verticals release];
    [horizontals release];
    [super dealloc];
}


@end
