#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) VenmoClient *venmoClient;

- (void)resetCount;

@end
