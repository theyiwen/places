//
//  YJZAddViewController.m
//  Places
//
//  Created by Yiwen Zhan on 7/24/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZAddViewController.h"
#import "YJZAPIConstants.h"
#import "YJZConstants.h"
#import "YJZPlaceStore.h"
#import "YJZPLace.h"
#import "YJZDetailViewController.h"
#import "YJZAddViewCell.h"

@interface YJZAddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (nonatomic, strong) id dataObject;
@property (nonatomic, strong) NSMutableArray *venueData;

@property (nonatomic, strong) UIColor *separatorColor;

@end

@implementation YJZAddViewController

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
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    self.overlay.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:self.overlay atIndex:0];

    //table view setup
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = (CGFloat)50;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.separatorColor = self.tableView.separatorColor;
    self.tableView.separatorColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:@"YJZAddViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"YJZAddViewCell"];
    
    //text field setup
    self.textField.delegate = self;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    
    self.loading.hidesWhenStopped = YES;

    self.view.backgroundColor = [UIColor clearColor];
//    NSLog(@"post load subviews: %i",[self.view.subviews count]);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //pre animated state
    self.overlay.alpha = 0;
    self.addView.hidden = YES;
    self.textView.hidden = YES;
    
    //putting it here makes keyboard animate at the same time, but sideways
//    [self.textField becomeFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self animdateInInputView];

}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self animateOutView];
    [super viewWillDisappear: animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UIView *bgView = self.view.subviews[0];
    [bgView removeFromSuperview];
//    NSLog(@"post clean subviews: %i",[self.view.subviews count]);


    
}
- (IBAction)backgroundTouched:(id)sender {
    [self animateOutViewPush:false forVC:nil];
}

-(void)animateOutViewPush:(BOOL)push forVC:(YJZDetailViewController *)dvc {
    [self.textField resignFirstResponder];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.addView.frame = CGRectMake(5,-350,self.addView.bounds.size.width,self.textView.bounds.size.height);
                         self.overlay.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         if (push) {
                             [self.navigationController pushViewController:dvc animated:YES];
                         }
                         else {
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.loading startAnimating];
    [self fetchPlaces:textField.text];
    return YES;
}

- (void)animdateInInputView
{
    self.textView.hidden = NO;
    
    self.addView.frame = CGRectMake(5,-350,self.addView.bounds.size.width,self.textView.bounds.size.height);
    self.addView.hidden = NO;

    [self.textField becomeFirstResponder];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.addView.frame = CGRectMake(5,5,self.addView.bounds.size.width,self.textView.bounds.size.height);
                         self.overlay.alpha = 0.7;
                     } completion:^(BOOL finished) {
                         
                     }];

}

- (void)animateOutView
{
    NSLog(@"here");
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.addView.frame = CGRectMake(5,-330,self.addView.bounds.size.width,self.textView.bounds.size.height);
                         self.overlay.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         
                     }];
    [UIView commitAnimations];
    [self.view setNeedsDisplay];
    
}
//- (void)animateInTableView
//{
//    [self.loading stopAnimating];
//    self.tableView.hidden = NO;
//    self.tableView.frame = CGRectMake(5, 500, self.tableView.frame.size.width, self.tableView.frame.size.height);
//    
//    [UIView animateWithDuration:0.5
//                          delay:0
//         usingSpringWithDamping:0.7
//          initialSpringVelocity:0.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         self.tableView.frame = CGRectMake(5, 100, self.tableView.frame.size.width, self.tableView.frame.size.height);
//                     } completion:^(BOOL finished) {
//                         
//                     }];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25.0)];
    
        // 2. Set a custom background color and a border
        headerView.backgroundColor = BLUE_COLOR;
    
        // 3. Add a label
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(10, 2, tableView.frame.size.width - 10, 21);
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:12.0];
        headerLabel.text = @"RESULTS";
        headerLabel.textAlignment = NSTextAlignmentLeft;
    
        // 4. Add the label to the header view
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.venueData count];
}

- (void)fetchPlaces:(NSString *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@search?near=San Francisco, CA&query=%@&intent=browse&categoryId=%@&client_id=%@&client_secret=%@&v=20140723",
                           API_URL,query,FOOD_CAT,CLIENT_ID,CLIENT_SECRET];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error != nil) {
                                                    NSLog(@"Error: %@",error);
                                                } else {
                                                    NSError *err;
                                                    self.dataObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:0
                                                                                                        error:&err];
                                                    self.venueData = self.dataObject[@"response"][@"venues"];
                                                    NSLog(@"data dump done");
                                                    
                                                    dispatch_async(dispatch_get_main_queue(),^{
                                                        [self.loading stopAnimating];
                                                        self.tableView.separatorColor = self.separatorColor;
                                                        [self.tableView reloadData];
                                                        if (self.tableView.hidden == YES)
                                                        {
                                                            self.tableView.hidden = NO;
                                                        }
//                                                            [self animateInTableView];
                                                    }
                                                                   );
                                                    if (self.dataObject == nil)
                                                        NSLog(@"Error: %@", err);
                                                }
                                            }];
    [task resume];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJZAddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJZAddViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.nameLabel.text = self.venueData[indexPath.row][@"name"];
    cell.subLabel.text = self.venueData[indexPath.row][@"location"][@"address"];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];

    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJZPlace *newPlace = [[YJZPlace alloc] initWithFSData:self.venueData[indexPath.row] rating:0];
    NSLog(@"%f, %f",newPlace.latitude,newPlace.longitude);
    [[YJZPlaceStore sharedStore] addPlace:newPlace];
    YJZDetailViewController *dvc = [[YJZDetailViewController alloc] initWithPlace:newPlace];
    [self animateOutViewPush:true forVC:dvc];
//    [self.navigationController pushViewController:dvc animated:YES];
}

@end
