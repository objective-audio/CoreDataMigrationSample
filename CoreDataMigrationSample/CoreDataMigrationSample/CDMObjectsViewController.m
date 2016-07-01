//
//  CDMObjectsViewController.m
//

#import "CDMObjectViewController.h"
#import "CDMObjectsViewController.h"
#import "CDMTypes.h"

static NSString *const CDMObjectsCelllIdentifier = @"ObjectsCell";

@interface CDMObjectsViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchResultsController;

@end

@implementation CDMObjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    assert(self.context);
    assert(self.entityName);

    self.title = [[NSString alloc] initWithFormat:@"%@ objects", self.entityName];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:CDMNameKey ascending:YES]];

    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                      managedObjectContext:self.context
                                                                        sectionNameKeyPath:nil
                                                                                 cacheName:nil];
    self.fetchResultsController.delegate = self;

    [self.fetchResultsController performFetch:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass:[CDMObjectViewController class]]) {
        CDMObjectViewController *viewController = segue.destinationViewController;

        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        viewController.object = self.fetchResultsController.fetchedObjects[indexPath.row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:CDMObjectsCelllIdentifier forIndexPath:indexPath];

    NSManagedObject *object = self.fetchResultsController.fetchedObjects[indexPath.row];

    NSString *name = [object valueForKey:CDMNameKey];
    NSNumber *group = [object valueForKey:CDMGroupKey];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"Name=%@ Group=%@", name, group];

    return cell;
}

#pragma mark -

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

@end
