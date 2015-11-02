//
//  IGUser+CoreDataProperties.h
//  AwesomeClient
//
//  Created by Sergey Krupov on 02.11.15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IGUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface IGUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSString *profilePictureUrl;
@property (nullable, nonatomic, retain) NSString *uniqueID;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSSet<IGImage *> *images;

@end

@interface IGUser (CoreDataGeneratedAccessors)

- (void)addImagesObject:(IGImage *)value;
- (void)removeImagesObject:(IGImage *)value;
- (void)addImages:(NSSet<IGImage *> *)values;
- (void)removeImages:(NSSet<IGImage *> *)values;

@end

NS_ASSUME_NONNULL_END
