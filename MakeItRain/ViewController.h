#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) VenmoClient *venmoClient;

- (void)resetCount;

@end
