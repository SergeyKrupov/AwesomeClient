//
//  OAuthLoginViewController.m
//  AwesomeClient
//
//  Created by Sergey on 31/10/15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//

#import "OAuthLoginViewController.h"
#import "HomeController.h"

@interface OAuthLoginViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation OAuthLoginViewController

@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    InstagramKitLoginScope scope = InstagramKitLoginScopeBasic;
    NSURL *url = [[InstagramEngine sharedEngine] authorizationURLForScope:scope];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    if ([url.scheme isEqualToString:@"awesomeclient"]) {
        NSArray *parts = [url.fragment componentsSeparatedByString:@"="];
        if (parts.count == 2 && [parts[0] isEqualToString:@"access_token"]) {
            [[InstagramEngine sharedEngine] setAccessToken:parts[1]];
            [self performSegueWithIdentifier:@"ShowCollectionSegue" sender:self];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[HomeController class]]) {
        ((HomeController *)dest).accountName = @"racoonsgroup";
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
