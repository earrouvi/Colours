//
//  Palette.h
//  colours
//
//  Created by Elsa Arrou-Vignod on 16/07/12.
//  Copyright (c) 2012 Ecole Centrale de Nantes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Palette : NSObject {
    
    NSString *name;
    NSArray *colours;
    
}

@property(assign) NSString *name;
@property(assign) NSArray *colours;

-(id) initWithName:(NSString*)myName andColours:(NSArray*)myColours;

@end
