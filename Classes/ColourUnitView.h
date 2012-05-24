//
//  ColourUnitView.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 22/05/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface ColourUnitView : UIView {

    NSMutableString *hexCode;
    UIButton *deleteColour;
    UIButton *pickColour;
    UIButton *changeColour;
    UIView *colourBlock;
    
}

- (id)initWithColour:(NSString*)colour rank:(int)rank andHeight:(int)height;
-(void) changeRank:(int)rank andHeight:(int)height;
-(void) changeColour:(NSString*)hexString;

@end
