//
//  PaletteView.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 16/07/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Palette.h"
#import "Utils.h"

@interface PaletteView : UIView

- (id)initWithFrame:(CGRect)frame andPalette:(Palette*)pal;

@end
