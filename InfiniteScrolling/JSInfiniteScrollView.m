//
//  JSInfiniteScrollView.m
//  JSInfiniteScrolling
//
//  Created by James Addyman on 17/12/2011.
//

#import "JSInfiniteScrollView.h"

@interface JSInfiniteScrollView ()

- (NSInteger)previousIndex;
- (NSInteger)previous2Index;
- (NSInteger)nextIndex;
- (NSInteger)next2Index;
- (void)setupScrollView;
- (void)layoutScrollView;

@end

@implementation JSInfiniteScrollView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame dataSource:(id <JSInfiniteScrollViewDataSource>)dataSource delegate:(id <JSInfiniteScrollViewDelegate>)delegate
{
	if ((self = [super initWithFrame:frame]))
		{
		[self setBackgroundColor:[UIColor clearColor]];
		
		self.dataSource = dataSource;
		self.delegate = delegate;
		_currentIndex = 0;
		
		}
	
	return self;
}

- (void)dealloc
{
	self.delegate = nil;
	self.dataSource = nil;
	[super dealloc];
}

-(void)drawRect:(CGRect)rect{
	float width= [self.dataSource widthForElementInInfiniteScrollView:self];
	_scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2, 0,width, self.frame.size.height)] autorelease];
	
	[_scrollView setDelegate:self];
	[_scrollView setPagingEnabled:YES];
	[_scrollView setShowsVerticalScrollIndicator:NO];
	[_scrollView setShowsHorizontalScrollIndicator:NO];
	
	//show content outside of scrollview bounds
	_scrollView.clipsToBounds=NO;
	[self addSubview:_scrollView];
	
	[self reloadData];
}

//trick to catch touches outsede of scrollview
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        if ([[self subviews] count] > 0) {
            //force return of first child, if exists
            return [[self subviews] objectAtIndex:0];
        } else {
            return self;
        }
    }
    return nil;
}

- (NSInteger)previousIndex
{
	NSInteger previousIndex = _currentIndex - 1;
	if (previousIndex < 0)
		{
		previousIndex = _numberOfViews - 1;
		}
	
	return previousIndex;
}

- (NSInteger)previous2Index
{
	NSInteger previous2Index = [self previousIndex] - 1;
	if (previous2Index < 0)
		{
		previous2Index = _numberOfViews - 1;
		}
	
	return previous2Index;
}

- (NSInteger)nextIndex
{
	NSInteger nextIndex = _currentIndex + 1;
	if (nextIndex > _numberOfViews - 1)
		{
		nextIndex = 0;
		}
	
	return nextIndex;
}

- (NSInteger)next2Index
{
	NSInteger next2Index = [self nextIndex] + 1;
	if (next2Index > _numberOfViews - 1)
		{
		next2Index = 0;
		}
	
	return next2Index;
}

- (void)setupScrollView
{
	_currentIndex = 0;
	_numberOfViews = [self.dataSource numberOfViewsInInfiniteScrollView:self];
	
	if (_numberOfViews > 0)
		{
		_prevView = [self.dataSource infiniteScrollView:self viewForIndex:[self previousIndex]];
		[_scrollView addSubview:_prevView];
		
		_prevView2 = [self.dataSource infiniteScrollView:self viewForIndex:[self previous2Index]];
		[_scrollView addSubview:_prevView2];
		
		_currentView = [self.dataSource infiniteScrollView:self viewForIndex:_currentIndex];
		[_scrollView addSubview:_currentView];
		
		_nextView = [self.dataSource infiniteScrollView:self viewForIndex:[self nextIndex]];
		[_scrollView addSubview:_nextView];
		
		_nextView2 = [self.dataSource infiniteScrollView:self viewForIndex:[self next2Index]];
		[_scrollView addSubview:_nextView2];
		
		[self layoutScrollView];
		}
	
	[self.delegate infiniteScrollView:self didScrollToViewAtIndex:_currentIndex];
}

- (void)layoutScrollView
{
	CGRect viewFrame = [_prevView frame];
	viewFrame.origin.x = 0;
	[_prevView setFrame:viewFrame];
	
	CGRect view2Frame = [_prevView frame];
	view2Frame.origin.x = 0-_prevView.frame.size.width;
	[_prevView2 setFrame:view2Frame];
	
	viewFrame = [_currentView frame];
	viewFrame.origin.x = [_prevView frame].size.width;
	[_currentView setFrame:viewFrame];
	
	viewFrame = [_nextView frame];
	viewFrame.origin.x = [_prevView frame].size.width * 2;
	[_nextView setFrame:viewFrame];
	
	viewFrame = [_nextView2 frame];
	viewFrame.origin.x = [_prevView frame].size.width * 3;
	[_nextView2 setFrame:viewFrame];
	
	[_scrollView setContentSize:CGSizeMake([_prevView frame].size.width * 5, [self frame].size.height)];
	[_scrollView setContentOffset:CGPointMake([_prevView frame].size.width, 0)];
	_currentOffset = [_scrollView contentOffset];
}

-(void)redrawSubviews{
	
	if ([_scrollView contentOffset].x < _currentOffset.x)
		{
		_currentIndex = _currentIndex - 1;
		if (_currentIndex < 0)
			{
			_currentIndex = _numberOfViews - 1;
			}
		
		[_nextView2 removeFromSuperview];
		_nextView2=_nextView;
		_nextView = _currentView;
		_currentView = _prevView;
		_prevView=_prevView2;
		_prevView2 = [self.dataSource infiniteScrollView:self viewForIndex:[self previous2Index]];
		[_scrollView addSubview:_prevView2];
		
		[self layoutScrollView];
		}
	else if ([_scrollView contentOffset].x > _currentOffset.x)
		{
		_currentIndex = _currentIndex + 1;
		if (_currentIndex > _numberOfViews - 1)
			{
			_currentIndex = 0;
			}
		
		[_prevView2 removeFromSuperview];
		_prevView2=_prevView;
		_prevView = _currentView;
		_currentView = _nextView;
		_nextView=_nextView2;
		_nextView2 = [self.dataSource infiniteScrollView:self viewForIndex:[self next2Index]];
		[_scrollView addSubview:_nextView2];
		
		[self layoutScrollView];		
		}
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	//TODO: catch scroll when we didn't have change to redraw
	if ([_scrollView contentOffset].x > _currentOffset.x + (_currentView.frame.size.width * 1.5 )  )
		{
		
		}
	else if ([_scrollView contentOffset].x < _currentOffset.x  - (_currentView.frame.size.width *1.5) )
		{
	
		}
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self redrawSubviews];
	[self.delegate infiniteScrollView:self didScrollToViewAtIndex:_currentIndex];
	
}

- (void)reloadData
{
	[_prevView2 removeFromSuperview];
	[_prevView removeFromSuperview];
	[_currentView removeFromSuperview];
	[_nextView2 removeFromSuperview];
	[_nextView removeFromSuperview];
	
	[self setupScrollView];
}

@end
