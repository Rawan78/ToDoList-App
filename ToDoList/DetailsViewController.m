//
//  DetailsViewController.m
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import "DetailsViewController.h"
#import "TaskObject.h"
#import "ViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tasks = [NSMutableArray array];
    
    [self retrieveTasksFromUserDefaults];
    
    if(_comeToEdit){
    
        // Set up UI with details of selected task
        self.titleTextField.text = self.selectedTask.title;
        self.descriptionTextField.text = self.selectedTask.Description;
        
        NSLog(@"%@" , self.selectedTask.title);
        self.prioritySegmentedControl.selectedSegmentIndex = self.selectedTask.priority;
        self.typeSegmentedControl.selectedSegmentIndex = self.selectedTask.type;
        [self.datePickerChooser setDate:self.selectedTask.date animated:YES];
    }else{
        printf("not come to edit \n");
    }
    
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)saveOrEditBtn:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Changes"
        message:@"Do you want to save changes?"
        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
        // Create a new TaskObject
        TaskObject *task = [[TaskObject alloc] init];
        task.title = self.titleTextField.text;
        task.Description = self.descriptionTextField.text;
        task.priority = self.prioritySegmentedControl.selectedSegmentIndex;
        task.type = self.typeSegmentedControl.selectedSegmentIndex;
        task.date = self.datePickerChooser.date;

        [self addTask:task];
        //[self printTasks];

        // Store the array of TaskObject in UserDefaults
        [self storeTasksInUserDefaults];
        [self retrieveTasksFromUserDefaults];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)addTask:(TaskObject *)task {
    // Add the task to the array
    [self.tasks addObject:task];
    
}
- (void)printTasks {
    // Loop through the array of tasks and print each task
    for (TaskObject *task in self.tasks) {
        NSLog(@"Task title: %@", task.title);
        NSLog(@"Task Description: %@", task.Description);
        NSLog(@"Task Priority: %ld", (long)task.priority);
        NSLog(@"Task Type: %ld", (long)task.type);

        // Create a date formatter to format the date for logging
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *formattedDate = [dateFormatter stringFromDate:task.date];
        NSLog(@"Task date: %@", formattedDate);

        NSLog(@"---"); // Separator between task objects
    }
}

- (void)storeTasksInUserDefaults {
    // Create an array to store archived TaskObjects
    NSMutableArray *archivedTasks = [NSMutableArray array];
    
    // Loop through the array of TaskObjects and archive each one
    for (TaskObject *task in self.tasks) {
        NSData *taskData = [NSKeyedArchiver archivedDataWithRootObject:task requiringSecureCoding:NO error:nil];
        [archivedTasks addObject:taskData];
    }
    
    // Store the array of archived TaskObjects in UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archivedTasks forKey:@"tasks"];
    [defaults synchronize];
}

- (void)retrieveTasksFromUserDefaults {
    // Retrieve stored task objects from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray<NSData *> *archivedTasks = [defaults objectForKey:@"tasks"];

    // Check if archivedTasks is not nil and contains data
    if (archivedTasks) {
        // Loop through the array of archived data and unarchive each TaskObject
        for (NSData *taskData in archivedTasks) {
            TaskObject *task = [NSKeyedUnarchiver unarchivedObjectOfClass:[TaskObject class] fromData:taskData error:nil];
            if (task) {
                // Add the unarchived TaskObject to the array
                [self.tasks addObject:task];
            }
        }
    }
    
    // Print the retrieved tasks
    [self printTasks];
}

@end
