/* 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
   
   Copyright (c) 2010 Seleuco.
   
*/

#import "DonateController.h"
#include <stdio.h>

extern iphone_menu;

@implementation DonateController

@synthesize bIsDismissed;

- (id)init {

    if (self = [super init]) {

        bIsDismissed = NO;
        navBar = nil;
        aWebView = nil;
    }

    return self;

}

- (void)loadView {

	struct CGRect rect = [[UIScreen mainScreen] bounds];
	rect.origin.x = rect.origin.y = 0.0f;
	UIView *view= [[UIView alloc] initWithFrame:rect];
	self.view = view;
	[view release];
    self.view.backgroundColor = [UIColor whiteColor];
    
   navBar = [ [ UINavigationBar alloc ] initWithFrame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
   [ navBar setDelegate: self ];

   UINavigationItem *item = [[ UINavigationItem alloc ] initWithTitle:@"Donate" ];
   
   UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStyleBordered target:self action:  @selector(mydone:) ] autorelease];
   item.rightBarButtonItem = backButton;
  
   /*  
   UILabel *bigLabel = [[UILabel alloc] init];
   bigLabel.text = @"I am BIG";
   bigLabel.font = [UIFont fontWithName:@"Arial" size: 22.0];
   [bigLabel sizeToFit];
   item.titleView = bigLabel;
   [bigLabel release];
   */
   [ navBar pushNavigationItem: item  animated:YES];
     
   [ self.view addSubview: navBar ];
    

   aWebView = [ [ UIWebView alloc ] initWithFrame: CGRectMake(rect.origin.x, rect.origin.y + 45.0f, rect.size.width,rect.size.height - 45.0f )];

   aWebView.scalesPageToFit = YES;

   aWebView.autoresizesSubviews = YES;
   aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);

   //set the web view delegates for the web view to be itself
   [aWebView setDelegate:self];

   
   //Set the URL to go to for your UIWebView
   NSString *urlAddress = @"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=seleuco%2enicator%40gmail%2ecom&lc=GB&item_name=Seleuco&item_number=iXpectrum&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted";

   //Create a URL object.
   NSURL *url = [NSURL URLWithString:urlAddress];

   //URL Requst Object
   NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
   
   
   //load the URL into the web view.
   [aWebView loadRequest:requestObj];
      
   /*
   NSString *HTMLData = [[NSString alloc] initWithContentsOfFile: @"/Applications/iXpectrum.app/donate.html"];
      
   NSURL *aURL = [NSURL fileURLWithPath:@"/Applications/iXpectrum.app/"];
      
   [aWebView loadHTMLString:HTMLData baseURL: aURL];
   
   [HTMLData release];
   */
   
   [ self.view addSubview: aWebView ];

}


-(void)mydone:(id)sender{
   //[aWebView setDelegate:nil];
    if ([aWebView isLoading])
        [aWebView stopLoading];
   [self dismissModalViewControllerAnimated:YES];
   iphone_menu = 0; 
}


-(void)viewDidLoad{	
   
   
   	        UIAlertView *thksAlert = [[UIAlertView alloc] initWithTitle:@"Thanks for your support!" 
															  message:[NSString stringWithFormat:@"Many hours of work went into the creation of iXpectrum. If you find this application useful make a donation to the author.\n Everything is appreciated."] 
															 delegate:self 
													cancelButtonTitle:@"OK" 
													otherButtonTitles: nil];
	
	       [thksAlert show];
	       [thksAlert release];
     
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //[navBar topItem].title = webView.request.URL.absoluteString;
     //[self retain];    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navBar!=nil && [navBar topItem]!= nil)
      [navBar topItem].title = @"Wait... Loading!";
   return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(navBar!=nil && [navBar topItem]!= nil)
      [navBar topItem].title = @"Error";
    if(error!=nil && error.code != NSURLErrorCancelled)
    {
		UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"Connection Failed!" 
																  message:[NSString stringWithFormat:@"There is no internet connection. Connect to the internet and try again. Error:%@",[error localizedDescription]] 
																 delegate:self 
														cancelButtonTitle:@"OK" 
														otherButtonTitles: nil];
		
		[connectionAlert show];
		[connectionAlert release];
	}
    //[self release];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

   if(navBar!=nil && webView!=nil)
   {
       if([navBar topItem]!= nil && webView.request!=nil)
         [navBar topItem].title = webView.request.URL.absoluteString;
   }  
   //[self release];   
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
       return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	//[super didReceiveMemoryWarning];
}


- (void)dealloc {
   
  
    if(navBar!=nil)
    {
       [navBar  release];
       navBar = nil;
    }  
    
    if(aWebView!=nil)
    {
       //[aWebView stopLoading]; 
       [aWebView setDelegate:nil];       
       [aWebView release];
       aWebView = nil;
    }   
     
	[super dealloc];
}

@end