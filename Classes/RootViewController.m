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
    [self setTitle:@"Random Colour Mix"];
    [self.view setBackgroundColor:[Utils getColourFor:ColourTypeBG]];
    
    nbColours = 3;
    comboView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 324)];
    
	[self.view addSubview:comboView];
	[self addNewButton];
    [self addPlusButton];
    [self addSaveButton];
	[self generateCombo];
}

#pragma mark -
#pragma mark Adding subviews

// Buttons for saving image, charging palette and settings
-(void) addSaveButton {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(60, 376, 80, 30);
	[button setTitle:@"Save!" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
    
    UIButton *charge = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	charge.frame = CGRectMake(180, 376, 80, 30);
	[charge setTitle:@"Load..." forState:UIControlStateNormal];
	[charge addTarget:self action:@selector(chargeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:charge];
    
    UIButton *settings = [UIButton buttonWithType:UIButtonTypeCustom];
    settings.frame = CGRectMake(260, 10, 30, 30);
    [settings addTarget:self action:@selector(showSettingsPush:) forControlEvents:UIControlEventTouchUpInside];
    [settings setImage:[UIImage imageNamed:@"settings_bouton90.png"] forState:UIControlStateNormal];
    [self.view addSubview:settings];
}

// Button for new colour combo
-(void) addNewButton {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(80, 10, 160, 30);
	[button setTitle:@"New combo!" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(newButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
}

-(void) addPlusButton {
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.frame = CGRectMake(30, 10, 30, 30);
    [plus addTarget:self action:@selector(plusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [plus setImage:[UIImage imageNamed:@"plus_bouton90.png"] forState:UIControlStateNormal];
    [self.view addSubview:plus];
}

#pragma mark -
#pragma mark Buttons pressed and alert views

-(void) newButtonPressed {
    int i = 0;//,rank = 0;
    int height = 324/nbColours;
    NSString *init = [[Utils generateColour] retain];
    for (UIView *v in comboView.subviews) {
        if (((ColourUnitView*)v).fix) {
            //rank = i;
        } else {
            // big mess for fix + rainbow working together
            [v removeFromSuperview];
            switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"mode"]) {
                case 0:
                    [self createColourBlock:[Utils generateColour] atIndex:i withHeight:height];
                    break;
                case 1:
                    ;NSString *hexString2 = [Utils generateRainbow:init totalNumber:nbColours];
                    [self createColourBlock:hexString2 atIndex:i withHeight:height];
                    [init release];
                    init = [hexString2 retain];
                    break;
                default:
                    break;
            }// end of big mess
        }
        i++;
    }
    [colours release];
	colours = [[NSMutableArray alloc] init];
}

-(void) plusButtonPressed {
    if (nbColours<7) {
        nbColours++;
        [self createColourBlock:[Utils generateColour] atIndex:nbColours-1 withHeight:324/nbColours];
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
                                              otherButtonTitles:@"Save palette",@"Make a wallpaper",@"E-mail combo",nil];
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
        textField.frame = CGRectMake(12, 50, 260, 30);
        textField.backgroundColor = [UIColor whiteColor];
        [alert addSubview:textField];
        [alert setFrame:CGRectMake(alert.frame.origin.x, alert.frame.origin.y, alert.frame.size.width, alert.frame.size.height+40)];
        [textField release];
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
        WallpaperViewController *wvc = [[WallpaperViewController alloc] initWithArrayOfColours:colours];
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

// generation depends on mode (random/rainbow)
-(void) generateCombo {
    int height = 324/nbColours;
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"mode"]) {
        case 0:
            for (int i=0; i<nbColours; i++) {
                NSString *hexString = [Utils generateColour];
                [self createColourBlock:hexString atIndex:i withHeight:height];
            }
            break;
            
        case 1: // you cannot declare a variable on the line following a "case". Add a semi-colon or use brackets.
            ;NSString *hexString = [Utils generateColour];
            [self createColourBlock:hexString atIndex:0 withHeight:height];
            for (int i=1; i<nbColours; i++) {
                NSString *hexString2 = [Utils generateRainbow:hexString totalNumber:nbColours];
                [self createColourBlock:hexString2 atIndex:i withHeight:height];
                hexString = [hexString2 retain];
                [hexString2 release];
            }
            break;
        default:
            break;
    }
	
}

-(void) generateComboFromRank:(int)rank {
    int height = 324/nbColours;
    for (int i=rank; i<(nbColours-rank); i++) {
        NSString *hexString = [Utils generateColour];
        [self createColourBlock:hexString atIndex:i withHeight:height];
    }
}

-(void) createColourBlock:(NSString*)hexString atIndex:(int)i withHeight:(int)height {
    ColourUnitView *unit = [[ColourUnitView alloc] initWithColour:hexString rank:i andHeight:height];
    unit.delegate = self;
    [comboView insertSubview:unit atIndex:i];
    [unit release];
}

-(void) comboLayout {
    int i=0;
    for (ColourUnitView *view in [comboView subviews]) {
        [view changeRank:i andHeight:324/nbColours];
        i++;
    }
}

#pragma mark -
#pragma mark Sending Emails

-(void) writeEmail {
    NSMutableString * body = [NSMutableString stringWithFormat:@"Hey, check out this colour combo I created with my Random Colour Mix app!\n"];
    [body appendString:@"\nDon't forget to review this app!\n\nHex codes:"];
    int width = 250;
    UIView *pal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    for (int i=0; i<[colours count]; i++) {
        [body appendString:@" #"];
        [body appendString:([colours objectAtIndex:i])];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i*width/nbColours, 0, width/nbColours+1, 30)];
        [v setBackgroundColor:[Utils convertHexToRGB:[colours objectAtIndex:i]]];
        [pal addSubview:v];
        [v release];
    }
    [body appendString:@"\n"];
    
    // palette creation
    UIImage *im = [Utils createUIImageFromView:pal];
    NSData *data = UIImagePNGRepresentation(im);
	[self sendEmailTo:@"" withSubject:@"Check out my colour combo!" andBody:body andImage:data];
    [pal release];
}

-(void) sendEmailTo:(NSString*)to withSubject:(NSString*)subject andBody:(NSString*)body andImage:(NSData*)data {
    MFMailComposeViewController *mfm = [[MFMailComposeViewController alloc] init];
    mfm.mailComposeDelegate = self;
    [mfm setSubject:subject];
    [mfm setMessageBody:body isHTML:NO];
    [mfm addAttachmentData:data mimeType:@"image/png" fileName:@"my_combo"];
    [self presentModalViewController:mfm animated:YES];
    [mfm release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    // Called once the email is sent
    // Remove the email view controller	
    [self dismissModalViewControllerAnimated:YES];
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
    ColorPickerViewController *cp = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil andColor:[Utils convertHexToRGB:unit.hexCode]];
    cp.delegate = self;
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
#pragma mark IASK

- (IASKAppSettingsViewController*)appSettingsViewController {
    if (!appSettingsViewController) {
        appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
        appSettingsViewController.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDidChange:) name:kIASKAppSettingChanged object:nil];
        
        BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoConnect"];
        appSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil];
    }
    return appSettingsViewController;
}

- (void)showSettingsPush:(id)sender {
    //[viewController setShowCreditsFooter:NO]; // Uncomment to not display InAppSettingsKit credits for creators.
    // But we encourage you no to uncomment. Thank you!
    self.appSettingsViewController.showDoneButton = YES;
    [self.navigationController pushViewController:self.appSettingsViewController animated:YES];
}

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self.navigationController popViewControllerAnimated:YES];
    // re-configure app
    [self.view setBackgroundColor:[Utils getColourFor:ColourTypeBG]];
    for (UIView *v in [comboView subviews]) {
        [((ColourUnitView*)v) update];
    }
}

- (void)settingDidChange:(NSNotification*)notification {
    if ([notification.object isEqual:@"AutoConnect"]) {
        BOOL enabled = (BOOL)[[notification.userInfo objectForKey:@"AutoConnect"] intValue];
        [self.appSettingsViewController setHiddenKeys:enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil] animated:YES];
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
    [appSettingsViewController release];
    [colours release];
    [pvc release];
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
    [appSettingsViewController release];
	[colours release];
    [pvc release];
    [super dealloc];
}

@end

