//
//  Downloader.m
//  iOS-URLDownloader
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
    [urlConnection cancel];
    
	[delegate release];
    
	[urlConnection release];
    [urlResponse release];
	[urlData release];
    [urlCredential release];
	
    [super dealloc];
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

- (void)download:(NSURLRequest *)request withCredential:(URLCredential *)credential
{
    self.urlCredential = credential;
    self.urlResponse = nil;
	self.urlData = [[[NSMutableData alloc] initWithData:nil] autorelease];
	self.urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO] autorelease];

    [self.urlConnection start];
	
	NSLog(@"[URLDownloader] Download started");
}

- (void)cancel
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	[urlConnection cancel];
	
	NSLog(@"[URLDownloader] Download canceled");
    if ([self.delegate respondsToSelector:@selector(urlDownloaderDidCancelDownloading:)])
    {
        [self.delegate urlDownloaderDidCancelDownloading:self];
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
        [self.delegate urlDownloader:self didFailOnAuthenticationChallenge:challenge];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.urlResponse = response;
    [self.urlData setLength:0]; // in case of 302

    NSLog(@"[URLDownloader] Downloading %@ ...", [[response URL] absoluteString]);
    if ([self.delegate respondsToSelector:@selector(urlDownloaderDidStart:)])
    {
        [self.delegate urlDownloaderDidStart:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.urlData appendData:data];
    
    if ([self.delegate respondsToSelector:@selector(urlDownloader:didReceiveData:)])
    {
        [self.delegate urlDownloader:self didReceiveData:data];
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	NSLog(@"[URLDownloader] Error: %@, %d", error, [error code]);
	switch ([error code])
	{
		case NSURLErrorNotConnectedToInternet:
			[self.delegate urlDownloader:self didFailWithNotConnectedToInternetError:error];
			break;
		default:
            [self.delegate urlDownloader:self didFailWithError:error];;
			break;
	}    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSLog(@"[URLDownloader] Download finished");

    NSData *data = [NSData dataWithData:self.urlData];
    [self.delegate urlDownloader:self didFinishWithData:data];
}

@end
