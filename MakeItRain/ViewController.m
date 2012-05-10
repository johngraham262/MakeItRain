//#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeUpGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeDownGestureRecognizer;
@property (strong, nonatomic) UIButton *countButton;
@property (nonatomic) NSInteger swipeCount;
@property (copy, nonatomic) NSMutableArray *rainAudioPlayers;
- (void)handleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)incrementCount;
- (void)decrementCount;
- (void)resetCount;
- (void)playSound;
@end

@implementation ViewController

@synthesize swipeUpGestureRecognizer;
@synthesize swipeDownGestureRecognizer;
@synthesize countButton;
@synthesize swipeCount;
@synthesize rainAudioPlayers;

- (void)viewDidUnload
{
    self.swipeUpGestureRecognizer = nil;
    self.countButton = nil;
    [super viewDidUnload];
}

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
    
    self.countButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    countButton.frame = CGRectMake(10, 10, 120, 30);
    [self.view addSubview:countButton];
    countButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self updateLabel];
    [countButton addTarget:self action:@selector(resetCount)
          forControlEvents:UIControlEventTouchUpInside];
    [countButton setTitle:@"Reset" forState:UIControlStateHighlighted];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"woosh" ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    rainAudioPlayers = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<10; i++) {
        [rainAudioPlayers addObject:[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil]];
    }
    
//    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    loginButton.frame = CGRectMake(230, 10, 80, 30);
//    [self.view addSubview:loginButton];
//    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
}

- (void)incrementCount {
    swipeCount++;
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
        swipeCount--;
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
