//
//  EnterPhoneSignUpViewController.m
//  onepick
//
//  Created by yiqin on 5/11/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "EnterPhoneSignUpViewController.h"

@interface EnterPhoneSignUpViewController ()

@end

@implementation EnterPhoneSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Phone";
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneNumber becomeFirstResponder];
    NSLog(@"Enter the Phone.");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveToEnterAddress:(id)sender {
    //This is the input string that is either an email or phone number
    NSString *input = self.phoneNumber.text;
    
    //This is the string that is going to be compared to the input string
    NSString *testString = [NSString string];
    
    NSScanner *scanner = [NSScanner scannerWithString:input];
    
    //This is the character set containing all digits. It is used to filter the input string
    NSCharacterSet *skips = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    
    //This goes through the input string and puts all the
    //characters that are digits into the new string
    [scanner scanCharactersFromSet:skips intoString:&testString];
    
    //If the string containing all the numbers has the same length as the input...
    if([input length] == [testString length] && [input length] == 10) {
        NSLog(@"great");
        [[NSUserDefaults standardUserDefaults] setObject:input forKey:@"tempPhone"];
        [self performSegueWithIdentifier: @"MoveToEnterAddress" sender: self];
    }
    else {
        UIAlertView *reenterPhone = [[UIAlertView alloc] initWithTitle:@"Enter Your Phone Number"
                                                               message:@"The number must be 10 digits."
                                                              delegate:self
                                                     cancelButtonTitle:@"Back"
                                                     otherButtonTitles:nil];
        [reenterPhone show];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
