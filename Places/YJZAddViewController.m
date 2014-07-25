//
//  YJZAddViewController.m
//  Places
//
//  Created by Yiwen Zhan on 7/24/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZAddViewController.h"
#import "YJZAPIConstants.h"
#import "YJZPlaceStore.h"
#import "YJZPLace.h"
#import "YJZDetailViewController.h"

@interface YJZAddViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@property (nonatomic, strong) id dataObject;
@property (nonatomic, strong) NSMutableArray *venueData;

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.hidden = YES;
    self.textField.delegate = self;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.tableView.rowHeight = (CGFloat)50;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.view.backgroundColor = [UIColor clearColor];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{

    [self.textField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIView *bgView = self.view.subviews[0];
    UIView *blackView = self.view.subviews[1];
    [blackView removeFromSuperview];
    [bgView removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self fetchPlaces:textField.text];
//    [textField resignFirstResponder];
    return YES;
}
- (void)animateInTableView
{
    self.tableView.hidden = NO;
    self.tableView.frame = CGRectMake(5, 500, self.tableView.frame.size.width, self.tableView.frame.size.height);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.tableView.frame = CGRectMake(5, 100, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.venueData count];
}

- (void)fetchPlaces:(NSString *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@?near=San Francisco, CA&query=%@&intent=browse&categoryId=%@&client_id=%@&client_secret=%@&v=20140723",
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
                                                        
                                                        [self.tableView reloadData];
                                                        if (self.tableView.hidden == YES)
                                                            [self animateInTableView];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.venueData[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJZPlace *newPlace = [[YJZPlace alloc] initWithFSData:self.venueData[indexPath.row] rating:0];
    [[YJZPlaceStore sharedStore] addPlace:newPlace];
    YJZDetailViewController *dvc = [[YJZDetailViewController alloc] initWithPlace:newPlace];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
