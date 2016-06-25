//
//  CDMEntitiesViewController.m
//

#import "CDMDataController.h"
#import "CDMEntitiesViewController.h"
#import "CDMObjectsViewController.h"

static NSString *const CDMInformationCellIdentifier = @"InformationCell";
static NSString *const CDMEntitiesCellIdentifier = @"EntitiesCell";

typedef NS_ENUM(NSUInteger, CDMEntitiesSection) {
    CDMEntitiesSectionInformation,
    CDMEntitiesSectionEntities,

    CDMEntitiesSectionCount,
};

typedef NS_ENUM(NSUInteger, CDMEntitiesInformationRow) {
    CDMEntitiesInformationRowModelName,
    CDMEntitiesInformationRowModelIdentifier,
    CDMEntitiesInformationRowMigrationTime,

    CDMEntitiesInformationRowCount,
};

@implementation CDMEntitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    assert(self.dataController);

    self.navigationItem.hidesBackButton = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CDMObjectsViewController class]]) {
        CDMObjectsViewController *viewController = segue.destinationViewController;
        viewController.context = self.dataController.dataStore.mainContext;

        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        viewController.entityName = [self.dataController entityNameAtIndex:indexPath.row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CDMEntitiesSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case CDMEntitiesSectionInformation:
            return @"Information";
        case CDMEntitiesSectionEntities:
            return @"Entities";
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case CDMEntitiesSectionInformation:
            return CDMEntitiesInformationRowCount;
        case CDMEntitiesSectionEntities: {
            return [self.dataController entityCount];
        }
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    switch (indexPath.section) {
        case CDMEntitiesSectionInformation:
            cell = [tableView dequeueReusableCellWithIdentifier:CDMInformationCellIdentifier forIndexPath:indexPath];

            switch (indexPath.row) {
                case CDMEntitiesInformationRowModelName: {
                    cell.textLabel.text = @"Model Name";
                    cell.detailTextLabel.text = self.dataController.dataStore.modelName;
                } break;

                case CDMEntitiesInformationRowModelIdentifier: {
                    cell.textLabel.text = @"Model Identifiers";
                    NSDictionary<NSString *, id> *metadata = self.dataController.metadata;
                    NSArray *identifiers = metadata[NSStoreModelVersionIdentifiersKey];
                    cell.detailTextLabel.text = [identifiers componentsJoinedByString:@"/"];

                } break;

                case CDMEntitiesInformationRowMigrationTime: {
                    cell.textLabel.text = @"Migration Time";
                    cell.detailTextLabel.text =
                        [[NSString alloc] initWithFormat:@"%fs", self.dataController.migrationTime];
                } break;
            }

            break;
        case CDMEntitiesSectionEntities:
            cell = [tableView dequeueReusableCellWithIdentifier:CDMEntitiesCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = [self.dataController entityNameAtIndex:indexPath.row];
            break;
    }

    return cell;
}

@end
