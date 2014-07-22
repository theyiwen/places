//
//  YJZDetailViewController.m
//  Places
//
//  Created by Yiwen Zhan on 7/19/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZDetailViewController.h"
#import "YJZPlace.h"
#import "YJZPlaceStore.h"
#import "YJZConstants.h"

@interface YJZDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *notesField;
@property (weak, nonatomic) IBOutlet UITextField *tagsField;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *ratings;

//@property (weak, nonatomic) IBOutlet UIButton *zeroRatingButton;
//@property (weak, nonatomic) IBOutlet UIButton *oneRatingButton;
//@property (weak, nonatomic) IBOutlet UIButton *twoRatingButton;
//@property (weak, nonatomic) IBOutlet UIButton *threeRatingButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rateButtons;

@property (nonatomic) NSArray *ratingColors;
@property (nonatomic) NSDictionary *rateDict;

@end

@implementation YJZDetailViewController

#pragma mark - init

- (instancetype)init
{
    return [self initWithPlace:nil];
}

- (instancetype)initWithPlace:(YJZPlace *)place
{
    self = [super init];
    if (self) {
        self.place = place;
        
        _ratingColors = @[GREEN_COLOR,
                          RED_COLOR,
                          ORANGE_COLOR,
                          YELLOW_COLOR];
        
        _rateDict = @{@"try":@0,@"love":@1,@"like":@2,@"okay":@3};

    }
    return self;
    
}

#pragma mark - editing and saving

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveTextFieldContent:textField];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self saveTextFieldContent:textField];
    [textField resignFirstResponder];
    return YES;
}

- (void)saveTextFieldContent:(UITextField *)textField
{
    if ([textField isEqual:self.nameField])
    {
        self.place.name = self.nameField.text;
    } else if ([textField isEqual:self.notesField]){
        self.place.notes = self.notesField.text;
    } else if ([textField isEqual:self.tagsField]) {
        [self.place setTagsWithString:self.tagsField.text];
    }
}

//- (IBAction)updateRating:(id)sender {
//    NSInteger newRating = self.ratings.selectedSegmentIndex;
//    [[YJZPlaceStore sharedStore] updateRating:newRating forPlace:self.place];
//}


#pragma mark - views appearing and disappearing

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nameField.text = self.place.name;
    self.notesField.text = self.place.notes;
    self.tagsField.text = [self.place getTagsAsString];
    for (NSString *s in self.place.tags)
    {
        [self.tagsField.text stringByAppendingString:[NSString stringWithFormat:@"%@, ",s]];
    }
//    self.ratingField.text = [NSString stringWithFormat:@"%i",self.place.rating];
    [self updateButtonStyles:self.place.rating];
//    self.ratings.selectedSegmentIndex = self.place.rating;

}
- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - old methods


- (IBAction)setRatingToOne:(id)sender {
//    self.ratingField.text = @"1";
    [self updateButtonStyles:1];
    [[YJZPlaceStore sharedStore] updateRating:1 forPlace:self.place];

}
- (IBAction)setRatingToZero:(id)sender {
//    self.ratingField.text = @"0";
    [self updateButtonStyles:0];
    [[YJZPlaceStore sharedStore] updateRating:0 forPlace:self.place];
}
- (IBAction)setRatingToTwo:(id)sender {
//    self.ratingField.text = @"2";
    [self updateButtonStyles:2];
    [[YJZPlaceStore sharedStore] updateRating:2 forPlace:self.place];


}
- (IBAction)setRatingToThree:(id)sender {
//    self.ratingField.text = @"3";
    [self updateButtonStyles:3];
    [[YJZPlaceStore sharedStore] updateRating:3 forPlace:self.place];
}

- (void)updateButtonStyles:(int)selectedRating {

    
    for (int i=0; i<[self.rateButtons count]; i++)
    {
        UIButton *button = self.rateButtons[i];
        int currentRating = (int)[self.rateDict[button.currentTitle] integerValue];
        
        if (currentRating != selectedRating) {
            [button setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        }
        else {
            [button setTitleColor:self.ratingColors[selectedRating] forState:UIControlStateNormal];
        }

    }



}

@end
