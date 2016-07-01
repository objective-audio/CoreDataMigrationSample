//
//  CDMMigrationViewController.m
//

#import "CDMDataController.h"
#import "CDMEntitiesViewController.h"
#import "CDMJoin.h"
#import "CDMMigrationController.h"
#import "CDMMigrationViewController.h"

typedef NS_ENUM(NSUInteger, CDMMigrationJoinFlag) {
    CDMMigrationJoinFlagAppear,
    CDMMigrationJoinFlagMigration,

    CDMMigrationJoinFlagCount,
};

@interface CDMMigrationViewController ()
@property (nonatomic) CDMJoin *join;
@property (nonatomic) CDMDataController *dataController;
@end

@implementation CDMMigrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    assert(self.migrationController);

    self.navigationItem.hidesBackButton = YES;

    __weak typeof(self) wself = self;

    self.join = [[CDMJoin alloc]
        initWithCount:CDMMigrationJoinFlagCount
        joinedHandler:^{
            if (wself.dataController) {
                [wself performSegueWithIdentifier:CDMEntitiesSegueIdentifier sender:wself];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Migration Error"
                                                                               message:@""
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];

                [wself presentViewController:alert animated:YES completion:NULL];
            }
        }];

    [self.migrationController migrateWithCompletionHandler:^(CDMDataController *dataController) {
        wself.dataController = dataController;
        [wself.join setFlag:CDMMigrationJoinFlagMigration];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.join setFlag:CDMMigrationJoinFlagAppear];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CDMEntitiesViewController class]]) {
        if ([segue.identifier isEqualToString:CDMEntitiesSegueIdentifier]) {
            CDMEntitiesViewController *viewController = segue.destinationViewController;
            viewController.dataController = self.dataController;
        }
    }
}

@end
