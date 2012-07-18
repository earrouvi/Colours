//
//  XMLParser.m
//  colours
//
//  Created by Elsa Arrou-Vignod on 16/07/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

@synthesize root;
@synthesize doc;

-(id) init {
    [super init];
    // filepath construction
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *file = [libraryDirectory stringByAppendingPathComponent:@"palettes.xml"];
    NSData *data = [NSData dataWithContentsOfFile: file];
    NSError *error;
    
    // reading
    doc = [[DDXMLDocument alloc] initWithData:data options:DDXMLDocumentXMLKind error:&error];
    
    // test
    if (doc == nil) {
        doc = [[DDXMLDocument alloc] initWithXMLString:@"<root></root>" options:DDXMLDocumentXMLKind error:&error];
        [self write];
    }
    root = [[doc rootElement] retain];
    return self;
}

-(void) addPalette:(Palette *)pal {
    DDXMLNode *attName = [DDXMLNode attributeWithName:@"name" stringValue:pal.name];
    // get the colours
    NSMutableArray *array = [NSMutableArray arrayWithObjects:nil];
    for (NSString *col in pal.colours) {
        DDXMLElement *colour = [DDXMLElement elementWithName:@"colour"];
        [colour addAttribute:[DDXMLNode attributeWithName:@"hex" stringValue:col]];
        [array addObject:colour];
    }
    
    DDXMLElement *element = [DDXMLNode elementWithName:@"palette" children:array attributes:[NSArray arrayWithObject:attName]];
    [root addChild:element];
    [self write];
}

-(void) write {
    if ([doc XMLData]!=nil) {
        // filepath construction
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *file = [libraryDirectory stringByAppendingPathComponent:@"palettes.xml"];
        
        // writing
        [[doc XMLData] writeToFile:file atomically:YES];
    }
}

-(Palette*) returnPalette:(int)index {
    NSString *palName = [[((DDXMLElement*)[root childAtIndex:index]).attributes objectAtIndex:0] stringValue];
    // get the colours
    NSMutableArray *array = [NSMutableArray arrayWithObjects:nil];
    for (DDXMLElement *el in [[root childAtIndex:index] children]) {
        [array addObject:[[el.attributes objectAtIndex:0] stringValue]];
    }
    Palette *pal = [[Palette alloc] initWithName:palName andColours:array];
    return pal;
}

-(void) dealloc {
    [root release];
    [doc release];
    [super dealloc];
}

@end
