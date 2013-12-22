//
//  PhotomaniaManagedDocument.h
//  Photomania
//
//  Created by Maria on 22.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagedDocument : NSObject

typedef void(^DocumentIsReady)(NSManagedObjectContext *);

@property (nonatomic) BOOL readyToUse;
@property (strong, nonatomic) UIManagedDocument *managedDocument;
@property (copy, nonatomic) DocumentIsReady readyBlock;
@property (strong, nonatomic) NSString *documentName;

-(UIManagedDocument *)createOrOpenUIManagedDocument;

@end
