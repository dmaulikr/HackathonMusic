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
//        NSURL *requestUrl = [[NSURL alloc] initWithString:@"https://sandbox.api.visa.com/vdp/helloworld"];
    NSURL *requestUrl = [[NSURL alloc] initWithString:@"https://sandbox.api.visa.com/visadirect/fundstransfer/v1/pushfundstransactions"];
//    NSURL *requestUrl = [[NSURL alloc] initWithString:@"https://sandbox.api.visa.com/visadirect/fundstransfer/v1/pullfundstransactions"];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    request.HTTPMethod = @"POST";
    
    //username and password value
    NSString *username = @"6LSKH3ULLJOA41A7RCAY21NSxQpmnAI-MjtikZZQC8vN4FA7A";
    NSString *password = @"GNzyM9SUQg87Gb41UQkSrK";
    
    //HTTP Basic Authentication
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64EncodedStringWithOptions:kNilOptions];
    
    // Set your user login credentials
    [request setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forHTTPHeaderField:@"Authorization"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, application/octet-stream" forHTTPHeaderField:@"Accept"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pushbody" ofType:@"json"];
    NSString *JSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[JSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&error];
    [request setHTTPBody:postdata];
    
//    request.HTTPBody = [[self pullFundsBodyString] dataUsingEncoding:NSUTF8StringEncoding];
    
    // Send your request asynchronously
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse * httpRespo = (NSHTTPURLResponse *)response;
    NSLog(@"Response recieved, status: %@", [[httpRespo allHeaderFields] description]);
    
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data
{
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.response = responseString;
    
    NSLog(@"Data recieved, %@", self.response);

    self.status = @"Response retrieved async";
    
    NSError * error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if (self.callFinished && responseString) {
        self.callFinished(jsonObject);
    }
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
    NSLog(@"%@",[NSString stringWithFormat:@"Did recieve error: %@", [error localizedDescription]]);
    NSLog(@"%@",  [NSString stringWithFormat:@"%@", [error userInfo]]);
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

- (NSString *) PushFundsBodyString
{
    NSString * jsonstring = @"{\
    'acquirerCountryCode': '840',\
    'acquiringBin': '408999',\
    'amount': '124.05',\
    'businessApplicationId': 'AA',\
    'cardAcceptor': {\
    'address': {\
    'country': 'USA',\
    'county': 'San Mateo',\
    'state': 'CA',\
    'zipCode': '94404'\
    },\
    'idCode': 'VMT200911026070',\
    'name': 'Acceptor 1',\
    'terminalId': 'TID-9999'\
    },\
    'localTransactionDateTime': '2016-04-16T15:56:51',\
    'merchantCategoryCode': '6012',\
    'pointOfServiceData': {\
    'motoECIIndicator': '0',\
    'panEntryMode': '90',\
    'posConditionCode': '00'\
    },\
    'recipientName': 'rohan',\
    'recipientPrimaryAccountNumber': '4957030420210462',\
    'retrievalReferenceNumber': '330000550000',\
    'senderAccountNumber': '4957030420210454',\
    'senderAddress': '901 Metro Center Blvd',\
    'senderCity': 'Foster City',\
    'senderCountryCode': '124',\
    'senderName': 'Mohammed Qasim',\
    'senderReference': '',\
    'senderStateCode': 'CA',\
    'sourceOfFundsCode': '05',\
    'systemsTraceAuditNumber': '451000',\
    'transactionCurrencyCode': 'USD',\
    'transactionIdentifier': '381228649430011'\
    }";
    return [[jsonstring componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
}

- (NSString *) pullFundsBodyString
{
    NSString * jsonstring = @"\
    {\
    'acquirerCountryCode': '840',\
    'acquiringBin': '408999',\
    'amount': '124.02',\
    'businessApplicationId': 'AA',\
    'cardAcceptor': {\
    'address': {\
    'country': 'USA',\
    'county': 'San Mateo',\
    'state': 'CA',\
    'zipCode': '94404'\
    },\
    'idCode': 'VMT200911026070',\
    'name': 'Acceptor 1',\
    'terminalId': '365539'\
    },\
    'cavv': '0000010926000071934977253000000000000000',\
    'foreignExchangeFeeTransaction': '11.99',\
    'localTransactionDateTime': '2016-04-16T17:43:02',\
    'retrievalReferenceNumber': '330000550000',\
    'senderCardExpiryDate': '2015-10',\
    'senderCurrencyCode': 'USD',\
    'senderPrimaryAccountNumber': '4005520000011126',\
    'surcharge': '11.99',\
    'systemsTraceAuditNumber': '451001'\
    }";
    return [[jsonstring componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    
}



@end
