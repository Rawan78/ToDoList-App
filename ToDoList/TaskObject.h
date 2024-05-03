//
//  TaskObject.h
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskObject : NSObject<NSSecureCoding>


@property NSString *title;
@property NSString *Description;
@property NSInteger priority;
@property NSInteger type;
@property NSDate *date;

@end

NS_ASSUME_NONNULL_END
