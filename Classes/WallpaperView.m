//
//  WallpaperView.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 14/09/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "WallpaperView.h"

@implementation WallpaperView

-(id) initWithParameters:(NSArray*)params {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    if (self) {
        loop = [[params objectAtIndex:0] intValue];
        width = [[params objectAtIndex:1] intValue];
        plus = [[params objectAtIndex:2] intValue];
        nbColours = [[params objectAtIndex:3] intValue];
        colours = [[params objectAtIndex:4] retain];
        type = [[params objectAtIndex:5] intValue];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, self.bounds);
    NSString *hexString;
    switch (type) {
        case 0:
            for (int l=0; l<loop; l++) {
                for (int i=0; i<nbColours; i++) {
                    hexString = [colours	objectAtIndex:i];
                    CGColorRef myColour = [Utils convertHexToRGB:hexString].CGColor;
                    CGContextSetFillColorWithColor(context, myColour);
                    CGRect rect =CGRectMake((i+l*nbColours)*width, 0, width, 460);
                    CGContextFillRect(context, rect);
                }		
            }
            break;
        case 1:
            ;double height = ceil(460.0/(nbColours*loop));
            for (int l=0; l<loop; l++) {
                for (int i=0; i<nbColours; i++) {
                    hexString = [colours	objectAtIndex:i];
                    CGColorRef myColour = [Utils convertHexToRGB:hexString].CGColor;
                    CGContextSetFillColorWithColor(context, myColour);
                    CGRect rect = CGRectMake(0, (i+l*nbColours)*height, 320, height);
                    CGContextFillRect(context, rect);
                }
            }
            break;
        case 2:
            for (int i=0; i<(loop*nbColours+plus); i++) {
                for (int l=0; l<loop; l++) {
                    for (int j=0; j<nbColours; j++) {
                        hexString = [colours objectAtIndex:j];
                        CGColorRef myColour = [Utils convertHexToRGB:hexString].CGColor;
                        CGContextSetFillColorWithColor(context, myColour);
                        CGRect rect = CGRectMake(((i+j)%nbColours+l*nbColours)*width,i*width,width,width);
                        CGContextFillRect(context, rect);
                    }
                }
            }
            break;
            
        default:
            break;
    }
    
}

-(void) dealloc {
    [colours release];
    [super dealloc];
}

@end
