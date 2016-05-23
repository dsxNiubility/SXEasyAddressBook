//
//  SXAddressBookManager.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "SXAddressBookManager.h"
#import "SXAddressBookIOS7Maneger.h"
#import "SXAddressBookIOS8Maneger.h"
#import "SXAddressBookIOS9Maneger.h"

@implementation SXAddressBookManager

+ (SXAddressBookManager *)manager
{
    static SXAddressBookManager *sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

@end
