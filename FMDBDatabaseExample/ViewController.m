//
//  ViewController.m
//  FMDBDatabaseExample
//
//  Created by CI013 on 1/27/15.
//  Copyright (c) 2015 CI013. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "DisplayData.h"
@interface ViewController ()
{
     UIImagePickerController *ipc;
     FMDatabase *database;
     NSDate *date;
     NSDateFormatter *dateFormat;
}
@end

@implementation ViewController
@synthesize userAddress,userName,userPhone,userEmail,lblDate,userImage,userConfPassword,userPassword;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set Navigation Bar Hidden YES
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //set the path of database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"path : - %@",path);
    
    //create the database
    database = [FMDatabase databaseWithPath:path];
    
    //Open the Database
    [database open];
    [database executeUpdate:@"create table detail(name text,password text,email text,phone text,address text,date text,image text)"];
    
    
    //Today Date:-
    date = [NSDate date];
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"DD,MM,yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    lblDate.text=dateString;
    //------------------
    
    //set the border in textView
    [[userAddress layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[userAddress layer] setBorderWidth:2.3];
    [[userAddress layer] setCornerRadius:15];
    //-------------------------
}
- (IBAction)addPhoto:(id)sender
{
    ipc= [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

- (IBAction)btnDisplay:(id)sender
{
    DisplayData *dsp=[[DisplayData alloc]initWithNibName:@"DisplayData" bundle:nil];
    [self.navigationController pushViewController:dsp animated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    userImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSubmit:(id)sender
{
    /*This is for name of image*/
    date = [NSDate date];
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"DDMMyyyyhhmmss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    //--------------------------------------------------------
    
    if(userImage.image!=nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path= [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.png",dateString]];
        NSData* data = UIImagePNGRepresentation(userImage.image);
        [data writeToFile:path atomically:YES];
        NSLog(@"Path %@",path);
    }
    
    //set the image name
    NSString *saveIamge=[NSString stringWithFormat:@"%@.png",dateString];
    
    
    [database open];
     // Building the string ourself
     NSString *query = [NSString stringWithFormat:@"insert into detail values('%@','%@','%@','%@','%@','%@','%@')",userName.text,userPassword.text,userEmail.text,userPhone.text,userAddress.text,lblDate.text,saveIamge];
     [database executeUpdate:query];
    
}
- (IBAction)btnClearAll:(id)sender
{
    userImage.image=nil;
    userAddress.text=nil;
    userEmail.text=nil;
    userName.text=nil;
    userPhone.text=nil;
}
- (IBAction)btnCancel:(id)sender
{
    exit(0);
}


/*text field return and updown*/
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextView *)textView
{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField * )textField
{
    // [TitleOfPosting resignFirstResponder];
    [userName resignFirstResponder];
    [userEmail resignFirstResponder];
    [userPhone resignFirstResponder];
    [userAddress resignFirstResponder];
    
    return YES;
    // Do the search...
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userName resignFirstResponder];
    [userEmail resignFirstResponder];
    [userPhone resignFirstResponder];
    [userAddress resignFirstResponder];
    UITouch *touch =[touches anyObject];
    if (touch.phase ==UITouchPhaseBegan)
    {
        [self.view endEditing:YES];
    }
}
/*-------------------------------------------------------*/
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect textFieldRect = [self.view.window convertRect:userAddress.bounds fromView:userAddress];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [userAddress resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [userAddress resignFirstResponder];
        return NO;
    }
    return YES;
}
/*-----------------------------------*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
