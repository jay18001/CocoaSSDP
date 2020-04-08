//
//  SSDPServiceBrowserTests.m
//  Copyright (c) 2015 Paul Williamson
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <XCTest/XCTest.h>
#import "SSDPProtocolTestHelper.h"
@import Foundation;
@import CocoaAsyncSocket;
@import CocoaSSDP;

@interface MockSocket : GCDAsyncUdpSocket
@property (nonatomic) BOOL shouldBeConnected;
@property (nonatomic) BOOL didBindToAddress;
@property (nonatomic) BOOL didJoinMulticastGroup;
@property (nonatomic) BOOL didClose;
@property (nonatomic) BOOL didBeginReceiving;
@property (nonatomic, copy) void (^sendDataBlock)(NSData * data, NSString * host, uint16_t port, NSTimeInterval timeout, long tag);
@end

@implementation MockSocket

- (BOOL)isConnected {
    return self.shouldBeConnected;
}

- (BOOL)bindToAddress:(NSData *)localAddr error:(NSError *__autoreleasing  _Nullable *)errPtr
{
    self.didBindToAddress = YES;
    return YES;
}

- (BOOL)joinMulticastGroup:(NSString *)group error:(NSError *__autoreleasing  _Nullable *)errPtr
{
    self.didJoinMulticastGroup = YES;
    return YES;
}

- (void)sendData:(NSData *)data toHost:(NSString *)host port:(uint16_t)port withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    if (self.sendDataBlock == NULL) {
        return;
    }
    self.sendDataBlock(data, host, port, timeout, tag);
}

- (BOOL)beginReceiving:(NSError *__autoreleasing  _Nullable *)errPtr {
    self.didBeginReceiving = YES;
    return YES;
}

- (void)close {
    self.didClose = YES;
}
@end

// You should normally favour dependancy injection, but as this is legacy code,
// we have to expose the private property instead.
@interface SSDPServiceBrowser ()
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;
- (NSString *)_userAgentString;
- (NSString *)_prepareSearchRequest;

// GCDAsyncUDPSocket delegate methods
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext;
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error;
@end


@interface SSDPServiceBrowserTests : XCTestCase

@end


@implementation SSDPServiceBrowserTests

- (void)testInitialisationSetsInterface
{
    // given
    NSString *interface = @"interface";
    
    // when
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc]
                                   initWithInterface:interface];
    
    // then
    XCTAssertNotNil(browser, @"Browser should not be nil");
    XCTAssert([browser.networkInterface isEqualToString:interface],
              @"Browser should set network interface");
}

- (void)testInitialisationHasSaneDefaults
{
    // when
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc] init];
    
    // then
    XCTAssertNotNil(browser, @"Browser should not be nil");
    XCTAssertNil(browser.networkInterface,
                 @"Browser should not set network interface");
}

- (void)testStartBrowsingForServicesSendsDataIfConnected
{
    MockSocket *mockSocket = [[MockSocket alloc] init];
    mockSocket.shouldBeConnected = YES;
    
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc] init];
    browser.socket = mockSocket;

    NSString *searchHeader = [NSString stringWithFormat:
                              @"M-SEARCH * HTTP/1.1\r\n"
                              @"HOST: 239.255.255.250:1900\r\n"
                              @"MAN: \"ssdp:discover\"\r\n"
                              @"ST: ssdp:all\r\n"
                              @"MX: 3\r\n"
                              @"USER-AGENT: %@/1\r\n\r\n\r\n",
                              [browser _userAgentString]];
    NSData *data = [searchHeader dataUsingEncoding:NSUTF8StringEncoding];

    mockSocket.sendDataBlock = ^(NSData *sendData, NSString * host, uint16_t port, NSTimeInterval timeout, long tag) {
        XCTAssertTrue([sendData isEqualToData:data]);
        XCTAssertEqual(host, @"239.255.255.250");
        XCTAssertEqual(port, 1900);
        XCTAssertEqual(timeout, -1);
        XCTAssertEqual(tag, 11);
        
    };

    // call
    [browser startBrowsingForServices:@"ssdp:all"];

    XCTAssertFalse(mockSocket.didBindToAddress);
    XCTAssertFalse(mockSocket.didJoinMulticastGroup);
    XCTAssertFalse(mockSocket.didBeginReceiving);
}

