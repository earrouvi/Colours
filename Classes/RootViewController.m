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


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Colourandom";
	
	[self addBorderAtY:10 withName:@"squares1.jpg"];
	[self addSegmentedControl];
	[self addBorderAtY:[Utils screenHeight]-120 withName:@"squares2.jpg"];
	[self addNewButton];
    [self addPickerButton];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

#pragma mark -
#pragma mark Adding interface elements

-(void) addNewButton {
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//set the position of the button
	button.frame = CGRectMake(70, 280, 180, 60);
	
	//set the button's title
	[button setTitle:@"START!" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:40];
	
	//listen for clicks
	[button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) buttonPressed {
	// Pass the selected object to the new view controller.
	ColoursViewController *detailViewController = [[ColoursViewController alloc] initWithNumberOfColours:control.selectedSegmentIndex+3 andFirstColour:colorSwatch];
	[self.navigationController pushViewController:detailViewController animated:YES];
}

-(void) addSegmentedControl {
    UITextField *howmany = [[UITextField alloc] init];
    howmany.textAlignment = UITextAlignmentCenter;
    howmany.frame = CGRectMake(60, 40, 200, 20);
    howmany.text = @"How many colours?";
    howmany.textColor = [Utils slateBlue];
    [self.view addSubview:howmany];
    [howmany release];
    
    howmany = [[UITextField alloc] init];
    howmany.textAlignment = UITextAlignmentCenter;
    howmany.frame = CGRectMake(60, 140, 200, 20);
    howmany.text = @"A colour to start with?";
    howmany.textColor = [Utils slateBlue];
    [self.view addSubview:howmany];
    [howmany release];
    
	//create the array of items
	NSArray * items = [[NSArray alloc] initWithObjects:@"3", @"4", @"5", nil];
	
	//create the control
	control = [[UISegmentedControl alloc]  initWithItems:items];
	control.frame = CGRectMake(90, 70, 140, 40);
    if ([control respondsToSelector:@selector(setTitleTextAttributes: forState:)]) {
        UIFont *font = [UIFont boldSystemFontOfSize:30];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, UITextAttributeFont, nil];
        [control setTitleTextAttributes:attributes forState:UIControlStateNormal];
    }
	
	// init with first item selected
	control.selectedSegmentIndex = 0;
	[self.view addSubview:control];
    
	[items release];
}

-(void) addPickerButton {
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//set the position of the button
	button.frame = CGRectMake(50, 170, 220, 40);
	
	//set the button's title
	[button setTitle:@"Choose a first colour" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
	
	//listen for clicks
	[button addTarget:self action:@selector(pickerPressed) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) pickerPressed {
	// Pass the selected object to the color picker view controller
	ColorPickerViewController *cp = 
    [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil];
    cp.delegate = self;
    cp.defaultsColor = [UIColor redColor];
	[self presentModalViewController:cp animated:YES];
}

-(void) addBorderAtY:(int)y withName:(NSString*)filename {
	UIImageView * squares = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
	squares.frame = CGRectMake(0, y, 320, 40);
	[self.view addSubview:squares];
	[squares release];
}

#pragma mark -
#pragma mark Color Picker
- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    if (color!=colorSwatch) {
        [colorSwatch release];
        colorSwatch = [color retain];
    }
    
    [colorPicker dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[button release];
	[control release];
    [colorSwatch release];
    [super dealloc];
}


@end

