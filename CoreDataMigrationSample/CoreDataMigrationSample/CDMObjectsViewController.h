//
//  CDMObjectsViewController.h
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface CDMObjectsViewController : UITableViewController

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic, copy) NSString *entityName;

@end
