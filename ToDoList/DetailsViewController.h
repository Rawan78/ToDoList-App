//
//  DetailsViewController.h
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskObject.h"
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;


@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerChooser;

- (IBAction)saveOrEditBtn:(UIButton *)sender;

@property (nonatomic, strong) NSMutableArray<TaskObject *> *tasks;

- (void)retrieveTasksFromUserDefaults;

@property (nonatomic, strong) TaskObject *selectedTask;

@property (nonatomic, assign) BOOL comeToEdit;

@end

NS_ASSUME_NONNULL_END
