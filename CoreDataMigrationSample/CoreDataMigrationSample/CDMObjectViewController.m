//
//  CDMObjectViewController.m
//

#import "CDMObjectViewController.h"
#import "CDMTypes.h"
#import "UBICoreData.h"

typedef NS_ENUM(NSUInteger, CDMObjectSection) {
    CDMObjectSectionAttributes,
    CDMObjectSectionRelationships,

    CDMObjectSectionCount,
};

static NSString *const CDMObjectCellIdentifier = @"ObjectCell";

@implementation CDMObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [[NSString alloc] initWithFormat:@"%@ object", self.object.entity.name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CDMObjectSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case CDMObjectSectionAttributes:
            return @"Attributes";
        case CDMObjectSectionRelationships:
            return @"Relationships";
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case CDMObjectSectionAttributes:
            return self.object.entity.attributesByName.count;
        case CDMObjectSectionRelationships:
            return self.object.entity.relationshipsByName.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CDMObjectCellIdentifier forIndexPath:indexPath];

    switch (indexPath.section) {
        case CDMObjectSectionAttributes: {
            NSString *key = self.object.entity.attributesByName.allKeys[indexPath.row];
            cell.textLabel.text = key;
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", [self.object valueForKey:key]];
        } break;
        case CDMObjectSectionRelationships: {
            NSString *key = self.object.entity.relationshipsByName.allKeys[indexPath.row];
            cell.textLabel.text = key;
            NSManagedObject *relationship = [self.object valueForKey:key];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", [relationship valueForKey:CDMNameKey]];
        } break;
    }

    return cell;
}

@end
