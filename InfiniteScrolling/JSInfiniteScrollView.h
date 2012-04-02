//
//  JSInfiniteScrollView.h
//  JSInfiniteScrolling
//
//  Created by James Addyman on 17/12/2011.
//

#import <UIKit/UIKit.h>

@class JSInfiniteScrollView;

@protocol JSInfiniteScrollViewDataSource <NSObject>

@required
- (NSUInteger)numberOfViewsInInfiniteScrollView:(JSInfiniteScrollView *)scrollView;
- (UIView *)infiniteScrollView:(JSInfiniteScrollView*)scrollView viewForIndex:(NSUInteger)index;
- (float)widthForElementInInfiniteScrollView:(JSInfiniteScrollView*)scrollView;
@end

@protocol JSInfiniteScrollViewDelegate <NSObject>

@optional
- (void)infiniteScrollView:(JSInfiniteScrollView *)scrollView didScrollToViewAtIndex:(NSUInteger)index;

@end

@interface JSInfiniteScrollView : UIView <UIScrollViewDelegate> {
	
	UIScrollView *_scrollView;

	NSUInteger _numberOfViews;
	NSInteger _currentIndex;
	
	UIView *_currentView;
	UIView *_prevView;
	UIView *_nextView;
	UIView *_prevView2;
	UIView *_nextView2;
	
	CGPoint _currentOffset;
	
}

@property (nonatomic, assign) id <JSInfiniteScrollViewDataSource> dataSource;
@property (nonatomic, assign) id <JSInfiniteScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame dataSource:(id <JSInfiniteScrollViewDataSource>)dataSource delegate:(id <JSInfiniteScrollViewDelegate>)delegate;
- (void) setSelectedIndex:(int)index;
- (void)reloadData;

@end
