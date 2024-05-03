//
//  ViewController.h
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)addTaskBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *toDoListTable;

@property (nonatomic, assign) BOOL cellSelected;


@end

