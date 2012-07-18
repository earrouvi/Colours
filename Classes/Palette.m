//
//  Palette.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 16/07/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "Palette.h"

@implementation Palette

@synthesize name;
@synthesize colours;

-(id) initWithName:(NSString*)myName andColours:(NSArray*)myColours {
    [super init];
    name = [myName retain];
    colours = [myColours retain];
    return self;
}

-(void) dealloc {
    [name release];
    [colours release];
    [super dealloc];
}

@end
