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

/**
 *  取出单例
 *
 *  @return 自己
 */
+ (SXAddressBookManager *)manager;

/**
 *  弹出联系人选择
 *
 *  @param target 从哪弹
 *  @param action 选择后的事件
 */
- (void)presentPageOnTarget:(id)target chooseAction:(SXAddressBookChooseAction)action;

/**
 *  向用户请求授权
 *
 *  @param success 成功后做什么
 *  @param failure 失败后做什么
 */
- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure;

/**
 *  获取授权状态
 *
 *  @return 状态
 */
- (SXAddressBookAuthStatus)getAuthStatus;

/**
 *  获取全部的用户信息
 *
 *  @return 模型数组
 */
- (NSArray *)getPersonInfoArray;

/**
 *  创建（添加）一条联系人
 *
 *  @param name  名字（只考虑中国人，去掉了middleName）
 *  @param phone 电话
 */
- (void)creatItemWithName:(NSString *)name phone:(NSString *)phone;

/**
 *  检查有无权限后直接执行代码
 *
 *  @param success 有权限操作
 *  @param failure 无权限操作
 */
- (void)checkStatusAndDoSomethingSuccess:(void (^)())success failure:(void (^)())failure;

@end