- (void)testStartBrowsingForServicesSetsUpSocketIfNotConnected
{
    MockSocket *mockSocket = [[MockSocket alloc] init];
    mockSocket.shouldBeConnected = NO;
    
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc] init];
    browser.socket = mockSocket;

    // call
    [browser startBrowsingForServices:@"ssdp:all"];

    XCTAssertTrue(mockSocket.didBindToAddress);
    XCTAssertTrue(mockSocket.didJoinMulticastGroup);
    XCTAssertTrue(mockSocket.didBeginReceiving);
}

- (void)testStoppingBrowsingForServicesClosesSocket
{
    MockSocket *mockSocket = [[MockSocket alloc] init];
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc] init];
    browser.socket = mockSocket;

    // we can't check that the socket is nil due to the lazy instantiation I
    // added because the class doesn't support dependancy injection

    // call
    [browser stopBrowsingForServices];

    XCTAssertTrue(mockSocket.didClose);
}

- (void)testReceivingDataInformsDelegate
{
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc] init];
    SSDPProtocolTestHelper *protocolHelper = [[SSDPProtocolTestHelper alloc] init];
    browser.delegate = protocolHelper;
    NSString *desc = @"recieving data informs delegate";
    XCTestExpectation *expectation = [self expectationWithDescription:desc];
    NSDictionary *expected = @{ @"location" : @"exampleLocation",
                                @"server" : @"exampleServer",
                                @"cacheControl" : @"exampleCacheControl",
                                @"searchTarget" : @"exampleSearchTarget",
                                @"usn" : @"exampleUSN" };
    
    // add a callback helper because the callback is sent with GCD
    protocolHelper.foundServiceBlock = ^void (SSDPServiceBrowser *argBrowser, SSDPService *service) {
        
        // expectations
        XCTAssert([argBrowser isEqual:browser],
                  @"Protocol should pass browser instance");
        
        NSURL *url = [NSURL URLWithString:expected[@"location"]];
        XCTAssert([service.location isEqual:url],
                  @"Service should have url location");
        
        XCTAssert([service.serviceType isEqualToString:expected[@"searchTarget"]],
                  @"Service should have service type");
        
        XCTAssert([service.uniqueServiceName isEqualToString:expected[@"usn"]],
                  @"Service should have unique service name");
        
        XCTAssert([service.server isEqualToString:expected[@"server"]],
                  @"Service should have server string");
        
        // inform that test has finished
        [expectation fulfill];
    };
    
    NSString *header = [NSString stringWithFormat:
                        @"HTTP/1.1 200 OK\r\n"
                        @"LOCATION: %@\r\n"
                        @"SERVER: %@\r\n"
                        @"CACHE-CONTROL: %@\r\n"
                        @"EXT: \r\n"
                        @"ST: %@\r\n"
                        @"USN: %@\r\n\r\n",
                        expected[@"location"],
                        expected[@"server"],
                        expected[@"cacheControl"],
                        expected[@"searchTarget"],
                        expected[@"usn"]];
    
    NSData *data = [header dataUsingEncoding:NSUTF8StringEncoding];
    [browser udpSocket:nil didReceiveData:data fromAddress:nil withFilterContext:nil];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testReceivingNotifyAliveInformsDelegate
{
    NSDictionary *expected = @{ @"location" : @"exampleLocation",
                                @"server" : @"exampleServer",
                                @"notifyTarget" : @"exampleSearchTarget",
                                @"usn" : @"exampleUSN" };
    
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc] init];
    SSDPProtocolTestHelper *protocolHelper = [[SSDPProtocolTestHelper alloc] init];
    browser.delegate = protocolHelper;
    NSString *desc = @"recieving data informs delegate";
    XCTestExpectation *expectation = [self expectationWithDescription:desc];
    
    // add a callback helper because the callback is sent with GCD
    protocolHelper.foundServiceBlock = ^void (SSDPServiceBrowser *argBrowser, SSDPService *service) {
        
        // expectations
        XCTAssert([argBrowser isEqual:browser],
                  @"Protocol should pass browser instance");
        
        NSURL *url = [NSURL URLWithString:expected[@"location"]];
        XCTAssert([service.location isEqual:url],
                  @"Service should have url location");
        
        XCTAssert([service.serviceType isEqualToString:expected[@"notifyTarget"]],
                  @"Service should have a service type");
        
        XCTAssert([service.cacheControlTime isEqual:@1800],
                  @"Service should have cache control timeout");
        
        XCTAssert([service.uniqueServiceName isEqualToString:expected[@"usn"]],
                  @"Service should have unique service name");
        
        XCTAssert([service.server isEqualToString:expected[@"server"]],
                  @"Service should have server string");
        
        // inform that test has finished
        [expectation fulfill];
    };
    
    NSString *header = [NSString stringWithFormat:
                        @"NOTIFY * HTTP/1.1\r\n"
                        @"HOST: 239.255.255.250:1900\r\n"
                        @"CACHE-CONTROL: max-age = 1800\r\n"
                        @"LOCATION: %@\r\n"
                        @"NT: %@\r\n"
                        @"NTS: ssdp:alive\r\n"
                        @"SERVER: %@\r\n"
                        @"USN: %@\r\n\r\n",
                        expected[@"location"],
                        expected[@"notifyTarget"],
                        expected[@"server"],
                        expected[@"usn"]];
    
    
    NSData *data = [header dataUsingEncoding:NSUTF8StringEncoding];
    [browser udpSocket:nil didReceiveData:data fromAddress:nil withFilterContext:nil];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testReceivingNotifyByeByeInformsDelegate
{
    NSDictionary *expected = @{ @"host" : @"239.255.255.250:1900",
                                @"notifyTarget" : @"exampleSearchTarget",
                                @"usn" : @"exampleUSN" };
    
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc] init];
    SSDPProtocolTestHelper *protocolHelper = [[SSDPProtocolTestHelper alloc] init];
    browser.delegate = protocolHelper;
    NSString *desc = @"recieving data informs delegate";
    XCTestExpectation *expectation = [self expectationWithDescription:desc];
    
    // add a callback helper because the callback is sent with GCD
    protocolHelper.removeServiceBlock = ^void (SSDPServiceBrowser *argBrowser, SSDPService *service) {
        
        // expectations
        XCTAssert([argBrowser isEqual:browser],
                  @"Protocol should pass browser instance");
        
        // host?
        
        XCTAssert([service.serviceType isEqualToString:expected[@"notifyTarget"]],
                  @"Service should have a service type");
        
        XCTAssert([service.uniqueServiceName isEqualToString:expected[@"usn"]],
                  @"Service should have unique service name");
        
        XCTAssertNil(service.server,
                  @"Service should not have server string");
        
        XCTAssertNil(service.cacheControlTime,
                  @"Service should not have cache control timeout");
        
        // inform that test has finished
        [expectation fulfill];
    };
    
    NSString *header = [NSString stringWithFormat:
                        @"NOTIFY * HTTP/1.1\r\n"
                        @"HOST: 239.255.255.250:1900\r\n"
                        @"NT: %@\r\n"
                        @"NTS: ssdp:byebye\r\n"
                        @"USN: %@\r\n\r\n",
                        expected[@"notifyTarget"],
                        expected[@"usn"]];
    
    
    NSData *data = [header dataUsingEncoding:NSUTF8StringEncoding];
    [browser udpSocket:nil didReceiveData:data fromAddress:nil withFilterContext:nil];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testSocketClosingInformsDelegateWithError
{
    SSDPServiceBrowser *browser = [[SSDPServiceBrowser alloc] init];
    NSError *fakeError = [NSError errorWithDomain:@"DOMAIN" code:20483 userInfo:nil];
    SSDPProtocolTestHelper *protocolHelper = [[SSDPProtocolTestHelper alloc] init];
    browser.delegate = protocolHelper;
    NSString *desc = @"informs delegate with error";
    XCTestExpectation *expectation = [self expectationWithDescription:desc];
    protocolHelper.errorServiceBlock = ^void (SSDPServiceBrowser *argBrowser, NSError *error) {

        XCTAssert([argBrowser isEqual:browser], @"Browser should be passed to delegate");
        XCTAssert([error isEqual:fakeError], @"Socket error should be passed to delegate");
        [expectation fulfill];
    };

    [browser udpSocketDidClose:nil withError:fakeError];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

@end
