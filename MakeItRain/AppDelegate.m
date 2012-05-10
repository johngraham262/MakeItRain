#import <Venmo/Venmo.h>
#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *viewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:viewController];
    viewController.title = @"Make it Rain";
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    ViewController *viewController = (ViewController *)((UINavigationController *)
                                                        self.window.rootViewController).topViewController;
    return [viewController.venmoClient 
            openURL:url 
            completionHandler:^(VenmoTransaction *transaction, NSError *error) {
                if (transaction) {
//                    NSString *message = [@"payment_id: " stringByAppendingFormat:@"%i. %i %@ %@ (%i) $%@ %@",
//                                         transaction.id,
//                                         transaction.fromUserId,
//                                         transaction.typeStringPast,
//                                         transaction.toUserHandle,
//                                         transaction.toUserId,
//                                         transaction.amountString,
//                                         transaction.note];
//                    NSLog(@"message: %@", message);
                    
                    if (transaction.success) {
                        [viewController resetCount];
                        
                        // TODO: Improve message when SDK sends more information.
//                        NSString *format = @"You just rained $%@ all ova %@!";
                        NSString *format = @"You just rained $%@ all up in herrr!";
                        NSString *message = [NSString stringWithFormat:format,
                                             transaction.amountString, transaction.toUserHandle];
                        
                        UIAlertView *alertView = [[UIAlertView alloc] 
                                                  initWithTitle:@"Dayum Son" message:message
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                    
                } else { // error
                    NSLog(@"transaction error code: %i", error.code);
                }
            }];
}

@end
