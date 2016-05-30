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

- (void)presentPageOnTarget:(id)target chooseAction:(SXAddressBookChooseAction)action{
    if (IOS7_OR_EARLY_SX) {
        [[SXAddressBookIOS7Maneger manager] presentPageOnTarget:target chooseAction:action];
    }else if (IOS9_OR_LATER_SX){
        [[SXAddressBookIOS9Maneger manager] presentPageOnTarget:target chooseAction:action];
    }else{
        [[SXAddressBookIOS8Maneger manager] presentPageOnTarget:target chooseAction:action];
    }
}

- (void)checkStatusAndDoSomethingSuccess:(void (^)())success failure:(void (^)())failure{
    SXAddressBookAuthStatus status = [[SXAddressBookManager manager]getAuthStatus];
    if (status == kSXAddressBookAuthStatusNotDetermined) {
        [[SXAddressBookManager manager]askUserWithSuccess:^{
            success();
        } failure:^{
            failure();
        }];
    }else if (status == kSXAddressBookAuthStatusAuthorized){
        success();
    }else{
        failure();
    }
}

- (void)creatItemWithName:(NSString *)name phone:(NSString *)phone
{
    if (IOS7_OR_EARLY_SX) {
        [[SXAddressBookIOS7Maneger manager] creatItemWithName:name phone:phone];
    }else if (IOS9_OR_LATER_SX){
        [[SXAddressBookIOS9Maneger manager] creatItemWithName:name phone:phone];
    }else{
        [[SXAddressBookIOS8Maneger manager] creatItemWithName:name phone:phone];
    }
}

- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure
{
    if (IOS7_OR_EARLY_SX) {
        [[SXAddressBookIOS7Maneger manager] askUserWithSuccess:success failure:failure];
    }else if (IOS9_OR_LATER_SX){
        [[SXAddressBookIOS9Maneger manager] askUserWithSuccess:success failure:failure];
    }else{
        [[SXAddressBookIOS8Maneger manager]  askUserWithSuccess:success failure:failure];
    }
}

- (SXAddressBookAuthStatus)getAuthStatus
{
    SXAddressBookAuthStatus status;
    if (IOS7_OR_EARLY_SX) {
        status = [[SXAddressBookIOS7Maneger manager] getAuthStatus];
    }else if (IOS9_OR_LATER_SX){
        status = [[SXAddressBookIOS9Maneger manager] getAuthStatus];
    }else{
        status = [[SXAddressBookIOS8Maneger manager] getAuthStatus];
    }
    return status;
}

- (NSArray *)getPersonInfoArray
{
    if (IOS7_OR_EARLY_SX) {
        return [[SXAddressBookIOS7Maneger manager] getPersonInfoArray];
    }else if (IOS9_OR_LATER_SX){
        return [[SXAddressBookIOS9Maneger manager] getPersonInfoArray];
    }else{
        return [[SXAddressBookIOS8Maneger manager] getPersonInfoArray];
    }
}

@end
