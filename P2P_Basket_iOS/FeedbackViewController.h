//
//  FeedbackViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-14.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FeedbackViewController : UIViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate>
{
    UITextView *textView;
}
@end
