//
//  ggMasterViewController.h
//  gegeradio
//
//  Created by Lace on 04/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ggDetailViewController;
@class ASIHTTPRequest;
@class TopicCellView;
@class AudioStreamer;

@interface ggMasterViewController : UITableViewController {
	NSMutableArray *arrayData;
	ASIHTTPRequest *request;
    
    TopicCellView *tmpCell;
    
    AudioStreamer *streamer;
    NSTimer *progressUpdateTimer;
    
    NSString *curURL;
}

@property (nonatomic, assign) IBOutlet TopicCellView *tmpCell;

@property (strong, nonatomic) ggDetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray *arrayData;
@property (retain, nonatomic) ASIHTTPRequest *request;
@property (retain, nonatomic) NSString *curURL;

@end
