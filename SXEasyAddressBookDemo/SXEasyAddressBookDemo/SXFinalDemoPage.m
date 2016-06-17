//
//  ViewController3.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/19.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

// 这个类用来做所有版本的操作
#import "SXFinalDemoPage.h"
#import "SXAddressBookManager.h"

@interface SXFinalDemoPage ()

@property(nonatomic,strong)NSArray<SXPersonInfoEntity *>*personEntityArray;

@end

@implementation SXFinalDemoPage

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
        [[SXAddressBookManager manager]creatItemWithName:@"雷克萨斯-北京咨询电话" phone:@"010-88657869"];
        self.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
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
