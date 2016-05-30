# SXEasyAddressBook
on iOS 7 8 9
>苹果的通讯录功能在iOS7,iOS8,iOS9 都有着一定的不同，iOS7和8用的是 <AddressBookUI/AddressBookUI.h> ，但是两个系统版本的代理方法有一些变化，有些代理方法都标注了 NS_DEPRECATED_IOS(2_0, 8_0) 并推荐了另一个代理方法与之对应。  而iOS8到iOS9则是直接弃用了<AddressBookUI/AddressBookUI.h>取而代之的是<ContactsUI/ContactsUI.h>，后者是OC调用，据说当时苹果宣布弃用AddressBookUI还引来了阵阵欢呼。这也就是在使用通讯录功能时得考虑版本各种判断，我也就是工作中遇到了这种坑，然后就顺手兼容封装了一下。希望能解决这个问题。

###在用SXEasyAddressBook之前
想做通讯录相关操作时能需要写很多冗长代码，类似于这样

	ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    NSMutableArray *personArray = [NSMutableArray array];
    for (int i = 0; i < peopleCount; i++) {
        
        SXPersonInfoEntity *personEntity = [SXPersonInfoEntity new];
        
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSLog(@"%@ %@", lastName, firstName);
        personEntity.lastname = lastName;
        personEntity.firstname = firstName;
        
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        
        NSString *fullPhoneStr = [NSString string];
        for (int i = 0; i < phoneCount; i++) {
            NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSLog(@"%@ %@", phoneLabel, phoneValue);
            if (phoneValue.length > 0) {
                fullPhoneStr = [fullPhoneStr stringByAppendingString:phoneValue];
                fullPhoneStr = [fullPhoneStr stringByAppendingString:@","];
            }
        }
        .......
而且还要考虑iOS7,iOS8，iOS9的不同写法各种版本判断等等等等....
<br />
<br />


##在用了SXEasyAddressBook之后
我们目前最关心的三种通讯录操作是

* 点击弹出通讯录页面，选择了一个联系人的电话后直接将信息填到页面输入框内。
* 遍历所有的通讯录数据统一做批量操作，搭建新页面或直接上传。
* 给通讯录写入一条信息。

在库的内部做了很多版本控制和封装，最后开发便捷的api<br />
首先引入头文件

	#import "SXAddressBookManager.h"

#####1.检查权限
有两种方法，第二种更加简便，其中success回调的场景是 用户首次点击了同意 + 本来就有权限 ，其中failure回调的场景是 用户首次点击了拒绝 + 本来就没有权限

	- (void)checkStatus1
	{
    SXAddressBookAuthStatus status = [[SXAddressBookManager manager]getAuthStatus];
    if (status == kSXAddressBookAuthStatusNotDetermined) {
        [[SXAddressBookManager manager]askUserWithSuccess:^{
            NSLog(@"点击同意");
        } failure:^{
            NSLog(@"点击拒绝");
        }];
    }else if (status == kSXAddressBookAuthStatusAuthorized){
        NSLog(@"已有权限");
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
	
####2.弹出通讯录选择窗口
	- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
	{
    [[SXAddressBookManager manager]presentPageOnTarget:self chooseAction:^(SXPersonInfoEntity *person) {
        NSLog(@"%@---%@",person.fullname,person.phoneNumber);
    }];
	}
	
####3.获取整个通讯录信息
	self.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
	
####4.写入一条数据
	[[SXAddressBookManager manager]creatItemWithName:@"雷克萨斯-北京咨询电话" phone:@"010-88657869"];