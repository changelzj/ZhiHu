
#import "ImagesScrollView.h"

@implementation Content

@end

@implementation ImagesScrollView


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        CGFloat h = self.frame.size.height;
        CGFloat w = self.frame.size.width;
        
        iscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
        iscrollView.showsHorizontalScrollIndicator = NO;
        iscrollView.showsVerticalScrollIndicator = NO;
        iscrollView.pagingEnabled = YES;
        iscrollView.delegate = self;
        iscrollView.bounces = NO;
        [self addSubview:iscrollView];
        
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(w/2-150/2, h-20, 150, 15)];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:pageControl];
    }
    return self;
}


- (void)refreshData
{
    [timer invalidate];
    
    numberOfImage = [self.delegate numberOfImages:self];
    
    currentPlay = 0;
    
    CGFloat sh = iscrollView.frame.size.height;
    CGFloat sw = iscrollView.frame.size.width;
    
    iscrollView.contentSize = CGSizeMake(sw*numberOfImage, sh);
    iscrollView.contentOffset = CGPointMake(currentPlay*iscrollView.frame.size.width,0);
    
    for(UIView *view in iscrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    for(int i=0; i<numberOfImage; i++)
    {
        Content *centent = [self.delegate imagesScrollView:self dataForImageAtindex:i];
        
        UIImageView *imageView = centent.imageView;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
        [imageView addGestureRecognizer:tap];
        imageView.alpha = 0.7;
        imageView.frame = CGRectMake(i*sw, 0, sw, sh);
        [iscrollView addSubview:imageView];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.numberOfLines = 0;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont boldSystemFontOfSize:20];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = centent.title;
        lab.frame = CGRectMake(sw*i+20, sh-85, sw-40, 60);
        lab.backgroundColor = [UIColor clearColor];
        [iscrollView addSubview:lab];
    }
    
    if(numberOfImage > 1)
    {
        pageControl.currentPage = currentPlay;
        pageControl.numberOfPages = numberOfImage;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(play) userInfo:nil repeats:YES];
}



- (void)play
{
    [UIView animateWithDuration:0.05 animations:^
    {
        iscrollView.contentOffset = CGPointMake(currentPlay*iscrollView.frame.size.width,0);
        pageControl.currentPage = currentPlay;
    }];
    
    currentPlay++;
    
    if(currentPlay == numberOfImage)
    {
        currentPlay = 0;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;;
    pageControl.currentPage = page;
    currentPlay = page;
}


- (void)selectImage:(UITapGestureRecognizer *)tap
{
    [self.delegate imagesScrollView:self didSelectImageAtIndex:tap.view.tag];
}


@end
