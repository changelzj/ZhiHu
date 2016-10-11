
#import <UIKit/UIKit.h>

@interface Content : NSObject

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSString *title;

@end



@protocol ImagesScrollViewDelegate;

@interface ImagesScrollView : UIView <UIScrollViewDelegate>

{
    UIScrollView *iscrollView;
    UIPageControl *pageControl;
    NSInteger numberOfImage;
    NSInteger currentPlay;
    NSTimer *timer;
}

@property (weak, nonatomic) id<ImagesScrollViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)refreshData;

@end



@protocol ImagesScrollViewDelegate <NSObject>

@required

- (NSInteger)numberOfImages:(ImagesScrollView *)imagesScrollView;
- (Content *)imagesScrollView:(ImagesScrollView *)imagesScrollView dataForImageAtindex:(NSInteger)index;
- (void)imagesScrollView:(ImagesScrollView *)imagesScrollView didSelectImageAtIndex:(NSInteger)index;

@end


