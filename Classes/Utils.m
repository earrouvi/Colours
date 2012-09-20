//
//  Utils.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 25/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "Utils.h"

NSArray *colours = nil;

@implementation Utils

+(void) initialize
{
    if (!colours)
        colours = [[NSArray alloc] init];
}


#pragma mark Colour generation and conversion

+(NSString*) generateColour {
	// 16777215 is FFFFFF
	int baseInt = arc4random() % 16777216;
	NSString *hex = [NSString stringWithFormat:@"%06X", baseInt];
	return hex;
}

+(NSString*) generateRainbow:(NSString*)initHex totalNumber:(int)nb {
    UIColor *initCol = [Utils convertHexToRGB:initHex];
    CGFloat h,s,l,alpha;
    
    // handling iOS <5.1 (getHue:saturation:brightness:alpha: not accepted)
    // iOS >5.1
    if([UIColor respondsToSelector:@selector(getHue:saturation:brightness:alpha:)]) {
        [initCol getHue:&h saturation:&s brightness:&l alpha:&alpha];
        // iOs<5.1
    } else {
        const CGFloat *c = CGColorGetComponents(initCol.CGColor);
        [Utils convertRed:c[0] green:c[1] blue:c[2]];
        float min, max, delta;
        min = MIN(c[0], MIN(c[1], c[2]));
        max = MAX(c[0], MAX(c[1], c[2]));
        l = max;               // brightness
        delta = max - min;
        if( max != 0 )
            s = delta / max;       // saturation
        else {
            // r = g = b = 0
            s = 0;
            h = -1;
        }
        if( c[0] == max )
            h = ( c[1] - c[2] ) / delta;     // between yellow & magenta
        else if( c[1] == max )
            h = 2 + ( c[2] - c[0] ) / delta; // between cyan & yellow
        else
            h = 4 + ( c[0] - c[1] ) / delta; // between magenta & cyan
        h *= 60;               // degrees
        if( h < 0 ) {
            h += 360;
        }
        h /= 360;
    } // end of handling <5.1
    
    h += 1.0/nb;
    if (h>1.0) {
        h -= 1.0;
    }
    CGFloat hue = ((double)arc4random() / ARC4RANDOM_MAX)*0.1 + h-0.05;
    UIColor *target = [UIColor colorWithHue:hue saturation:s brightness:l alpha:0];
    const CGFloat *c = CGColorGetComponents(target.CGColor);
    NSString *hex = [Utils convertRed:c[0] green:c[1] blue:c[2]];
    return hex;
}

// Convert hex colour to RGB floats, return UIColor
+(UIColor*) convertHexToRGB:(NSString*)hexString {
	double r,g,b;
	
	NSScanner* pScanner = [NSScanner scannerWithString: [hexString substringWithRange:NSMakeRange(0, 2)]];
	unsigned int iValue;
	[pScanner scanHexInt:&iValue];
	r = iValue/255.0;
	
	pScanner = [NSScanner scannerWithString: [hexString substringWithRange:NSMakeRange(2, 2)]]; 
	[pScanner scanHexInt:&iValue];
	g = iValue/255.0;
	
	pScanner = [NSScanner scannerWithString: [hexString substringWithRange:NSMakeRange(4, 2)]];
	[pScanner scanHexInt:&iValue];
	b = iValue/255.0;
	
	return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

// Convert RGB floats to hex, return string
+(NSString*) convertRed:(float)r green:(float)g blue:(float)b {	
    int hr,hg,hb;
	hr = 255*r; hg = 255*g; hb = 255*b;
    NSMutableString *hex = [NSMutableString stringWithFormat:@"%02X",hr];
    [hex appendFormat:@"%02X",hg];
    [hex appendFormat:@"%02X",hb];
	return hex;
}

#pragma mark Image and screen

// Generate image and save in Photos Album
+(void) createImageFromView:(UIView*) view { 
	CGSize size = [view bounds].size;
	UIGraphicsBeginImageContext(size);
	[[view layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(newImage,nil,nil,nil);
}

+(UIImage*) createUIImageFromView:(UIView*) view { 
	CGSize size = [view bounds].size;
	UIGraphicsBeginImageContext(size);
	[[view layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

// screen bounds
+(int) screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}
+(int) screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

#pragma mark System colours and preferences

+(UIColor*) slateBlue {
    return [UIColor colorWithRed:.243 green:.306 blue:.435 alpha:1];
}

+(UIColor*) getColourFor:(ColourType)type {
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"multi"]) {
        case ColourSettingsBlackBG:
            switch (type) {
                case ColourTypeBG:
                    return [UIColor viewFlipsideBackgroundColor];
                    break;
                case ColourTypeFont:
                    return [UIColor lightTextColor];
                    break;
                default:
                    break;
            }
            break;
        case ColourSettingsWhiteBG:
            switch (type) {
                case ColourTypeBG:
                    return [UIColor whiteColor];
                    break;
                case ColourTypeFont:
                    return [UIColor darkTextColor];
                    break;
                default:
                    break;
            }
            break;
        case ColourSettingsGreyBG:
            switch (type) {
                case ColourTypeBG:
                    return [UIColor underPageBackgroundColor];
                    break;
                case ColourTypeFont:
                    return [UIColor darkTextColor];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return [UIColor whiteColor];
}

+(NSString*) getColourBeforeMe:(int)me {
    return [colours objectAtIndex:me+1];
}

+(void) storeColours:(NSArray*)array {
    if (colours!=array) {
        [colours release];
        colours = [array retain];
    }
}

+(int) getColours {
    return [colours count];
}

@end
