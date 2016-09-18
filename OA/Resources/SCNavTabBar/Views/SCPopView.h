#import <UIKit/UIKit.h>

@protocol SCPopViewDelegate <NSObject>

@optional
- (void)viewHeight:(CGFloat)height;
- (void)itemPressedWithIndex:(NSInteger)index;

@end

@interface SCPopView : UIView

@property (nonatomic, weak)     id      <SCPopViewDelegate>delegate;
@property (nonatomic, strong)   NSArray *itemNames;

@end
