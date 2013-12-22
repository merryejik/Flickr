//
//  PhotomaniaManagedDocument.m
//  Photomania
//
//  Created by Maria on 22.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "ManagedDocument.h"

@implementation ManagedDocument

#define DEFAULT_DOCUMENT_NAME @"MyManagedDocument"


-(UIManagedDocument *)createOrOpenUIManagedDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *modelName = self.documentName!=nil ? self.documentName : DEFAULT_DOCUMENT_NAME;
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:modelName];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    bool fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if (fileExists)
    {
        [document openWithCompletionHandler:^(BOOL success)
         {
             if (success) [self documentIsReady];
             else NSLog(@"Could not open document at %@", url);
         }];
    } else {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             if (success) [self documentIsReady];
             else NSLog(@"Could not create document at %@", url);
         }];
    }
    
    self.managedDocument = document;
    return document;
}

-(void)documentIsReady
{
    if (self.managedDocument.documentState == UIDocumentStateNormal)
    {
        self.readyToUse = true;
        self.readyBlock(self.managedDocument.managedObjectContext);
    }
}
@end
