//
//  SXAddressBookIOS7Maneger.m
//  SXEasyAddressBookDemo
//
//  Created by dongshangxian on 16/5/23.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "SXAddressBookIOS7Maneger.h"
#import <AddressBookUI/AddressBookUI.h>

@interface SXAddressBookIOS7Maneger ()<ABPeoplePickerNavigationControllerDelegate>

@property(nonatomic,copy) SXAddressBookChooseAction chooseAction;

@end

@implementation SXAddressBookIOS7Maneger

+ (SXAddressBookIOS7Maneger *)manager
{
    static SXAddressBookIOS7Maneger *sharedInstance = nil;
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
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
    ppnc.peoplePickerDelegate = self;
    [target presentViewController:ppnc animated:YES completion:nil];
}

- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
        if(granted){
            success();
        }else{
            failure();
        }
    });

}

- (SXAddressBookAuthStatus)getAuthStatus
{
    // 1.获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    

    if (status == kABAuthorizationStatusNotDetermined) {
        NSLog(@"还没问呢");
        return kSXAddressBookAuthStatusNotDetermined;
    }else if (status == kABAuthorizationStatusAuthorized){
        NSLog(@"已经授权");
        return kSXAddressBookAuthStatusAuthorized;
    }else if (status == kABAuthorizationStatusRestricted){
        NSLog(@"没有授权");
        return kSXAddressBookAuthStatusRestricted;
    }else{
        NSLog(@"没有授权");
        return kSXAddressBookAuthStatusDenied;
    }
    
}

- (NSArray *)getPersonInfoArray
{
    return nil;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    NSString *lastname = (__bridge_transfer NSString *)(lastName);
    NSString *firstname = (__bridge_transfer NSString *)(firstName);
    
    NSLog(@"%@ %@", lastname, firstname);
    NSLog(@"%@", phoneNO);
    
    SXPersonInfoEntity *personEntity = [SXPersonInfoEntity new];
    personEntity.lastname = lastname;
    personEntity.firstname = firstname;
    personEntity.phoneNumber = phoneNO;
    self.chooseAction(personEntity);
    
    if (phone) {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}


@end
