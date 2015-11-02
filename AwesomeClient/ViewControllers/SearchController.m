//
//  SearchController.m
//  AwesomeClient
//
//  Created by Sergey Krupov on 02.11.15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//

extern NSString * const DataModelUpdatedNotification;

#import "SearchController.h"
#import "ImageWithTagsCell.h"

@interface SearchController () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchStringTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) NSString *searchString;
@end

@implementation SearchController {
    NSArray<IGImage *> *m_images;
}

@synthesize searchStringTextField, collectionView = m_collectionView, searchString;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataModelUpdatedNotification:)
                                                     name:DataModelUpdatedNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataModelUpdatedNotification:(NSNotification *)notification
{
    // Останавливаю, чтобы не срабатывало 2 раза, если вызов уже находится в очереди
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showImagesForTag:) object:searchString];
    [self showImagesForTag:searchString];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return m_images.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const reuseIdentifier = @"ImageWithTagsCellID";
    
    IGImage *image = m_images[indexPath.row];
    ImageWithTagsCell *cell = (ImageWithTagsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:image.imageUrl]];
    NSMutableArray *tagStrings = [NSMutableArray arrayWithCapacity:image.tags.count];
    for (IGTag *tag in image.tags) {
        [tagStrings addObject:tag.text];
    }
    [cell.tagListView addTags:tagStrings];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rctFrame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(rctFrame), CGRectGetHeight(rctFrame)) - 20;
    return CGSizeMake(size, size);
}

#pragma mark - Actions

- (IBAction)searchStringEditingDidChange:(UITextField *)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showImagesForTag:) object:searchString];
    searchString = sender.text;
    [self performSelector:@selector(showImagesForTag:) withObject:searchString afterDelay:0.5];
}

#pragma mark - Stuff

- (void)showImagesForTag:(NSString *)tag
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    IGTag *t = [IGTag MR_findFirstByAttribute:@"text" withValue:tag inContext:context];
    if (t) {
        NSSortDescriptor *d = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        m_images = [t.images sortedArrayUsingDescriptors:@[d]];
    }
    else {
        m_images = [NSArray array];
    }
    [m_collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
