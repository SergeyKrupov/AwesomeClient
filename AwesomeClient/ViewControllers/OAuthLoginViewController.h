//
//  OAuthLoginViewController.h
//  AwesomeClient
//
//  Created by Sergey on 31/10/15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OAuthLoginViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
