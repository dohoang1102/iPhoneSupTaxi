//
//  PListData.h
//  ReverseLobotomy
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PListData : NSObject {
	NSString * filePath;

}

@property(nonatomic, copy) NSString * filePath;

-(id)initWithPath:(NSString*)path;
-(void)save;

@end
