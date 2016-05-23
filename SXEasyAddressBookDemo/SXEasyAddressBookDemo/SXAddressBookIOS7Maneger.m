//
//  SXAddressBookIOS7Maneger.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "SXAddressBookIOS7Maneger.h"

@implementation SXAddressBookIOS7Maneger

+ (SXAddressBookIOS7Maneger *)manager
{
    static SXAddressBookIOS7Maneger *sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

- (void)presentPageOnTarget:(id)target chooseAction:(void (^)(NSDictionary *dict))action{
    
}

- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure
{
    
}

- (SXAddressBookAuthStatus)getAuthStatus
{
    return 0;
}

- (NSArray *)getPersonInfoArray
{
    return nil;
}

@end
