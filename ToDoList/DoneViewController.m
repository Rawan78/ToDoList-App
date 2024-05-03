//
//  DoneViewController.m
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import "DoneViewController.h"
#import "DetailsViewController.h"

@interface DoneViewController ()

@property (nonatomic, strong) NSMutableArray<TaskObject *> *tasks;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doneTable.delegate = self;
    self.doneTable.dataSource = self;
    
    [self retrieveTasksFromUserDefaults];
    
    self.cellSelected = NO;
    
    // Setup background image view
//       self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"todoimg.jpeg"]];
//       self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
//       self.doneTable.backgroundView = self.backgroundImageView;
    
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

- (void)viewWillAppear:(BOOL)animated{
    [self retrieveTasksFromUserDefaults];
}

- (void)retrieveTasksFromUserDefaults {
    // Retrieve stored task objects from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray<NSData *> *archivedTasks = [defaults objectForKey:@"tasks"];
    self.tasks = [NSMutableArray array];

    // Check if archivedTasks is not nil and contains data
    if (archivedTasks) {
        // Loop through the array of archived data and unarchive each TaskObject
        for (NSData *taskData in archivedTasks) {
            TaskObject *task = [NSKeyedUnarchiver unarchivedObjectOfClass:[TaskObject class] fromData:taskData error:nil];
            if (task && task.type == 2) {
                // Add the unarchived TaskObject to the array
                [self.tasks addObject:task];
            }
        }
    }
    
    // Reload table view to reflect the changes
    [self.doneTable reloadData];
}

- (IBAction)filterDoneBtn:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Filter Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Add actions for each filter option
    [alertController addAction:[UIAlertAction actionWithTitle:@"Low Priority" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Apply filter for low priority tasks
        [self filterTasksWithPriority:0];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Medium Priority" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Apply filter for medium priority tasks
        [self filterTasksWithPriority:1];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"High Priority" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Apply filter for high priority tasks
        [self filterTasksWithPriority:2];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"All" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Show all in-progress tasks
        [self showAllDoneTasks];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)showAllDoneTasks {
    // Reload tasks array with all in-progress tasks
    [self retrieveTasksFromUserDefaults];
}

- (void)filterTasksWithPriority:(NSInteger)priority {
    // Reload tasks array with all in-progress tasks
    [self retrieveTasksFromUserDefaults];
    
    // Apply filter based on priority
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority == %ld", (long)priority];
    self.tasks = [[self.tasks filteredArrayUsingPredicate:predicate] mutableCopy];
    
    // Reload table view to reflect the changes
    [self.doneTable reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Determine the number of rows for each section based on priority
    NSPredicate *predicate;
    switch (section) {
        case 0:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 0];
            break;
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 1];
            break;
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 2];
            break;
        default:
            break;
    }
    NSArray *tasksInSection = [self.tasks filteredArrayUsingPredicate:predicate];
    
    // Show background image if there are no tasks in the section
//       if (tasksInSection.count == 0) {
//           self.backgroundImageView.hidden = NO;
//       } else {
//           self.backgroundImageView.hidden = YES;
//       }
    
    return tasksInSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Return section titles based on priority
    switch (section) {
        case 0:
            return @"Low";
        case 1:
            return @"Medium";
        case 2:
            return @"High";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellToDo = [tableView dequeueReusableCellWithIdentifier:@"cellDone"];

    // Get the tasks for the current section
    NSPredicate *predicate;
    switch (indexPath.section) {
        case 0:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 0];
            break;
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 1];
            break;
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 2];
            break;
        default:
            break;
    }
    NSArray *tasksInSection = [self.tasks filteredArrayUsingPredicate:predicate];
    TaskObject *task = tasksInSection[indexPath.row];

    cellToDo.textLabel.text = task.title;
    cellToDo.detailTextLabel.text = task.Description;
    
    cellToDo.textLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *imageView = cellToDo.imageView;
    imageView.image = [UIImage imageNamed:@"todoimg.jpeg"];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;

    return cellToDo;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row after selection
    TaskObject *selectedTask = [self taskForIndexPath:indexPath];

    DetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetailsVC"];
        detailVC.selectedTask = selectedTask;
        detailVC.comeToEdit=YES;
        [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100.0;

}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"showDoneDetails"]) {
//        DetailsViewController *detailsVC = segue.destinationViewController;
//
//        // Ensure sender is of type TaskObject
//        if ([sender isKindOfClass:[TaskObject class]]) {
//            // Cast sender to TaskObject and assign it to selectedTask property of DetailsViewController
//            detailsVC.selectedTask = (TaskObject *)sender;
//        }
//    }
//}

- (TaskObject *)taskForIndexPath:(NSIndexPath *)indexPath {
    // Get the tasks for the selected section
    NSPredicate *predicate;
    switch (indexPath.section) {
        case 0:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 0];
            break;
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 1];
            break;
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"priority == %d", 2];
            break;
        default:
            break;
    }
    NSArray *tasksInSection = [self.tasks filteredArrayUsingPredicate:predicate];
    
    // Return the selected task
    return tasksInSection[indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Make a copy of the tasks array
        NSMutableArray<TaskObject *> *tasksCopy = [self.tasks mutableCopy];
        
        // Remove the task from the copy
        TaskObject *deletedTask = [self taskForIndexPath:indexPath];
        [tasksCopy removeObject:deletedTask];
        
        // Update UserDefaults with the modified task list
        [self saveTasksToUserDefaults:tasksCopy];
        
        // Remove the task from the original tasks array
        [self.tasks removeObject:deletedTask];
        
        // Delete the row from the table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)saveTasksToUserDefaults:(NSArray<TaskObject *> *)tasks {
    // Archive and save the updated task objects to UserDefaults
    NSMutableArray<NSData *> *archivedTasks = [NSMutableArray array];
    for (TaskObject *task in tasks) {
        NSData *taskData = [NSKeyedArchiver archivedDataWithRootObject:task requiringSecureCoding:NO error:nil];
        [archivedTasks addObject:taskData];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archivedTasks forKey:@"tasks"];
    [defaults synchronize];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// Implement search functionality to delete tasks from UserDefaults
- (void)searchAndDeleteTaskWithTitle:(NSString *)title {
    // Search for the task with the given title in the tasks array
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    NSArray *filteredTasks = [self.tasks filteredArrayUsingPredicate:predicate];
    
    if (filteredTasks.count > 0) {
        NSMutableArray<TaskObject *> *updatedTasks = [self.tasks mutableCopy];
        [updatedTasks removeObjectsInArray:filteredTasks];
        
        [self saveTasksToUserDefaults:updatedTasks];
        
        // Update the tasks array with the modified tasks
        self.tasks = updatedTasks;
        
        [self.doneTable reloadData];
    } else {
        // Task not found
        NSLog(@"Task with title '%@' not found.", title);
    }
}


@end
