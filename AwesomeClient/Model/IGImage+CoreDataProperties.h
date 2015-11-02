//
//  IGImage+CoreDataProperties.h
//  AwesomeClient
//
//  Created by Sergey Krupov on 02.11.15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IGImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface IGImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *caption;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *imageHeight;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSNumber *imageWidth;
@property (nullable, nonatomic, retain) NSString *uniqueID;
@property (nullable, nonatomic, retain) IGUser *user;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *tags;

@end

@interface IGImage (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet<NSManagedObject *> *)values;
- (void)removeTags:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
