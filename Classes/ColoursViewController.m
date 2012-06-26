//
//  ColoursViewController.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 12/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "ColoursViewController.h"


@implementation ColoursViewController

#pragma mark View lifecycle

-(id) initWithNumberOfColours:(int)col andFirstColour:(UIColor*)first {
	nbColours = col;
    comboView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 316)];
    hexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	colours = [[NSMutableArray alloc] init];
    if ((first!=nil)&&(first!=firstColour)) {
        [firstColour release];
        firstColour = [first retain];
    } else {
        firstColour = nil;
    }
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:comboView];
	
	[self addNewButton];
	[self generateCombo];
}

#pragma mark -
#pragma mark Adding subviews

// Button for saving image
-(void) addSaveButton {
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
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

// Button for sending email with hex colour codes
-(void) addSendButton {
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//set the position of the button
	button.frame = CGRectMake(50, 340, 220, 30);
	
	//set the button's title
	[button setTitle:@"Send colour codes by email" forState:UIControlStateNormal];
	
	//listen for clicks
	[button addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) sendButtonPressed {
    NSMutableString * body = [NSMutableString stringWithFormat:@"Here is a wonderful colour combo:"];
    for (int i=0; i<[colours count]; i++) {
        [body appendString:@"\n#"];
        [body appendString:([colours objectAtIndex:i])];
    }
	[self sendEmailTo:@"elsarrou@wanadoo.fr" withSubject:@"My colour combo on Colourandom" andBody:body];
}

// Button for new colour combo
-(void) addNewButton {
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
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
    for (int i=0;i<nbColours;i++) {
        [[[comboView subviews] objectAtIndex:0] removeFromSuperview];
    }
	[colours release];
	colours = [[NSMutableArray alloc] init];
	[self generateCombo];
}

-(void) changeButtonPressed:(id)sender {
    int index = ((UIControl*)sender).tag;
    
    // colour replacement
    NSString * hexString = [Utils generateColour];
    ((UIView*)[[comboView subviews] objectAtIndex:index]).backgroundColor = [Utils convertHexToRGB:hexString];
    [colours replaceObjectAtIndex:index withObject:hexString];
    // hex code replacement
    NSMutableString *hexcode = [NSMutableString stringWithString:@"#"];
    [hexcode appendFormat:hexString];
    ((UITextField*)[[hexView subviews] objectAtIndex:index]).text = hexcode;
    if (index==0) {
        [firstColour release];
        firstColour = nil;
    }
}

#pragma mark -
#pragma mark Combo generation and image processing

-(void) generateCombo {
    int height = (316)/nbColours;
	for (int i=0; i<nbColours; i++) {
		NSString * hexString = [Utils generateColour];
        [self createColourBlock:hexString atIndex:i withHeight:height];
	}
}

-(void) createColourBlock:(NSString*)hexString atIndex:(int)i withHeight:(int)height {
    ColourUnitView *unit = [[ColourUnitView alloc] initWithColour:hexString rank:i andHeight:height];
    [comboView addSubview:unit];
    [unit release];
}

#pragma mark -
#pragma mark Sending Emails

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
}


- (void)dealloc {
    [firstColour release];
    [button release];
    [comboView release];
    [hexView release];
    [buttonsView release];
	[colours release];
    [super dealloc];
}


@end
