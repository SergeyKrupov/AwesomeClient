//
//  LoginController.m
//  AwesomeClient
//
//  Created by Sergey on 31/10/15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//

#import "LoginController.h"
#import "OAuthLoginViewController.h"

@interface LoginController ()

@end

@implementation LoginController

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
#if 0
    UIViewController *dest = segue.destinationViewController;
    if ([dest isKindOfClass:[OAuthLoginViewController class]]) {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            if ([cookie.domain isEqualToString:@"instagram.com"])
                [storage deleteCookie:cookie];
        }
    }
#endif
}


@end
