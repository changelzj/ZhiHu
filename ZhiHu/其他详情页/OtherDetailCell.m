

#import "OtherDetailCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation OtherDetailCell

- (void)setCell:(OtherDetailModel *)model
{
    self.backgroundColor = [UIColor colorWithRed:204/255.0 green:193/255.0 blue:203/255.0 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *view = [[UIView alloc]init];
    
    if(model.imgPath != nil)
    {
        view.frame = CGRectMake(10, 5, WIDTH-20, 100-10);
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-95, 10, 70, 70)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgPath]];
        [view addSubview:imageView];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, view.frame.size.width-70-15, 70)];
        lab.text = model.title;
        [view addSubview:lab];
    }
    else
    {
        view.frame = CGRectMake(10, 5, WIDTH-20, 70-10);
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, view.frame.size.width-10, view.frame.size.height-10)];
        lab.text = model.title;
        [view addSubview:lab];
    }
    
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:view];
}

@end
