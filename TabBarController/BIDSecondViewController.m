//
//  BIDSecondViewController.m
//  TabBarController
//
//  Created by gtcc on 2/19/14.
//  Copyright (c) 2014 xc. All rights reserved.
//

#import "BIDSecondViewController.h"
#import "FtpServer.h"


#define FTP_PORT 20000
@interface BIDSecondViewController ()
@property BOOL isServerRunning;
@end

@implementation BIDSecondViewController
@synthesize theServer, baseDir,ServerInfoView, ServerTitleLabel,btnControlServer,isServerRunning;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ----------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL) animated  {
    // ----------------------------------------------------------------------------------------------------------
    
	[super viewDidAppear:animated];
	
    [self startServer];
}

- (void) startServer
{
    ///	NSString *localIPAddress = [ NetworkController localIPAddress ];
	NSString *localIPAddress = [ NetworkController localWifiIPAddress ];
	
    self.ServerTitleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", @"Connect to", localIPAddress, @"port 20000"];
    self.ServerTitleLabel.hidden = false;
    
    self.ServerInfoView.text = @"The FTP Server has been enabled, please use FTP client software to transfer any import/export data to or from this device.\nPress the \"Stop Server\" button once all data transfers have been completed.";
    self.ServerInfoView.hidden = false;
    
	NSArray *docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES );
	self.baseDir =  [docFolders lastObject];
    
	
	FtpServer *aServer = [[ FtpServer alloc ] initWithPort:20000 withDir:baseDir notifyObject:self ];
	self.theServer = aServer;
    [aServer release];
    
    self.isServerRunning = TRUE;
    [self.btnControlServer setTitle:@"Stop Server" forState:UIControlStateNormal] ;
}

// ----------------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    // ----------------------------------------------------------------------------------------------------------
	if (buttonIndex == 0) {
		[alert dismissWithClickedButtonIndex:0 animated:YES];
		[self stopFtpServer];
	}
}

// This is a method that will shut down the server cleanly, it calles the stopFtpServer method of FtpServer class.
// ----------------------------------------------------------------------------------------------------------
- (void)stopFtpServer {
    // ----------------------------------------------------------------------------------------------------------
	NSLog(@"Stopping the FTP server");
    
    self.isServerRunning = FALSE;
    [self.btnControlServer setTitle:@"Start Server" forState:UIControlStateNormal] ;
    self.ServerTitleLabel.hidden = true;
    self.ServerInfoView.hidden = true;
    
	if(theServer)
	{
		[theServer stopFtpServer];
        [theServer release];
		theServer=nil;
	}
}

-(void)didReceiveFileListChanged
// ----------------------------------------------------------------------------------------------------------
{
	NSLog(@"didReceiveFileListChanged");
}

- (void)dealloc {
    [self.ServerInfoView release];
    [self.ServerTitleLabel release];
    [self.btnControlServer release];
    [super dealloc];
}
- (IBAction)ToggleServer:(id)sender {
    if(self.isServerRunning)
    {
        [self stopFtpServer];
    }else
    {
        [self startServer];
    }
}
@end
