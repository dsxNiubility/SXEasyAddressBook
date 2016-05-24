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
//    这行代码打开就是可以点进详通讯录情页，但是无法监听具体点了哪个，所以设置默认做法。
//    contactVc.predicateForSelectionOfContact = [NSPredicate predicateWithValue:false];
    contactVc.delegate = self;
    [target presentViewController:contactVc animated:YES completion:nil];
}

- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure
{
    [[[CNContactStore alloc]init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            success();
        }else{
            failure();
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
        NSLog(@"%@ %@", lastname, firstname);
        personEntity.lastname = lastname;
        personEntity.firstname = firstname;
        
        if ((lastname.length > 1) && (firstname.length > 1)) {
            personEntity.fullname = [firstname stringByAppendingString:lastname];
        }else if ((lastname.length > 1) && (firstname.length < 1)){
            personEntity.fullname = lastname;
        }else if ((lastname.length < 1) && (firstname.length > 1)){
            personEntity.fullname = firstname;
        }else{
            personEntity.fullname = @"noName";
        }
        
        NSArray *phoneNums = contact.phoneNumbers;
        NSString *fullPhoneStr = [NSString string];
        for (CNLabeledValue *labeledValue in phoneNums) {

            NSString *phoneLabel = labeledValue.label;
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            
            NSLog(@"%@ %@", phoneLabel, phoneValue);
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

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    SXPersonInfoEntity *personEntity = [SXPersonInfoEntity new];
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSLog(@"%@ %@", lastname, firstname);
    personEntity.lastname = lastname;
    personEntity.firstname = firstname;
    
    if ((lastname.length > 1) && (firstname.length > 1)) {
        personEntity.fullname = [firstname stringByAppendingString:lastname];
    }else if ((lastname.length > 1) && (firstname.length < 1)){
        personEntity.fullname = lastname;
    }else if ((lastname.length < 1) && (firstname.length > 1)){
        personEntity.fullname = firstname;
    }else{
        personEntity.fullname = @"noName";
    }
    
    NSString *fullPhoneStr = [NSString string];
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        
        NSString *phoneLabel = labeledValue.label;
        
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        
        NSLog(@"%@ %@", phoneLabel, phoneValue);
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

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
//    NSLog(@"%@",contactProperty.contact.identifier);
//    NSUInteger count = [[NSArray array]indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    }];
    NSLog(@"选中联系人属性");
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"点击取消后的代码");
}

@end
