//
//  SXAddressBookIOS9Maneger.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "SXAddressBookIOS9Maneger.h"
#import <ContactsUI/ContactsUI.h>

@interface SXAddressBookIOS9Maneger ()<CNContactPickerDelegate>

@property(nonatomic,copy) SXAddressBookChooseAction chooseAction;

@end

@implementation SXAddressBookIOS9Maneger

+ (SXAddressBookIOS9Maneger *)manager
{
    static SXAddressBookIOS9Maneger *sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

- (void)presentPageOnTarget:(id)target chooseAction:(SXAddressBookChooseAction)action{
    self.chooseAction = action;
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
//    这行代码false就是可以点进详通讯录情页，true就是点击列表页就返回
    contactVc.predicateForSelectionOfContact = [NSPredicate predicateWithValue:false];
    contactVc.delegate = self;
    [target presentViewController:contactVc animated:YES completion:nil];
}

- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure
{
    [[[CNContactStore alloc]init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failure();
            });
        }
    }];
}

- (SXAddressBookAuthStatus)getAuthStatus
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (status == CNAuthorizationStatusNotDetermined) {
        return kSXAddressBookAuthStatusNotDetermined;
    }else if (status == CNAuthorizationStatusAuthorized){
        return kSXAddressBookAuthStatusAuthorized;
    }else if (status == CNAuthorizationStatusDenied){
        return kSXAddressBookAuthStatusDenied;
    }else{
        return kSXAddressBookAuthStatusRestricted;
    }
}

- (NSArray *)getPersonInfoArray
{
    NSMutableArray *personArray = [NSMutableArray array];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        SXPersonInfoEntity *personEntity = [SXPersonInfoEntity new];
        NSString *lastname = contact.familyName;
        NSString *firstname = contact.givenName;
        personEntity.lastname = lastname;
        personEntity.firstname = firstname;
        
        NSMutableString *fullname = [[NSString stringWithFormat:@"%@%@",lastname,firstname] mutableCopy];
        [fullname replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, fullname.length)];
        personEntity.fullname = fullname;
        
        NSArray *phoneNums = contact.phoneNumbers;
        NSString *fullPhoneStr = [NSString string];
        for (CNLabeledValue *labeledValue in phoneNums) {
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            if (phoneValue.length > 0) {
                fullPhoneStr = [fullPhoneStr stringByAppendingString:phoneValue];
                fullPhoneStr = [fullPhoneStr stringByAppendingString:@","];
            }
        }
        if (fullPhoneStr.length > 1) {
            personEntity.phoneNumber = [fullPhoneStr substringToIndex:fullPhoneStr.length - 1];
        }
        [personArray addObject:personEntity];
    }];
    return personArray;
}

/**
 *  这个方法是点击列表缩回就回调的方法，现在不会调用了
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    SXPersonInfoEntity *personEntity = [SXPersonInfoEntity new];
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSLog(@"%@ %@", lastname, firstname);
    personEntity.lastname = lastname;
    personEntity.firstname = firstname;
    
    NSMutableString *fullname = [[NSString stringWithFormat:@"%@%@",lastname,firstname] mutableCopy];
    [fullname replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, fullname.length)];
    personEntity.fullname = fullname;
    
    NSString *fullPhoneStr = [NSString string];
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        if (phoneValue.length > 0) {
            fullPhoneStr = [fullPhoneStr stringByAppendingString:phoneValue];
            fullPhoneStr = [fullPhoneStr stringByAppendingString:@","];
        }
    }
    if (fullPhoneStr.length > 1) {
        personEntity.phoneNumber = [fullPhoneStr substringToIndex:fullPhoneStr.length - 1];
    }
    self.chooseAction(personEntity);
}

/**
 *  这个是点击详情页里面的一个字段才回调的方法
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"选中用户 %@ %@",contactProperty.contact.givenName,contactProperty.contact.familyName);
    [contactProperty.contact.phoneNumbers indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CNLabeledValue *phoneObj = (CNLabeledValue *)obj;
        if([contactProperty.identifier isEqualToString:phoneObj.identifier]){
            
            CNPhoneNumber *phoneNumer = phoneObj.value;
            NSString *phoneValue = phoneNumer.stringValue;
            NSLog(@"选中联系人属性 %@",phoneValue);
            SXPersonInfoEntity *personEntity = [SXPersonInfoEntity new];
            personEntity.lastname = contactProperty.contact.familyName;
            personEntity.firstname = contactProperty.contact.givenName;
            NSMutableString *fullname = [[NSString stringWithFormat:@"%@ %@",personEntity.firstname,personEntity.lastname] mutableCopy];
            [fullname replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, fullname.length)];
            personEntity.fullname = fullname;
            personEntity.phoneNumber = phoneValue;
            self.chooseAction(personEntity);
            return true;
        }else{
            return false;
        }
    }];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"点击取消后的代码");
}

- (void)creatItemWithName:(NSString *)name phone:(NSString *)phone
{
    // 创建对象
    // 这个里面可以添加多个电话，email，地址等等。 感觉使用率不高，只提供了最常用的属性：姓名+电话，需要时可以自行扩展。
    CNMutableContact * contact = [[CNMutableContact alloc]init];
    contact.givenName = name?:@"defaultname";
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:phone?:@"10086"]];
    contact.phoneNumbers = @[phoneNumber];
    
    // 把对象加到请求中
    CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    
    // 执行请求
    CNContactStore * store = [[CNContactStore alloc]init];
    [store executeSaveRequest:saveRequest error:nil];
}

@end
