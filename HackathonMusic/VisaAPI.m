//
//  VisaAPI.m
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "VisaAPI.h"

@interface VisaAPI ()


@end

@implementation VisaAPI

+(VisaAPI *) shared{
    static dispatch_once_t pred;
    static VisaAPI *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[VisaAPI alloc] init];
    });
    return shared;
}

+ (void)triggerCall
{
    [[VisaAPI shared] retrieveResponseAsync];
}


- (void)retrieveResponseAsync
{
    self.status = @"Retrieving response async";
    self.response = @"";
    
    NSURL *requestUrl = [[NSURL alloc] initWithString:@"https://sandbox.api.visa.com/vdp/helloworld"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    
    //username and password value
    NSString *username = @"6LSKH3ULLJOA41A7RCAY21NSxQpmnAI-MjtikZZQC8vN4FA7A";
    NSString *password = @"GNzyM9SUQg87Gb41UQkSrK";
    
    //HTTP Basic Authentication
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64Encoding];
    
    // Set your user login credentials
    [request setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forHTTPHeaderField:@"Authorization"];
    
    // Send your request asynchronously
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response recieved");
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data
{
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.response = responseString;
    
    NSLog(@"Data recieved, %@", self.response);

    self.status = @"Response retrieved async";
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Authentication challenge");
    
    // load cert
    NSString *path = [[NSBundle mainBundle] pathForResource:@"visavis_keyAndCertBundle" ofType:@"p12"];
    NSData *p12data = [NSData dataWithContentsOfFile:path];
    CFDataRef inP12data = (__bridge CFDataRef)p12data;
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    OSStatus status = extractIdentityAndTrust(inP12data, &myIdentity, &myTrust);
    
    SecCertificateRef myCertificate;
    SecIdentityCopyCertificate(myIdentity, &myCertificate);
    const void *certs[] = { myCertificate };
    CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
    
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
    
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection*) connection didFailWithError:(NSError *)error
{
    NSLog([NSString stringWithFormat:@"Did recieve error: %@", [error localizedDescription]]);
    NSLog([NSString stringWithFormat:@"%@", [error userInfo]]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
{
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}



@end
