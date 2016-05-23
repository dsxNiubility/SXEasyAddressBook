//
//  SXAddressBookIOS9Maneger.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "SXAddressBookIOS9Maneger.h"
#import <AddressBookUI/AddressBookUI.h>

@interface SXAddressBookIOS9Maneger ()

@property(nonatomic,copy) SXAddressBookChooseAction chooseAction;

@end

@implementation SXAddressBookIOS9Maneger

+ (SXAddressBookIOS9Maneger *)manager
{
    static SXAddressBookIOS9Maneger *sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

- (void)presentPageOnTarget:(id)target chooseAction:(SXAddressBookChooseAction)action{
    
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
