
#import "HomeCell.h"

#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation HomeCell

- (void)setCellWithModel:(HomeModel *)model
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 5, WIDTH-20, 90)];
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor whiteColor];
    

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width-80, 10, 70, 70)];
    NSURL *url = [NSURL URLWithString:model.images];
    [imageView sd_setImageWithURL:url];
    [view addSubview:imageView];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, view.frame.size.width-100, 70)];
    lab.numberOfLines = 0;
    lab.text = model.title;
    lab.font = [UIFont systemFontOfSize:18];
    [view addSubview:lab];

    
    [self.contentView addSubview:view];
}

@end
