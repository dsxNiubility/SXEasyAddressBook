//
//  ViewController3.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/19.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

// 这个类用来做iOS7的操作
#import "ViewController3.h"
#import <AddressBookUI/AddressBookUI.h>
#import "SXAddressBookManager.h"

@interface ViewController3 ()<ABPeoplePickerNavigationControllerDelegate>

@property(nonatomic,strong)NSArray<SXPersonInfoEntity *>*personEntityArray;

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self checkStatus];
    
    SXAddressBookAuthStatus status = [[SXAddressBookManager manager]getAuthStatus];
    if (status == kSXAddressBookAuthStatusNotDetermined) {
        [[SXAddressBookManager manager]askUserWithSuccess:^{
            self.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
        } failure:^{
            NSLog(@"失败");
        }];
    }else if (status == kSXAddressBookAuthStatusAuthorized){
        self.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
    }else{
        NSLog(@"没有权限");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[SXAddressBookManager manager]presentPageOnTarget:self chooseAction:^(SXPersonInfoEntity *person) {
        NSLog(@"%@---%@",person.fullname,person.phoneNumber);
    }];
}

@end
