//
//  SXAddressBookIOS9Maneger.h
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXAddressBookDefine.h"

@interface SXAddressBookIOS9Maneger : NSObject

+ (SXAddressBookIOS9Maneger *)manager;
- (void)presentPageOnTarget:(id)target chooseAction:(SXAddressBookChooseAction)action;
- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure;
- (SXAddressBookAuthStatus)getAuthStatus;
- (NSArray *)getPersonInfoArray;
- (void)creatItemWithName:(NSString *)name phone:(NSString *)phone;

@end
