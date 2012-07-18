//
//  XMLParser.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 16/07/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "Palette.h"

@interface XMLParser : NSObject {
    
    DDXMLDocument *doc;
    DDXMLElement *root;
    
}

@property(assign) DDXMLElement *root;
@property(assign) DDXMLDocument *doc;

-(id) init;
-(void) addPalette:(Palette*)pal;
-(void) write;
-(Palette*) returnPalette:(int)index;

@end
