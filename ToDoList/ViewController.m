//
//  ViewController.m
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import "ViewController.h"
#import "DetailsViewController.h"

@interface ViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray<TaskObject *> *tasks;
@property (nonatomic, strong) NSArray<TaskObject *> *filteredTasks;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.toDoListTable.delegate = self;
    self.toDoListTable.dataSource = self;
    
    self.searchBar.delegate = self;
    
    // Do any additional setup after loading the view.
    
    [self retrieveTasksFromUserDefaults];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self retrieveTasksFromUserDefaults];
}

// Implement UISearchBarDelegate method
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Filter tasks based on search text and reload table data
    if (searchText.length > 0) {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
        self.filteredTasks = [self.tasks filteredArrayUsingPredicate:searchPredicate];
    } else {
        self.filteredTasks = self.tasks; // If search text is empty, show all tasks
    }
    
    [self.toDoListTable reloadData]; // Reload table data to reflect the changes
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
            if (task && task.type == 0) {
                // Add the unarchived TaskObject to the array
                [self.tasks addObject:task];
            }
        }
    }
    
    // Reload table view to reflect the changes
    [self.toDoListTable reloadData];
}


- (IBAction)addTaskBtn:(UIButton *)sender {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *searchText = self.searchBar.text;
    
    // Filter tasks based on the priority of the section
    NSPredicate *sectionPredicate;
    switch (section) {
        case 0:
            sectionPredicate = [NSPredicate predicateWithFormat:@"priority == %d", 0];
            break;
        case 1:
            sectionPredicate = [NSPredicate predicateWithFormat:@"priority == %d", 1];
            break;
        case 2:
            sectionPredicate = [NSPredicate predicateWithFormat:@"priority == %d", 2];
            break;
        default:
            break;
    }
    NSArray *tasksInSection = [self.tasks filteredArrayUsingPredicate:sectionPredicate];

    // Apply search filtering if search text is not empty
    if (searchText.length == 0) {
        // If search text is empty, return the count of tasks in the section
        return tasksInSection.count;
    } else {
        // If search text is not empty, filter tasks based on both priority and search text
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ && priority == %d", searchText, section];
        NSArray *filteredTasks = [self.tasks filteredArrayUsingPredicate:searchPredicate];
        return filteredTasks.count; // Return the count of filtered tasks
    }
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
    UITableViewCell *cellToDo = [tableView dequeueReusableCellWithIdentifier:@"cellToDo"];

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
    
    //cellToDo.imageView.image = [UIImage imageNamed:@"images.jpeg"];
    
    // Set the circular image view
       UIImageView *imageView = cellToDo.imageView;
       imageView.image = [UIImage imageNamed:@"todoimg.jpeg"];
       imageView.layer.cornerRadius = imageView.frame.size.width / 2;
       imageView.clipsToBounds = YES;

    return cellToDo;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100.0;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row after selection
    TaskObject *selectedTask = [self taskForIndexPath:indexPath];

    DetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetailsVC"];
        detailVC.selectedTask = selectedTask;
        detailVC.comeToEdit=YES;
        [self.navigationController pushViewController:detailVC animated:YES];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"showToDoDetails"]) {
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
        // Remove the task from the data source
        TaskObject *deletedTask = [self taskForIndexPath:indexPath];
        [self.tasks removeObject:deletedTask];
        
        // Update UserDefaults with the modified task list
        [self saveTasksToUserDefaults];
        
        // Reload the table view section instead of deleting the row directly
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)saveTasksToUserDefaults {
    // Archive and save the updated task objects to UserDefaults
    NSMutableArray<NSData *> *archivedTasks = [NSMutableArray array];
    for (TaskObject *task in self.tasks) {
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
        [self.tasks removeObjectsInArray:filteredTasks];
        
        [self saveTasksToUserDefaults];
        
        [self.toDoListTable reloadData];
    } else {
        // Task not found
        NSLog(@"Task with title '%@' not found.", title);
    }
}


@end
