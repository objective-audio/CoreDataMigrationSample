//
//  CDMMenuViewController.m
//

#import "CDMCustomMigrationController.h"
#import "CDMLightweightMigrationController.h"
#import "CDMMenuViewController.h"
#import "CDMSeparateMigrationController.h"
#import "CDMSetupViewController.h"

@implementation CDMMenuViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CDMSetupViewController class]]) {
        CDMSetupViewController *viewController = (CDMSetupViewController *)segue.destinationViewController;

        if ([segue.identifier isEqualToString:CDMLightweightMigrationSetupSegueIdentifier]) {
            viewController.migrationController = [[CDMLightweightMigrationController alloc] init];
        } else if ([segue.identifier isEqualToString:CDMCustomMigrationSetupSegueIdentifier]) {
            viewController.migrationController = [[CDMCustomMigrationController alloc] init];
        } else if ([segue.identifier isEqualToString:CDMSeparateMigrationSetupSegueIdentifier]) {
            viewController.migrationController = [[CDMSeparateMigrationController alloc] init];
        }
    }
}

@end
