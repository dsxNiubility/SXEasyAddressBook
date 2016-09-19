//
//  SXAddressBookDefine.h
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPersonInfoEntity.h"

#define IOS7_OR_EARLY_SX   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending )
#define IOS9_OR_LATER_SX   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS8_SX  ((!IOS7_OR_EARLY_SX) && (!IOS9_OR_LATER_SX))

// 因为iOS89不一样，所以做一个统一
typedef NS_ENUM(NSUInteger, SXAddressBookAuthStatus) {
    kSXAddressBookAuthStatusNotDetermined = 0,
    kSXAddressBookAuthStatusRestricted,
    kSXAddressBookAuthStatusDenied,
    kSXAddressBookAuthStatusAuthorized
};

typedef void(^SXAddressBookChooseAction)(SXPersonInfoEntity *person);

@interface SXAddressBookDefine : NSObject

@end
