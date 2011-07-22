//
//  Downloader.m
//  URLDownloader
//
//  Created by Kristijan Sedlak on 7/21/11.
//  Copyright 2011 AppStrides. All rights reserved.
//

#import "URLDownloader.h"
#import "URLCredential.h"


#pragma mark -

@interface URLDownloader()

@property (retain) NSURLConnection *urlConnection;
@property (retain) NSURLResponse *urlResponse;
@property (retain) NSMutableData *urlData;
@property (retain) URLCredential *urlCredential;

@end


#pragma mark -

@implementation URLDownloader

@synthesize delegate;

@synthesize urlConnection;
@synthesize urlResponse;
@synthesize urlData;
@synthesize urlCredential;

#pragma mark General

- (void)dealloc 
{
	[urlConnection release];
    [urlResponse release];
	[urlData release];
    [urlCredential release];
	
    [super dealloc];
}

- (id)init
{
    return [super init];
}

+ (id)downloaderWithDelegate:(id)obj
{
    URLDownloader *downloader = [[URLDownloader alloc] init];
    downloader.delegate = obj;
    
    return [downloader autorelease];
}

- (void)reset
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark Actions

- (void)download:(NSURLRequest *)request authenticateWith:(URLCredential *)credential
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	self.urlData = [[[NSMutableData alloc] initWithData:nil] autorelease];
	self.urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
    self.urlCredential = credential;
    self.urlResponse = nil;
	
	NSLog(@"[URLDownloader] Download started");
}

- (void)cancel
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	[urlConnection cancel];
	
	NSLog(@"[URLDownloader] Download canceled");
    if ([self.delegate respondsToSelector:@selector(downloaderDidCancelDownloading:)])
    {
        [self.delegate downloaderDidCancelDownloading:self];
    }
}

#pragma mark Information

- (long)fullContentSize
{
    @try 
    {
        return [self.urlResponse expectedContentLength];
    }
    @catch (NSException * e) 
    {
        return 0.0;
    }
}

- (long)downloadedContentSize
{
    @try 
    {
        return (long)[self.urlData length];
    }
    @catch (NSException * e) 
    {
        return 0.0;
    }
}

- (float)downloadCompleteProcent
{
    float contentSize = (float)[self fullContentSize];
    float downloadedSize = (float)[self downloadedContentSize];
    
    return contentSize > 0.0 ? downloadedSize / contentSize : 0.0;
}

#pragma mark Connection

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge previousFailureCount] == 0)
	{
		NSLog(@"[URLDownloader] Authentication challenge received");
		
		NSURLCredential *credential = [NSURLCredential credentialWithUser:self.urlCredential.username
																 password:self.urlCredential.password
															  persistence:self.urlCredential.persistance];
        
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];

		NSLog(@"[URLDownloader] Credentials sent");
	}
	else
	{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
		NSLog(@"[URLDownloader] Authentication failed");
        [self.delegate downloader:self didFailOnAuthenticationChallenge:challenge];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.urlResponse = response;

    NSLog(@"[URLDownloader] Downloading ...");
    if ([self.delegate respondsToSelector:@selector(downloaderDidStart:)])
    {
        [self.delegate downloaderDidStart:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.urlData appendData:data];
    
    if ([self.delegate respondsToSelector:@selector(downloader:didReceiveData:)])
    {
        [self.delegate downloader:self didReceiveData:data];
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	NSLog(@"[URLDownloader] Error: %@, %d", error, [error code]);
	switch ([error code])
	{
		case NSURLErrorNotConnectedToInternet:
			[self.delegate downloader:self didFailWithNotConnectedToInternetError:error];
			break;
		default:
            [self.delegate downloader:self didFailWithError:error];;
			break;
	}    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSLog(@"[URLDownloader] Download finished");

    NSData *data = [NSData dataWithData:self.urlData];
    [self.delegate downloader:self didFinishWithData:data];
}

@end
