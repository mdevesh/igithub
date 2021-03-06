//
//  ProjectDetailViewController.m
//  iGitHub
//

#import "ProjectDetailViewController.h"
#import "CommitsViewController.h"
#import "ObjGit.h"

@implementation ProjectDetailViewController

@synthesize detailItem;


- (void)viewWillAppear:(BOOL)animated {
    // Update the view with current data before it is displayed
    [super viewWillAppear:animated];
    
    // Scroll the table view to the top before it appears
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
    self.title = [detailItem gitName];
}

// Standard table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There are two sections, for info and stats
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    switch (section) {
        case 0:
            // For project data, there is name
            rows = 1;
            break;
        case 1:
            // For the branches section, there is size
            rows = [[detailItem getAllRefs] count];
            break;
        default:
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"tvc";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *cellText = nil;
    
    switch (indexPath.section) {
        case 0:
            cellText = [detailItem gitName];
            break;
        case 1:
            cellText = [[[detailItem getAllRefs] objectAtIndex:indexPath.row] objectAtIndex:0];

            break;
        default:
            break;
    }
    
    cell.text = cellText;
    return cell;
}


/*
 Provide section titles
 HIG note: In this case, since the content of each section is obvious, there's probably no need to provide a title, but the code is useful for illustration.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Project Info", @"Git Project Information");
            break;
        case 1:
            title = NSLocalizedString(@"Branches", @"Git Project Refs");
            break;
        default:
            break;
    }
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommitsViewController *commitsViewController = [[CommitsViewController alloc] initWithStyle:UITableViewStylePlain];
	NSArray *refArray = [[detailItem getAllRefs] objectAtIndex:indexPath.row];
	NSLog(@"refs:%@", refArray);
	
    commitsViewController.gitRepo = detailItem;
    commitsViewController.gitRef  = [refArray objectAtIndex:0];
    commitsViewController.gitSha  = [refArray objectAtIndex:1];
    
	NSLog(@"TEST");

    // Push the commit view controller
    [[self navigationController] pushViewController:commitsViewController animated:YES];
    [commitsViewController release];
}

@end
