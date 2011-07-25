//
//  URLDownloader.h
//  iOS-URLDownloader
//
//  Created by Kristijan Sedlak on 7/21/11.
//  Copyright 2011 AppStrides. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLDownloaderDelegate.h"

@class URLCredential;


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
