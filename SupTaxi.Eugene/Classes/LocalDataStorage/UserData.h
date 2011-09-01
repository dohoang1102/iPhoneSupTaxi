//
//  UserData.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 31.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserData : NSManagedObject {

}

@property (nonatomic, retain) NSString * userGuid;
@property (nonatomic, retain) NSString * userKey;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSString * userPassword;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userLastName;

@end
