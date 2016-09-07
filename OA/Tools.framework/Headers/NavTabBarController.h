#import <UIKit/UIKit.h>

@class NavTabBar;

@protocol NavTabBarControllerDelegate <NSObject>

-(void)NavTabBarControllerOnScorll:(NSInteger)pageindex;

@end

@interface NavTabBarController : UIViewController

@property (nonatomic, assign)   BOOL        showArrowButton;            // Default value: YES
@property (nonatomic, assign)   BOOL        scrollAnimation;            // Default value: NO
@property (nonatomic, assign)   BOOL        mainViewBounces;            // Default value: NO
@property(nonatomic,assign) NSInteger BarMargin;
@property(nonatomic,assign) BOOL isHaveNAVIGATION_BAR;
@property(nonatomic,assign) NSInteger NavgationBottomBarHeight;


@property (nonatomic, strong)   NSArray     *subViewControllers;        // An array of children view controllers

@property (nonatomic, strong)   UIColor     *navTabBarColor;            // Could not set [UIColor clear], if you set, NavTabbar will show initialize color
@property (nonatomic, strong)   UIColor     *navTabBarLineColor;
@property (nonatomic, strong)   UIImage     *navTabBarArrowImage;

@property(nonatomic,strong) UIColor *navItemDefaultColor;
@property(nonatomic,strong) UIColor *navItemSelectColor;

@property(nonatomic,assign) int CurrentPageIndex;
@property(nonatomic,assign) NSInteger       currentIndex;

@property(weak,nonatomic) id<NavTabBarControllerDelegate> delegate;

-(void)SetNavTitleWithIndex:(NSInteger)index Title:(NSString*)title;

/**
 *  Initialize Methods
 *
 *  @param show - is show the arrow button
 *
 *  @return Instance
 */
- (id)initWithShowArrowButton:(BOOL)show;

/**
 *  Initialize SCNavTabBarViewController Instance And Show Children View Controllers
 *
 *  @param subViewControllers - set an array of children view controllers
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subViewControllers;

/**
 *  Initialize SCNavTabBarViewController Instance And Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 *
 *  @return Instance
 */
- (id)initWithParentViewController:(UIViewController *)viewController;

/**
 *  Initialize SCNavTabBarViewController Instance, Show On The Parent View Controller And Show On The Parent View Controller
 *
 *  @param subControllers - set an array of children view controllers
 *  @param viewController - set parent view controller
 *  @param show           - is show the arrow button
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController showArrowButton:(BOOL)show;

/**
 *  Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 */
- (void)addParentController:(UIViewController *)viewController;

@end
