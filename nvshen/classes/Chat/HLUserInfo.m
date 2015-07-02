//
//  WCUserInfo.m
//  WeChat
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLUserInfo.h"

#define UserKey @"user"
#define LoginStatusKey @"LoginStatus"
#define PwdKey @"pwd"



@implementation HLUserInfo

singleton_implementation(HLUserInfo)

-(void)saveUserInfoToSanbox{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserKey];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults synchronize];
    
}

-(void)loadUserInfoFromSanbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:UserKey];
    HLLog(@"self.user%@",self.user);
    self.loginStatus = [defaults boolForKey:LoginStatusKey];
    self.pwd = [defaults objectForKey:PwdKey];
}


-(NSString *)jid{
    return [NSString stringWithFormat:@"%@@%@",self.user,domain];
}
@end
