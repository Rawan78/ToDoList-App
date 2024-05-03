//
//  InProgressViewController.h
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InProgressViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)filterBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *inProgressTable;

@property (nonatomic, assign) BOOL cellSelected;

@end

NS_ASSUME_NONNULL_END
