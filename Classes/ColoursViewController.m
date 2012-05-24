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
    change = 0;
	nbColours = col;
    comboView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
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
    [self.view addSubview:hexView];
    [self.view addSubview:buttonsView];
	
	[self addSaveButton];
	[self addSendButton];
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
	button.frame = CGRectMake(70, 380, 180, 30);
	
	//set the button's title
	[button setTitle:@"Save this as image" forState:UIControlStateNormal];
	
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
        [[[hexView subviews] objectAtIndex:0] removeFromSuperview];
        [[[buttonsView subviews] objectAtIndex:0] removeFromSuperview];
    }
	[colours release];
	colours = [[NSMutableArray alloc] init];
    change = 0;
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
    int start = 0;
    int blank = 10;
    int width = (320-blank)/nbColours;
    if (firstColour!=nil) {
        start = 1;
        const CGFloat *c = CGColorGetComponents(firstColour.CGColor);
        NSString *hex = [Utils convertRed:c[0] green:c[1] blue:c[2]];
        [self createColourBlock:hex atIndex:0 withWidth:width andBlank:blank];
        if (change!=3) {
            [self createChangeButton:hex atIndex:0 withWidth:width andBlank:blank];
        }
    }
	for (int i=start; i<nbColours; i++) {
		NSString * hexString = [Utils generateColour];
		
        [self createColourBlock:hexString atIndex:i withWidth:width andBlank:blank];
        if (change!=3) {
            [self createChangeButton:hexString atIndex:i withWidth:width andBlank:blank];
        }
	}
}

-(void) createColourBlock:(NSString*)hexString atIndex:(int)i withWidth:(int)width andBlank:(int)blank {
    // create views for screen
    //UIView * colourView = [[UIView alloc] initWithFrame:CGRectMake(i*width+blank, 90, width-blank, 240)];
    //colourView.backgroundColor = [Utils convertHexToRGB:hexString];
    //[comboView addSubview:colourView];
    
    ColourUnitView *unit = [[ColourUnitView alloc] initWithColour:hexString rank:i andHeight:width];
    [comboView addSubview:unit];
    [unit release];
    
    // create views for saved file
//    UIView * colourView = [[UIView alloc] initWithFrame:CGRectMake(i*320.0/nbColours, 0, 320.0/nbColours, 460)];
//    colourView.backgroundColor = [Utils convertHexToRGB:hexString];
//    
//    // store hex code in string array
//    [colours addObject:hexString];
    
//    [colourView release];
}

-(void) createChangeButton:(NSString*)hexString atIndex:(int)i withWidth:(int)width andBlank:(int)blank {
    // change buttons
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = i;
    [button setTitle:@"Change" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(i*width+blank, 60, width-blank, 25);
    [buttonsView addSubview:button];
    
    // text fields for hex codes
    UITextField *code = [[UITextField alloc] init];
    NSMutableString *hexcode = [NSMutableString stringWithString:@"#"];
    [hexcode appendFormat:hexString];
    code.text = hexcode;
    code.frame = CGRectMake(i*width+blank, 310, width-blank, 20);
    code.textAlignment = UITextAlignmentCenter;
    [hexView addSubview:code];
    [code release];
    change++;
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
