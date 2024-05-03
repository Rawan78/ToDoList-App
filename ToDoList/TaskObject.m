//
//  TaskObject.m
//  ToDoList
//
//  Created by Rawan Elsayed on 21/04/2024.
//

#import "TaskObject.h"

@implementation TaskObject

// Implementing NSSecureCoding methods
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.Description forKey:@"description"];
    [coder encodeInteger:self.priority forKey:@"priority"];
    [coder encodeInteger:self.type forKey:@"type"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
           _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
           _Description = [coder decodeObjectOfClass:[NSString class] forKey:@"description"];
           _priority = [coder decodeIntegerForKey:@"priority"];
           _type = [coder decodeIntegerForKey:@"type"];
           _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
       }
    return self;
}

@end
