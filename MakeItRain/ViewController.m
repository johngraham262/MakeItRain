//#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <Venmo/Venmo.h>
#include <stdlib.h>
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeUpGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeDownGestureRecognizer;
@property (strong, nonatomic) UIButton *countButton;
@property (nonatomic) NSInteger swipeCount;
@property (strong, nonatomic) NSMutableArray *rainAudioPlayers;
@property (strong, nonatomic) UISlider *valueSlider;
@property (strong, nonatomic) UILabel *sliderLabel;

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)incrementCount;
- (void)decrementCount;
- (void)playSound;
- (void)makePayment;
@end

@implementation ViewController

@synthesize swipeUpGestureRecognizer;
@synthesize swipeDownGestureRecognizer;
@synthesize countButton;
@synthesize swipeCount;
@synthesize venmoClient;
@synthesize rainAudioPlayers;
@synthesize valueSlider;
@synthesize sliderLabel;

- (void)viewDidUnload
{
    self.swipeUpGestureRecognizer = nil;
    self.countButton = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [swipeUpGestureRecognizer addTarget:self action:@selector(handleSwipeUp:)];
    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
    
    self.swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [swipeDownGestureRecognizer addTarget:self action:@selector(handleSwipeDown:)];
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    
    swipeCount = 0;
    
    self.countButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    countButton.frame = CGRectMake(10, 10, 130, 30);
    [self.view addSubview:countButton];
    countButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self updateLabel];
    [countButton addTarget:self action:@selector(resetCount)
          forControlEvents:UIControlEventTouchUpInside];
    [countButton setTitle:@"Reset" forState:UIControlStateHighlighted];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"woosh" ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    self.rainAudioPlayers = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<10; i++) {
        [rainAudioPlayers addObject:[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil]];
    }
    
    self.venmoClient = [VenmoClient clientWithAppId:@"1135"
                                             secret:@"NNZ3v8DvZ7LACaPRsbaCTdzB2ss3TFqN"];
    
    valueSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 360, 300, 20)];
    valueSlider.minimumValue = 1;
    valueSlider.maximumValue = 10;
    valueSlider.continuous = NO;
    valueSlider.value = 1;
    [valueSlider addTarget:self action:@selector(sliderChange:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:valueSlider];
    
    sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 385, 320, 20)];
    sliderLabel.textAlignment = UITextAlignmentCenter;
    sliderLabel.backgroundColor = [UIColor clearColor];
    sliderLabel.text = @"Rain Amount $1";
    [self.view addSubview:sliderLabel];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    payButton.frame = CGRectMake(260, 10, 50, 30);
    [self.view addSubview:payButton];
    [payButton setTitle:@"Rain" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(makePayment)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)sliderChange:(UISlider *)sender {
    sender.value = roundl(sender.value);
    sliderLabel.text = [NSString stringWithFormat:@"Rain Amount $%i",
                        [[NSNumber numberWithFloat:sender.value] integerValue]];
}

- (void)incrementCount {
    swipeCount += valueSlider.value;
    [self updateLabel];
    
    if (swipeCount % 25 == 0) {
        UIImageView *ballaImage = [[UIImageView alloc] initWithImage:
                                   [UIImage imageNamed:@"ballaImage.png"]];
        ballaImage.frame = CGRectMake(10, 60, 300, 300);
        ballaImage.alpha = .5;
        [self.view addSubview:ballaImage];
        
        [UIView animateWithDuration:.5 animations:^{
            ballaImage.frame = CGRectMake(0, 50, 320, 320);
            ballaImage.alpha = 1;
        } completion:^(BOOL finished) {
            [ballaImage removeFromSuperview];
        }];
    }
}

- (void)decrementCount {
    if (swipeCount > 0) {
        swipeCount -= valueSlider.value;
    } else if (swipeCount < 1) {
        swipeCount = 0;
    }
    [self updateLabel];
}

- (void)resetCount {
    swipeCount = 0;
    [self updateLabel];
}

- (void)updateLabel {
    [countButton setTitle:[NSString stringWithFormat:@"Droplets: $%i", swipeCount]
                 forState:UIControlStateNormal];
}

- (void)playSound {
    for (AVAudioPlayer *audioPlayer in rainAudioPlayers) {
        if (![audioPlayer isPlaying]) {
            [audioPlayer play];
            break;
        }
    }
}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint start = [gestureRecognizer locationOfTouch:0 inView:self.view];
    
//    CFBundleRef mainBundle = CFBundleGetMainBundle();
//    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR("woosh"), CFSTR("wav"), NULL);
//    SystemSoundID soundId;
//    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundId);
//    AudioServicesPlaySystemSound(soundId);
//    CFRelease(soundFileURLRef);
    
    [self playSound];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithImage:[UIImage imageNamed:@"dollarBill.jpg"]];
    imageView.frame = CGRectMake(start.x-100, start.y, 200, 70);
    imageView.alpha = 1;
    [self.view addSubview:imageView];
    
    CGFloat rotationAngle = arc4random_uniform(2) == 0 ? 3.13 : -3.13;
    [UIView animateWithDuration:1 animations:^{
        imageView.alpha = .5;
        imageView.frame = CGRectMake(144, 10, 33, 12);
        imageView.transform = CGAffineTransformMakeRotation(rotationAngle);
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

- (void)makePayment {
    if (swipeCount > 0) {
        VenmoTransaction *venmoTransaction = [[VenmoTransaction alloc] init];
        venmoTransaction.type = VenmoTransactionTypePay;
        venmoTransaction.amount = [[NSNumber numberWithInt:swipeCount] floatValue];
        venmoTransaction.note = @"because I make it rain foo'!!";
        VenmoViewController *viewController = [venmoClient viewControllerWithTransaction:venmoTransaction];
        if (viewController) {
            [self presentModalViewController:viewController animated:YES];
        }
    }
}

@end
