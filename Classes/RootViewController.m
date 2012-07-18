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
    [self setTitle:@"Colourandom"];
    [self.view setBackgroundColor:[UIColor underPageBackgroundColor]];
    
    nbColours = 3;
    comboView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 316)];
    
    minusButtons = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 316)];
    pickButtons = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 316)];
    
	[self.view addSubview:comboView];
    //[self.view addSubview:pickButtons];
    //[self.view addSubview:minusButtons];
	[self addNewButton];
    [self addPlusButton];
    [self addSaveButton];
	[self generateCombo];
}

#pragma mark -
#pragma mark Adding subviews

// Button for saving image
-(void) addSaveButton {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(60, 376, 80, 30);
	[button setTitle:@"Save!" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
    
    UIButton *charge = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	charge.frame = CGRectMake(180, 376, 80, 30);
	[charge setTitle:@"Charge..." forState:UIControlStateNormal];
	[charge addTarget:self action:@selector(chargeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:charge];
}

// Button for new colour combo
-(void) addNewButton {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(70, 10, 180, 30);
	[button setTitle:@"New combo!" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(newButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
}

-(void) addPlusButton {
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    plus.frame = CGRectMake(30, 10, 30, 30);
    [plus setTitle:@"+" forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(plusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plus];
}

#pragma mark -
#pragma mark Buttons pressed and alert views

-(void) newButtonPressed {
    for (UIView *v in comboView.subviews) {
        [v removeFromSuperview];
    }
	[colours release];
	colours = [[NSMutableArray alloc] init];
	[self generateCombo];
}

-(void) plusButtonPressed {
    if (nbColours<6) {
        nbColours++;
        [self createColourBlock:[Utils generateColour] atIndex:nbColours-1 withHeight:316/nbColours];
        [self comboLayout];
    }
}

-(void) chargeButtonPressed {
    pvc = [[SavedViewController alloc] initWithStyle:UITableViewStylePlain];
    pvc.delegate = self;
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void) alert {
    // Store codes in "colours" (we'll need it for first and second button anyway)
    [colours release];
    colours = [[NSMutableArray alloc] init];
    for (ColourUnitView *unit in [comboView subviews]) {
        [colours addObject:unit.hexCode];
    }
    
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Save?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Save palette",@"Make a wallpaper",@"Send by email",nil];
    [alert setTag:0];
	[alert showInView:self.view];
	[alert release];
}

-(void) alertInput {
    UIAlertView * alert = [[UIAlertView alloc] init];
    [alert setTag:1];
    [alert setTitle:@"Enter Name"];
    [alert setMessage:@" "];
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Ok"];
    [alert setDelegate:self];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    // style plain text input exists only for iOS 5 and later. The following block sorts it out:
    if([alert respondsToSelector:@selector(setAlertViewStyle:)]) {
        //Code for 5.1
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    } else {
        //Code for pre-5.1 OSes
        UITextField * textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(12, 50, 260, 30); //Your properties here
        textField.backgroundColor = [UIColor whiteColor];
        [alert addSubview:textField];
        [alert setFrame:CGRectMake(alert.frame.origin.x, alert.frame.origin.y, alert.frame.size.width, alert.frame.size.height+40)];
    }
    [alert show];
    [alert release];
}

-(void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Ask palette name
        [self alertInput];
    } else if (buttonIndex == 1) {
		// Pass the selected object to the new view controller.
        [wvc release];
        wvc = [[WallpaperViewController alloc] initWithArrayOfColours:colours];
        [self.navigationController pushViewController:wvc animated:YES];
	} else if (buttonIndex == 2) {
        [self writeEmail];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *name;
        // handling iOS <5.1 and empty string
        // iOS >5.1
        if([alertView respondsToSelector:@selector(setAlertViewStyle:)]) {
            if (![[[alertView textFieldAtIndex:0] text] isEqualToString:@""]) {
                name = [[alertView textFieldAtIndex:0] text];
                NSLog(@"luc: %@",[[alertView textFieldAtIndex:0] text]);
            } else {
                name = @"Untitled";
            }
            // iOs<5.1
        } else {
            if (((UITextField*)[[alertView subviews] objectAtIndex:[[alertView subviews] count]-1]).text != nil) {
                name = ((UITextField*)[[alertView subviews] objectAtIndex:[[alertView subviews] count]-1]).text;
            } else {
                name = @"Untitled";
            }
        }
        // Write palette in XML file
        XMLParser *parser = [[XMLParser alloc] init];
        Palette *pal = [[Palette alloc] initWithName:name andColours:colours];
        [parser addPalette:pal];
        [parser release];
        [pal release];
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
    unit.delegate = self;
    [comboView addSubview:unit];
    [unit release];
}

-(void) comboLayout {
    int i=0;
    for (ColourUnitView *view in [comboView subviews]) {
        [view changeRank:i andHeight:316/nbColours];
        i++;
    }
}

#pragma mark -
#pragma mark Sending Emails

-(void) writeEmail {
    NSMutableString * body = [NSMutableString stringWithFormat:@"Here is a wonderful colour combo I created with Colourapp:\n"];
    for (int i=0; i<[colours count]; i++) {
        [body appendString:@"\n#"];
        [body appendString:([colours objectAtIndex:i])];
    }
    [body appendString:@"Get Colourapp on http://www.colourapp.com\n"];
	[self sendEmailTo:@"" withSubject:@"My colour combo on Colourapp" andBody:body];
}

-(void) sendEmailTo:(NSString*)to withSubject:(NSString*)subject andBody:(NSString*)body {
	NSString * mail = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
					   [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					   [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					   [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
}

#pragma mark -
#pragma mark Color Picker delegate methods

- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor*)color {
    
    const CGFloat *c = CGColorGetComponents(color.CGColor);
    NSString *hex = [Utils convertRed:c[0] green:c[1] blue:c[2]];
    
    [colourReceiver changeColour:hex];
    [colorPicker dismissModalViewControllerAnimated:YES];
    [colourReceiver release];
}

#pragma mark -
#pragma mark Colour Unit View delegate methods

-(void) didClickOnDelete:(ColourUnitView*)unit {
    if (nbColours>2) {
        nbColours--;
        [unit removeFromSuperview];
        [self comboLayout];
    }
}

-(void) didClickOnColorPicker:(ColourUnitView*)unit {
    // Pass the selected object to the color picker view controller
    ColorPickerViewController *cp = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil];
    cp.delegate = self;
    cp.defaultsColor = [UIColor redColor];
    colourReceiver = [unit retain];
    [self presentModalViewController:cp animated:YES];
}

#pragma mark -
#pragma mark Saved View Controller delegate methods

-(void) controller:(SavedViewController *)svc didChargePalette:(Palette *)pal {
    [pal retain];
    [self.navigationController popViewControllerAnimated:YES];
    int nb = [pal.colours count];
    while (nb!=nbColours) {
        if (nb>nbColours) {
            [self plusButtonPressed];
        } else if (nb<nbColours) {
            nbColours--;
            [[[comboView subviews] objectAtIndex:nbColours-1] removeFromSuperview];
            [self comboLayout];
        }
    }
    int i = 0;
    for (NSString *col in pal.colours) {
        [((ColourUnitView*)[[comboView subviews] objectAtIndex:i]) changeColour:col];
        i++;
    }
    [pal release];
}

-(void) controllerDidCancel:(SavedViewController *)svc {
    [self.navigationController popViewControllerAnimated:YES];
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
    [minusButtons release];
    [pickButtons release];
}


- (void)dealloc {
	[colours release];
    [pvc release];
    [wvc release];
    [super dealloc];
}

@end

