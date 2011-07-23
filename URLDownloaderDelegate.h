//
//  URLDownloaderDelegate.h
//  URLDownloader
//
//  Created by Kristijan Sedlak on 7/21/11.
//  Copyright 2011 AppStrides. All rights reserved.
//

#import <Foundation/Foundation.h>

@class URLDownloader;


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

