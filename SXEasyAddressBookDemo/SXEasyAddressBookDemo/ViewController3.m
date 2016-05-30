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
    
//    [self checkStatus1];
    [self checkStatus2];

}

- (void)checkStatus1
{
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


- (void)checkStatus2
{
    [[SXAddressBookManager manager]checkStatusAndDoSomethingSuccess:^{
        NSLog(@"已经有权限，做相关操作，可以做读取通讯录等操作");
    } failure:^{
        NSLog(@"未得到权限，做相关操作，可以做弹窗询问等操作");
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[SXAddressBookManager manager]presentPageOnTarget:self chooseAction:^(SXPersonInfoEntity *person) {
        NSLog(@"%@---%@",person.fullname,person.phoneNumber);
    }];
}

@end
