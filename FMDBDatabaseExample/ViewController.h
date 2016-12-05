//
//  ViewController.h
//  FMDBDatabaseExample
//
//  Created by CI013 on 1/27/15.
//  Copyright (c) 2015 CI013. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
   double animatedDistance;
}

@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userPhone;
@property (strong, nonatomic) IBOutlet UITextField *userEmail;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;

@property (strong, nonatomic) IBOutlet UITextField *userConfPassword;

@property (strong, nonatomic) IBOutlet UITextView *userAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

- (IBAction)btnClearAll:(id)sender;
- (IBAction)btnSubmit:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)addPhoto:(id)sender;

- (IBAction)btnDisplay:(id)sender;

@end

