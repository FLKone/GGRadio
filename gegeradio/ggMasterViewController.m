//
//  ggMasterViewController.m
//  gegeradio
//
//  Created by Lace on 04/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ggMasterViewController.h"

#import "ggDetailViewController.h"

#import "ASIHTTPRequest.h"

#import "RegexKitLite.h"
#import "TopicCellView.h"

#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>



@implementation ggMasterViewController

@synthesize detailViewController = _detailViewController;

@synthesize arrayData;
@synthesize request, tmpCell, curURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Gégé Radio", @"Gégé Radio");
    }
    return self;
}
							
- (void)dealloc
{
    [_detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Download lifecycle

- (void)fetchContent
{
	
	[self setRequest:[ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.gerarddesuresnes.fr/wp-content/fmp-jw-files/playlists/fmp_jw_widget_playlist.xml"]]];
	[request setDelegate:self];
	
	[request setDidStartSelector:@selector(fetchContentStarted:)];
	[request setDidFinishSelector:@selector(fetchContentComplete:)];
	[request setDidFailSelector:@selector(fetchContentFailed:)];
	
	[request startSynchronous];
}

- (void)fetchContentStarted:(ASIHTTPRequest *)theRequest
{
    NSLog(@"fetchContentStarted");

}

- (void)fetchContentComplete:(ASIHTTPRequest *)theRequest
{
    NSLog(@"fetchContentComplete 0");
/*
    <track><title>~•~•~~ LES CONSEILS de GG & SANDY</title><location>http://dl.free.fr/ow8rKe0rh/Cetteemissionestreserveeaunpublicaverti.mp3</location><info>http://ggtv.online.fr/PHOTOS</info></track>
*/
    
    self.arrayData = (NSMutableArray *)[[theRequest responseString] 
                    arrayOfCaptureComponentsMatchedByRegex:@"<track>[^<]+<annotation>([^<]*)</annotation>[^<]+<location>([^<]*)</location>[^<]+<info>([^<]*)</info>[^<]+<image></image>[^<]+</track>"];
    
    
    NSLog(@"%d", arrayData.count);
    if (arrayData.count > 0) {
        NSLog(@"%@", [arrayData objectAtIndex:0]);
    }    
    
    /* 
    
     <track>
     <annotation>Les Débats de Gérard - 19970000 Débat sur la Fidelité</annotation>
     <location>http://gerarddesuresnes.fr/wp-content/uploads/2012/06/19970000_Debat_sur_la_fidelite.mp3</location>
     <info>http://gerarddesuresnes.fr/19970000-debat-sur-la-fidelite/</info>
     <image></image>
     </track>
     
    [doc release];
 */
    /*
    HTMLParser * myParser = [[HTMLParser alloc] initWithString:[request responseString] error:&error];
	HTMLNode * docNode = [myParser doc];
    
    NSArray *songArray = [docNode findChildTags:@"track"];
    
    NSLog(@"songArray count %d", songArray.count);	
     
     
     NSDictionary *ggDico = [XMLReader dictionaryForXMLData:[request responseData] error:&error];
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *ggDicoPath = [[NSString alloc] initWithString:[directory stringByAppendingPathComponent:@"ggdico.plist"]];    
    
    [ggDico writeToFile:ggDicoPath atomically:YES];
    
    NSLog(@"ggDico %@", ggDicoPath);
     */
}

- (void)fetchContentFailed:(ASIHTTPRequest *)theRequest
{
    NSLog(@"fetchContentFailed");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops !" message:[theRequest.error localizedDescription]
												   delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Réessayer", nil];
	[alert show];
	[alert release];	
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //DL XML
    //http://ggradio.online.fr/oezjno.xml
    NSLog(@"fetch");
    
    arrayData = [[NSMutableArray alloc] init];
    curURL = [[NSString alloc] init];
    
    [self fetchContent];
    
    [self.tableView reloadData];
    NSLog(@"fetch END");
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplicationCell";
    
    TopicCellView *cell = (TopicCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        
        [[NSBundle mainBundle] loadNibNamed:@"TopicCellView" owner:self options:nil];
        cell = tmpCell;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;	
        
        self.tmpCell = nil;		
	}
    
    NSData *dat = [[[arrayData objectAtIndex:indexPath.row] objectAtIndex:1] dataUsingEncoding:NSISOLatin1StringEncoding];

    
    NSString *content = [[NSString alloc]  initWithBytes:[dat bytes]
                                                  length:[dat length] encoding: NSUTF8StringEncoding];
    
    [cell.titleLabel setText:content];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
        NSLog(@"streamer");
		return;
	}
    
	[self destroyStreamer];
	
	NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)curURL,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	/*
	progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //return;
    [self destroyStreamer];
    
    [self setCurURL:[[arrayData objectAtIndex:indexPath.row] objectAtIndex:2]];
    
    NSLog(@"SELECTED URL %@", [[arrayData objectAtIndex:indexPath.row] objectAtIndex:2]);
    
    [self createStreamer];
    [streamer start];
   /*
    
    if (!self.detailViewController) {
        self.detailViewController = [[[ggDetailViewController alloc] initWithNibName:@"ggDetailViewController" bundle:nil] autorelease];
    }
    [self.navigationController pushViewController:self.detailViewController animated:YES];
     */
}




@end
