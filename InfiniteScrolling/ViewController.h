//
//  ViewController.h
//  InfiniteScrolling
//
//  Created by James Addyman on 12/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSInfiniteScrollView.h"

@interface ViewController : UIViewController <JSInfiniteScrollViewDelegate, JSInfiniteScrollViewDataSource> {
	
	NSArray *_colours;
	JSInfiniteScrollView *scrollView1;
	JSInfiniteScrollView *scrollView2;
	IBOutlet UILabel *label1;
	IBOutlet UILabel *label2;
}
@property (nonatomic, retain) JSInfiniteScrollView *scrollView1;
@property (nonatomic, retain) JSInfiniteScrollView *scrollView2;

@end
