//
//  Utils.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 25/04/12.
//  Copyright 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <QuartzCore/QuartzCore.h>

#define ARC4RANDOM_MAX      0x100000000

enum {
    ColourSettingsBlackBG = 0,
    ColourSettingsWhiteBG,
    ColourSettingsGreyBG
};
typedef NSUInteger ColourSettings;

enum {
    ColourTypeBG = 0,
    ColourTypeFont
};
typedef NSUInteger ColourType;

@interface Utils : NSObject {

}

+(NSString*) generateColour;
+(UIColor*) convertHexToRGB:(NSString*)hexString;
+(NSString*) convertRed:(float)r green:(float)g blue:(float)b;

+(void) createImageFromView:(UIView*)view;
+(int) screenWidth;
+(int) screenHeight;

+(UIColor*) slateBlue;
+(UIColor*) getColorFor:(ColourType)type;
+(void) setSettings:(ColourSettings)set;

@end
