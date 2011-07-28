//
//  URLDownloader.h
//  iOS-URLDownloader
//
//  Created by Kristijan Sedlak on 7/21/11.
//  Copyright 2011 AppStrides. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLCredential.h"

@class URLDownloader;


#pragma mark -

@protocol URLDownloaderDelegate <NSObject>

@required
- (void)urlDownloader:(URLDownloader *)urlDownloader didFinishWithData:(NSData *)data;
- (void)urlDownloader:(URLDownloader *)urlDownloader didFailOnAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)urlDownloader:(URLDownloader *)urlDownloader didFailWithError:(NSError *)error;
- (void)urlDownloader:(URLDownloader *)urlDownloader didFailWithNotConnectedToInternetError:(NSError *)error;

@optional
- (void)urlDownloaderDidStart:(URLDownloader *)urlDownloader;
- (void)urlDownloaderDidCancelDownloading:(URLDownloader *)urlDownloader;
- (void)urlDownloader:(URLDownloader *)urlDownloader didReceiveData:(NSData *)data;

@end


#pragma mark -

@interface URLDownloader : NSObject
{
    id <URLDownloaderDelegate> delegate;

	NSURLConnection *urlConnection;
    NSURLResponse *urlResponse;
	NSMutableData *urlData;
    URLCredential *urlCredential;
}

@property (retain) id <URLDownloaderDelegate> delegate;

+ (id)downloaderWithDelegate:(id)obj;
- (void)download:(NSURLRequest *)request withCredential:(URLCredential *)credential;
- (void)cancel;

@end
