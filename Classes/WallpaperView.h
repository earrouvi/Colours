//
//  WallpaperView.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 14/09/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface WallpaperView : UIView {
    
    int loop, plus, width, nbColours, type;
    NSArray *colours;
}

-(id) initWithParameters:(NSArray*)params;

@end
