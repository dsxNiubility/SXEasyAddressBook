//
//  SXAddressBookManager.h
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXAddressBookDefine.h"
@interface SXAddressBookManager : NSObject

+ (SXAddressBookManager *)manager;
- (void)presentPageOnTarget:(id)target chooseAction:(SXAddressBookChooseAction)action;
- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure;
- (SXAddressBookAuthStatus)getAuthStatus;
- (NSArray *)getPersonInfoArray;

/**
 *  检查有无权限后直接执行代码
 *
 *  @param success 有权限操作
 *  @param failure 无权限操作
 */
- (void)checkStatusAndDoSomethingSuccess:(void (^)())success failure:(void (^)())failure;

@end
