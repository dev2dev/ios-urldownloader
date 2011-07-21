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
- (void)downloader:(URLDownloader *)downloader didFinishWithData:(NSData *)data;
- (void)downloader:(URLDownloader *)downloader didFailOnAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)downloader:(URLDownloader *)downloader didFailWithError:(NSError *)error;
- (void)downloader:(URLDownloader *)downloader didFailWithNotConnectedToInternetError:(NSError *)error;

@optional
- (void)downloaderDidStart:(URLDownloader *)downloader;
- (void)downloaderDidCancelDownloading:(URLDownloader *)downloader;
- (void)downloader:(URLDownloader *)downloader didReceiveData:(NSData *)data;

@end

