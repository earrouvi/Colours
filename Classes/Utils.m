//
//  Utils.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 25/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "Utils.h"


@implementation Utils

+(NSString*) generateColour {
	// 16777215 is FFFFFF
	int baseInt = arc4random() % 16777216;
	NSString *hex = [NSString stringWithFormat:@"%06X", baseInt];
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

// Generate image and save in Photos Album
+(void) createImageFromView:(UIView*) view { 
	CGSize size = [view bounds].size;
	UIGraphicsBeginImageContext(size);
	[[view layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(newImage,nil,nil,nil);
}

// screen bounds
+(int) screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}
+(int) screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+(UIColor*) slateBlue {
    return [UIColor colorWithRed:.243 green:.306 blue:.435 alpha:1];
}

+(UIColor*) getColorFor:(ColourType)type {
    switch (settings) {
        case ColourSettingsBlackBG:
            switch (type) {
                case ColourTypeBG:
                    return [UIColor viewFlipsideBackgroundColor];
                    break;
                case ColourTypeFont:
                    return [UIColor whiteColor];
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
                    return [UIColor blackColor];
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
                    return [UIColor blackColor];
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

@end
