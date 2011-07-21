//
//  Credentials.m
//  URLDownloader
//
//  Created by Kristijan Sedlak on 7/21/11.
//  Copyright 2011 AppStrides. All rights reserved.
//

#import "URLCredential.h"


@implementation URLCredential


#pragma mark -

@synthesize username;
@synthesize password;
@synthesize persistance;

#pragma mark - General

- (id)initWithDefaults
{
	if(self == [super init])
	{
		self.username = nil;
		self.password = nil;
        self.persistance = NSURLCredentialPersistenceForSession;
	}
	
	return self;
}

+ (id)credentialWithUsername:(NSString *)user andPassword:(NSString *)pass
{
    URLCredential *credential = [[URLCredential alloc] initWithDefaults];
    credential.username = user;
    credential.password = pass;

    return [credential autorelease];
}

- (void)dealloc 
{
	[username release];
	[password release];
    
    [super dealloc];
}

@end
