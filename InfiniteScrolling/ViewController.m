//
//  ViewController.m
//  InfiniteScrolling
//
//  Created by James Addyman on 12/12/2011.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

@synthesize scrollView1,scrollView2;

float static dial1Width=195.0;
float static dial1Height=37.0;

float static dial2Width=70.0;
float static dial2Height=50.0;

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_colours = [[NSArray alloc] initWithObjects:
				[UIColor redColor],
				[UIColor blueColor],
				[UIColor yellowColor],
				[UIColor greenColor],
				[UIColor brownColor],
				[UIColor magentaColor],
				[UIColor lightGrayColor],
				[UIColor orangeColor],
				nil];
	
	self.scrollView1 = [[JSInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, dial1Height)
																 dataSource:self
																   delegate:self];
	
	[self.scrollView1 setClipsToBounds:NO];
	[self.view addSubview:self.scrollView1];
	
	UIImageView *mask=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
	mask.frame=self.scrollView1.frame;
	[self.view addSubview:mask];
	
	self.scrollView2 = [[[JSInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, dial2Height)
													dataSource:self
													  delegate:self] autorelease];
	[self.view addSubview:self.scrollView2];

	
}

- (void)viewDidUnload
{
	[scrollView1 release];
	[label1 release];
	label1 = nil;
	[label2 release];
	label2 = nil;
	[super viewDidUnload];
	[_colours release], _colours = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger)numberOfViewsInInfiniteScrollView:(JSInfiniteScrollView *)scrollView
{
	return 8;
}

-(float)widthForElementInInfiniteScrollView:(JSInfiniteScrollView *)scrollView{
	if (scrollView==self.scrollView1) {
		return dial1Width;
	}
	if (scrollView==self.scrollView2) {
		return dial2Width;
	}
	return self.view.frame.size.width;
}
- (UIView *)infiniteScrollView:(JSInfiniteScrollView*)scrollView viewForIndex:(NSUInteger)index
{
	
	if (scrollView==self.scrollView1) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dial1Width, dial1Height)];
		view.backgroundColor = [UIColor clearColor];
		UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dial-bg.png"]];
		[view addSubview:iv];
		
		UILabel *label = [[[UILabel alloc] initWithFrame:view.frame] autorelease];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setText:[NSString stringWithFormat:@"ITEM %d", index]];
		[view addSubview:label];
		return view;
	}
	if ( scrollView==self.scrollView2) {
		
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, dial2Width, dial2Height)] autorelease];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setBackgroundColor:[_colours objectAtIndex:index]];
		[label setText:[NSString stringWithFormat:@"ITEM %d", index]];
		return label;
	}
	return nil;
}

- (void)infiniteScrollView:(JSInfiniteScrollView *)scrollView didScrollToViewAtIndex:(NSUInteger)index
{
	if (scrollView==scrollView1) {
		label1.text=[NSString stringWithFormat:@"Selected: %i",index];
	}
	if (scrollView==scrollView2) {
		label2.text=[NSString stringWithFormat:@"Selected: %i",index];
	}
}

- (void)dealloc {
	[label1 release];
	[label2 release];
	[super dealloc];
}
@end
