//
//  Carrier.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 09.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Carrier : NSObject {

}

@property (nonatomic, assign) int carrierId;
@property (nonatomic, copy) NSString *carrierName;
@property (nonatomic, copy) UIImage *carrierLogo;
@property (nonatomic, assign) BOOL isPreferred;

- (id)initWithCarrierId:(int)cId carrierName:(NSString *)cName carrierLogoStr:(NSString *)cLogoStr
				isPreferred:(BOOL) cIsPreferred;

@end
