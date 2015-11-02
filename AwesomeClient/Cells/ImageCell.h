//
//  ImageCell.h
//  AwesomeClient
//
//  Created by Sergey on 01/11/15.
//  Copyright © 2015 Sergey Krupov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end
