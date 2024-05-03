//
//  DoneViewController.h
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *doneTable;

- (IBAction)filterDoneBtn:(UIButton *)sender;

@property (nonatomic, assign) BOOL cellSelected;

@end

NS_ASSUME_NONNULL_END
