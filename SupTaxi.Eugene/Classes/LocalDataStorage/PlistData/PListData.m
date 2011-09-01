//
//  PListData.m
//  ReverseLobotomy
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "PListData.h"


@implementation PListData

@synthesize filePath;

-(void)dealloc{
	[filePath release];
	
	[super dealloc];
}

-(void)decodeDictionary:(NSDictionary*)dictionary{
	//override
}

-(void)encodeDictionary:(NSMutableDictionary*)dictionary{
	//override
}

-(id)initWithPath:(NSString*)path{
	self = [self init];
	if(self){
		self.filePath = path;
		if([[NSFileManager defaultManager] fileExistsAtPath:path]){
			NSData *data = [[NSData alloc] initWithContentsOfFile: path];
			if(data){
				NSString *errorDesc = nil;
				NSPropertyListFormat format;
				
				NSDictionary * dictionary = (NSDictionary *)[NSPropertyListSerialization
															 propertyListFromData:data
															 mutabilityOption:NSPropertyListMutableContainersAndLeaves
															 format:&format
															 errorDescription:&errorDesc];
				if (!dictionary) {
					NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
				}
				else{
					[self decodeDictionary: dictionary];
				}
			}
			[data release];
		}
	}
	return self;	
}

-(void)save{
	NSString *error = nil;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[self encodeDictionary:dictionary];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dictionary
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:[self filePath] atomically:YES];
    }
    else {
        NSLog(@"%@", error);
        [error release];
    }
}

@end
