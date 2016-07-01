//
//  CDMSetupViewController.m
//

#import "CDMJoin.h"
#import "CDMMigrationController.h"
#import "CDMMigrationViewController.h"
#import "CDMSetupViewController.h"
#import "CDMTypes.h"

typedef NS_ENUM(NSUInteger, CDMSetupJoinFlag) {
    CDMSetupJoinFlagAppear,
    CDMSetupJoinFlagSetup,

    CDMSetupJoinFlagCount,
};

@interface CDMSetupViewController ()
@property (nonatomic) CDMJoin *join;
@end

@implementation CDMSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    assert(self.migrationController);

    self.navigationItem.hidesBackButton = YES;

    __weak typeof(self) wself = self;

    self.join = [[CDMJoin alloc] initWithCount:CDMSetupJoinFlagCount
                                 joinedHandler:^{
                                     [wself performSegueWithIdentifier:CDMMigrationSegueIdentifier sender:wself];
                                 }];

    [self.migrationController setupWithCompletionHandler:^{
        [wself.join setFlag:CDMSetupJoinFlagSetup];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.join setFlag:CDMSetupJoinFlagAppear];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CDMMigrationViewController class]]) {
        if ([segue.identifier isEqualToString:CDMMigrationSegueIdentifier]) {
            CDMMigrationViewController *viewController = segue.destinationViewController;
            viewController.migrationController = self.migrationController;
        }
    }
}

@end
