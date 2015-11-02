//
//  HomeController.m
//  AwesomeClient
//
//  Created by Sergey on 31/10/15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//

#import "HomeController.h"
#import "InstagramEngine.h"
#import "InstagramUser.h"
#import "ImageCell.h"

NSString * const DataModelUpdatedNotification = @"DataModelUpdatedNotification";

@interface HomeController ()
@property (nonatomic, readonly) NSArray *images;
@property (nonatomic, readonly)  IGUser *user;
@end

@implementation HomeController {
    NSArray *m_images;
    IGUser *m_user;
}

@synthesize accountName;

static NSString * const reuseIdentifier = @"ImageCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchUpdates];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    IGImage *image = self.images[indexPath.row];
    cell.commentLabel.text = image.caption;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:image.imageUrl]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rctFrame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(rctFrame), CGRectGetHeight(rctFrame)) - 20;
    return CGSizeMake(size, size);
}

- (void)fetchUpdates
{
    [[InstagramEngine sharedEngine] searchUsersWithString:accountName withSuccess:^(NSArray *users, InstagramPaginationInfo *paginationInfo) {
        InstagramUser *user = users[0];
        [[InstagramEngine sharedEngine] getMediaForUser:user.Id withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            [self updateModelDataWithUser:user media:media];
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"Failed to get media for user: %@", user.fullName);
        }];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        NSLog(@"User %@ was not found. Error:%@", accountName, error);
    }];
}

- (void)updateModelDataWithUser:(InstagramUser *)user media:(NSArray *)media
{
    __weak HomeController *weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *context) {
        IGUser *u = [IGUser MR_findFirstByAttribute:@"uniqueID" withValue:user.Id inContext:context];
        if (!u) u = [IGUser MR_createEntityInContext:context];
        u.username = user.username;
        u.fullName = user.fullName;
        u.profilePictureUrl = [user.profilePictureURL absoluteString];
        u.uniqueID = user.Id;
        
        NSMutableSet *allImages = [NSMutableSet setWithArray:[IGImage MR_findAllInContext:context]];
        for (InstagramMedia *m in media) {
            if (m.isVideo) continue;
            IGImage *image = [IGImage MR_findFirstByAttribute:@"uniqueID" withValue:m.Id inContext:context];
            if (!image)
                image = [IGImage MR_createEntityInContext:context];
            else
                [allImages removeObject:image];
            image.caption = m.caption.text;
            image.date = m.createdDate;
            image.imageHeight = @(m.standardResolutionImageFrameSize.height);
            image.imageWidth = @(m.standardResolutionImageFrameSize.width);
            image.imageUrl =  [m.standardResolutionImageURL absoluteString];
            image.uniqueID = m.Id;
            image.user = u;
            
            for (NSString *tag in m.tags) {
                IGTag *t = [IGTag MR_findFirstByAttribute:@"text" withValue:tag inContext:context];
                if (!t) {
                    t = [IGTag MR_createEntityInContext:context];
                    t.text = tag;
                }
                //NSLog(@"Add tag: %@", t.text);
                [image addTagsObject:t];
            }
        }
        
        for (IGImage *image in allImages) {
            [image MR_deleteEntityInContext:context];
        }
        
        [IGTag MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"images.@count == 0"] inContext:context];
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"Update fiinished: didSave=%s", contextDidSave ? "YES" : "NO");
        [[NSNotificationCenter defaultCenter] postNotificationName:DataModelUpdatedNotification object:nil];
        HomeController *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf->m_user = nil;
            strongSelf->m_images = nil;
            [strongSelf.collectionView reloadData];
        }
    }];
}

#pragma mark - 

- (NSArray *)images
{
    if (!m_images && self.user) {
        m_images = [IGImage MR_findByAttribute:@"user" withValue:self.user andOrderBy:@"date" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return m_images;
}

- (IGUser *)user
{
    if (!m_user) {
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        m_user = [IGUser MR_findFirstByAttribute:@"username" withValue:accountName inContext:context];
    }
    return m_user;
}

#pragma mark - actions

- (IBAction)logoutAction:(id)sender
{
    [[InstagramEngine sharedEngine] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
