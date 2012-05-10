#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeUpGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeDownGestureRecognizer;
@property (strong, nonatomic) UILabel *countLabel;
@property (nonatomic) NSInteger swipeCount;
- (void)handleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)incrementCount;
- (void)decrementCount;
@end

@implementation ViewController

@synthesize swipeUpGestureRecognizer;
@synthesize swipeDownGestureRecognizer;
@synthesize countLabel;
@synthesize swipeCount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [swipeUpGestureRecognizer addTarget:self action:@selector(handleSwipeUp:)];
    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
    
    self.swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [swipeDownGestureRecognizer addTarget:self action:@selector(handleSwipeDown:)];
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    
    swipeCount = 0;
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    [self.view addSubview:countLabel];
    [self updateLabel];
}

- (void)viewDidUnload
{
    self.swipeUpGestureRecognizer = nil;
    self.countLabel = nil;
    [super viewDidUnload];
}

- (void)incrementCount {
    swipeCount++;
    [self updateLabel];
}

- (void)decrementCount {
    if (swipeCount > 0) {
        swipeCount--;
    }
    [self updateLabel];
}

- (void)updateLabel {
    countLabel.text = [NSString stringWithFormat:@"Pay: $%i", swipeCount];
}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint start = [gestureRecognizer locationOfTouch:0 inView:self.view];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithImage:[UIImage imageNamed:@"dollarBill.jpg"]];
    imageView.frame = CGRectMake(start.x-100, start.y, 200, 70);
    imageView.alpha = 1;
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:1 animations:^{
        imageView.alpha = .5;
        imageView.frame = CGRectMake(144, 10, 33, 12);
        imageView.transform = CGAffineTransformMakeRotation(3.13);

    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [self incrementCount];
    }];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (swipeCount < 1) {
        return;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithImage:[UIImage imageNamed:@"dollarBill.jpg"]];
    imageView.frame = CGRectMake(location.x-16, location.y, 33, 12);
    imageView.alpha = .5;
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:1 animations:^{
        imageView.alpha = 1;
        imageView.frame = CGRectMake(location.x-100, location.y, 200, 70);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [self decrementCount];
    }];
}

@end
