//
//  STViewController.m
//  SampleToPostUsingFacebookSDK
//
//  Created by Trieu Khang on 1/31/13.
//  Copyright (c) 2013 Hoang Trieu Khang. All rights reserved.
//

#import "STViewController.h"

@interface STViewController () <FBLoginViewDelegate>

@property (strong,nonatomic) id<FBGraphUser> loginUser;
@property (weak, nonatomic) IBOutlet UILabel *userFirstName;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FBLoginView *fbLoginView = [[FBLoginView alloc] init];
    
    fbLoginView.frame = CGRectOffset(fbLoginView.frame, 5, 5);
    fbLoginView.delegate = self;
    
    [self.view addSubview:fbLoginView];
    
    [fbLoginView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)postButton:(id)sender {
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    self.loginUser = user;
    
    self.userFirstName.text = user.first_name;
    
    NSLog(@"%@", self.loginUser.first_name);
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.userFirstName.text = nil;
    self.loginUser = nil;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    self.userFirstName.text = self.loginUser.first_name;
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
    
}


@end
