//
//  ViewController2.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/19.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

// 这个类用来做iOS8的操作
#import "ViewController2.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController2 ()<ABPeoplePickerNavigationControllerDelegate>

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkStatus];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1.创建选择联系人的控制器
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
    
    ppnc.peoplePickerDelegate = self;
    
    [self presentViewController:ppnc animated:YES completion:nil];
}

#pragma mark - <ABPeoplePickerNavigationControllerDelegate>
// 当用户选中某一个联系人时会执行该方法,并且选中联系人后会直接退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    // 1.获取选中联系人的姓名
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    NSString *lastname = (__bridge_transfer NSString *)(lastName);
    NSString *firstname = (__bridge_transfer NSString *)(firstName);
    
    NSLog(@"%@ %@", lastname, firstname);
    
    // 2.获取选中联系人的电话号码
    // 2.1.获取所有的电话号码
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    
    // 2.2.遍历拿到每一个电话号码
    for (int i = 0; i < phoneCount; i++) {
        // 2.2.1.获取电话对应的key
        NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
        
        // 2.2.2.获取电话号码
        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        
        NSLog(@"%@ %@", phoneLabel, phoneValue);
    }
    
    // 注意:管理内存
    CFRelease(phones);
}

// 当用户选中某一个联系人的某一个属性时会执行该方法,并且选中属性后会退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"%s", __func__);
    NSLog(@"%@--%d---%d", person,property,identifier);
}

- (void)checkStatus
{
    // 1.获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (status == kABAuthorizationStatusNotDetermined) {
        NSLog(@"还没问呢");
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            if(granted){
                NSLog(@"选择了同意");
            }else{
                NSLog(@"拒绝了");
            }
        });
    }else if (status == kABAuthorizationStatusAuthorized){
        NSLog(@"已经授权");
        [self loadPerson];
    }else {
        NSLog(@"没有授权");
        // 弹窗提示去获取权限
    }
    
    
}

- (void)loadPerson
{
    // 3.创建通信录对象
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // 4.获取所有的联系人
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    
    // 5.遍历所有的联系人
    for (int i = 0; i < peopleCount; i++) {
        // 5.1.获取某一个联系人
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        // 5.2.获取联系人的姓名
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSLog(@"%@ %@", lastName, firstName);
        
        // 5.3.获取电话号码
        // 5.3.1.获取所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        
        // 5.3.2.遍历拿到每一个电话号码
        for (int i = 0; i < phoneCount; i++) {
            // 1.获取电话对应的key
            NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            
            // 2.获取电话号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            
            NSLog(@"%@ %@", phoneLabel, phoneValue);
        }
        
        CFRelease(phones);
    }
    
    CFRelease(addressBook);
    CFRelease(peopleArray);
}

#pragma clang diagnostic pop

@end
