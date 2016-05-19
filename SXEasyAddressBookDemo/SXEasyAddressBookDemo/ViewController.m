//
//  ViewController.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/19.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "ViewController.h"
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import <ContactsUI/ContactsUI.h>

@interface ViewController ()<CNContactPickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self checkStatus];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)checkStatus
{
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    //     2.判断授权状态,如果不是已经授权,则直接返回
    
    if (status == CNAuthorizationStatusNotDetermined) {
        [[[CNContactStore alloc]init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"未选择过");
            if(granted){
                NSLog(@"选择了同意");
                [self loadPerson];
            }else{
                NSLog(@"拒绝了");
            }
        }];
        
    }else if (status == CNAuthorizationStatusAuthorized){
        [self loadPerson];
    }else {
        // 弹窗显示
    }
}

- (void)loadPerson
{
    // 3.创建通信录对象
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    // 4.创建获取通信录的请求对象
    // 4.1.拿到所有打算获取的属性对应的key
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    
    // 4.2.创建CNContactFetchRequest对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    
    // 5.遍历所有的联系人
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        // 1.获取联系人的姓名
        NSString *lastname = contact.familyName;
        NSString *firstname = contact.givenName;
        NSLog(@"%@ %@", lastname, firstname);
        
        // 2.获取联系人的电话号码
        NSArray *phoneNums = contact.phoneNumbers;
        for (CNLabeledValue *labeledValue in phoneNums) {
            // 2.1.获取电话号码的KEY
            NSString *phoneLabel = labeledValue.label;
            
            // 2.2.获取电话号码
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            
            NSLog(@"%@ %@", phoneLabel, phoneValue);
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1.创建选择联系人的控制器
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    
    // 2.设置代理
    contactVc.delegate = self;
    
    // 3.弹出控制器
    [self presentViewController:contactVc animated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSLog(@"%@ %@", lastname, firstname);
    
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.1.获取电话号码的KEY
        NSString *phoneLabel = labeledValue.label;
        
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        
        NSLog(@"%@ %@", phoneLabel, phoneValue);
    }
}

// 当选中某一个联系人的某一个属性时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"选中联系人属性");
}

// 点击了取消按钮会执行该方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"点击取消后的代码");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
