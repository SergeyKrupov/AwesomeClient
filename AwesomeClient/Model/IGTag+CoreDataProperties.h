//
//  IGTag+CoreDataProperties.h
//  AwesomeClient
//
//  Created by Sergey Krupov on 02.11.15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IGTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface IGTag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSSet<IGImage *> *images;

@end

@interface IGTag (CoreDataGeneratedAccessors)

- (void)addImagesObject:(IGImage *)value;
- (void)removeImagesObject:(IGImage *)value;
- (void)addImages:(NSSet<IGImage *> *)values;
- (void)removeImages:(NSSet<IGImage *> *)values;

@end

NS_ASSUME_NONNULL_END
