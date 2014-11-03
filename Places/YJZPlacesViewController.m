//
//  YJZPlacesViewController.m
//  Places
//
//  Created by Yiwen Zhan on 7/19/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZPlacesViewController.h"
#import "YJZPlaceStore.h"
#import "YJZPlace.h"
#import "YJZDetailViewController.h"
#import "YJZConstants.h"
#import "YJZAppDelegate.h"
#import "YJZAddViewController.h"
#import "YJZTableViewCell.h"

@interface YJZPlacesViewController ()

@property (strong, nonatomic) IBOutlet UIView *sectionView;

@property (nonatomic) NSArray *ratingColors;
@property (nonatomic) NSArray *listColors;
@property (nonatomic) NSArray *listNames;
@property (nonatomic) NSMutableArray *collapsedSections;

@end

@implementation YJZPlacesViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
//    if (self) {
//        _ratingColors = @[GREEN_COLOR,
//                          RED_COLOR,
//                          ORANGE_COLOR,
//                          YELLOW_COLOR];
//                
//        _collapsedSections = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0]];
//        
//        self.tableView.rowHeight = (CGFloat)76;
//        self.tableView.sectionHeaderHeight = (CGFloat)50;
//        self.navigationItem.title = @"places";
//    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (instancetype)initWithListIndex:(int)listIndex
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _listIndex = listIndex;
        _listColors = @[BLUE_COLOR,
                        RED_COLOR,
                        GREEN_COLOR];
        _listNames = @[@"try",@"love",@"been"];
        self.tableView.rowHeight = (CGFloat)76;
        self.navigationItem.title = self.listNames[self.listIndex];
        self.tableView.tableHeaderView.hidden = YES;
        
        // nav bar set up
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = bbi;
        UIBarButtonItem *ebbi =[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditingMode:)];
        self.navigationItem.leftBarButtonItem = ebbi;

    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[YJZPlaceStore sharedStore] places][self.listIndex] count];
//    if ([self.collapsedSections[section]  isEqual: @0])
//        return [[[YJZPlaceStore sharedStore] places][section] count];
//    else
//        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YJZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJZTableViewCell" forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 82, 0, 0)];
    }
    YJZPlace *place = [[YJZPlaceStore sharedStore] places][self.listIndex][indexPath.row];
    cell.nameLabel.text = place.name;
    cell.tagsLabel.text = place.getCatsAsString;
    cell.thumbnailView.image = place.thumbnail;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return [[[YJZPlaceStore sharedStore] places] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSArray *titles = @[@"try",@"love",@"like",@"okay"];
//    return titles[section];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"YJZTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"YJZTableViewCell"];
    
//    [[UINavigationBar appearance] setBarTintColor:GREEN_COLOR];
//    [[UINavigationBar appearance] setTranslucent:NO];
//    [[UINavigationBar appearance] setHidden:NO];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:self.listColors[self.listIndex]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)addNewItem:(id)sender
{
//    int i = (int)[((UIView*)sender).superview tag];
    YJZAddViewController *avc = [[YJZAddViewController alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self setEditing:NO animated:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YJZPlace *selectedPlace = [[YJZPlaceStore sharedStore] places][indexPath.section][indexPath.row];
        [[YJZPlaceStore sharedStore] removePlace:selectedPlace];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"X";
}


-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows forwards:(BOOL)forward {
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        int ip;
        if (forward)
            ip = i;
        else
            ip = numberOfRows-1-i;
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:ip inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
- (IBAction)collapseButtonTouched:(id)sender {
    [self sectionButtonTouchUpInside:sender];
}

-(void)sectionButtonTouchUpInside:(UIButton*)sender {
    [self.tableView beginUpdates];
    int section = (int)[sender.superview tag];
    //collapsing
    if ([self.collapsedSections[section]  isEqual: @0]) {
        int numOfRows = (int)[self tableView:self.tableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows forwards:NO];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        self.collapsedSections[section] = @1;
    }
    //expanding
    else {
        self.collapsedSections[section] = @0;
        int numOfRows = (int)[self tableView:self.tableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows forwards:YES];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
    //[_tableView reloadData];
}

//Q: ok to do initWithPlace?
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJZPlace *selectedPlace = [[YJZPlaceStore sharedStore] places][self.listIndex][indexPath.row];
    YJZDetailViewController *dvc = [[YJZDetailViewController alloc] initWithPlace:selectedPlace];
    [self.navigationController pushViewController:dvc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:self options:nil][0];
    UILabel *labelTitle =(UILabel*)[view viewWithTag:101];
    labelTitle.text =[@[@"try",@"love",@"like",@"okay"] objectAtIndex:section];
    view.backgroundColor = self.ratingColors[section];
    [view setTag:section];
    return view;
}
@end
