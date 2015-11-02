//
//  ImageWithTagsCell.h
//  AwesomeClient
//
//  Created by Sergey Krupov on 02.11.15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageWithTagsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet AMTagListView *tagListView;
@end
