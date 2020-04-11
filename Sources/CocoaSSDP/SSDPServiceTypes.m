//
//  SSDPServiceTypes.m
//  Copyright (c) 2014 Stephane Boisson
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

@import Foundation;

#import "SSDPServiceTypes.h"

SSDPServiceType const SSDPServiceTypeAll = @"ssdp:all";

SSDPServiceType const SSDPServiceTypeUPnPRootDevice = @"upnp:rootdevice";

// UPnP Internet Gateway Device (IGD)
SSDPServiceType const SSDPServiceTypeUPnPInternetGatewayDevice1 = @"urn:schemas-upnp-org:device:InternetGatewayDevice:1";
SSDPServiceType const SSDPServiceTypeUPnPWANConnectionDevice1 = @"urn:schemas-upnp-org:device:WANConnectionDevice:1";
SSDPServiceType const SSDPServiceTypeUPnPWANDevice1 = @"urn:schemas-upnp-org:device:WANDevice:1";
SSDPServiceType const SSDPServiceTypeUPnPWANCommonInterfaceConfig1 = @"urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1";
SSDPServiceType const SSDPServiceTypeUPnPWANIPConnection1 = @"urn:schemas-upnp-org:service:WANIPConnection:1";
SSDPServiceType const SSDPServiceTypeUPnPLayer3Forwarding1 = @"urn:schemas-upnp-org:service:Layer3Forwarding:1";

// UPnP A/V profile
SSDPServiceType const SSDPServiceTypeUPnPMediaServer1 = @"urn:schemas-upnp-org:device:MediaServer:1";
SSDPServiceType const SSDPServiceTypeUPnPMediaRenderer1 = @"urn:schemas-upnp-org:device:MediaRenderer:1";
SSDPServiceType const SSDPServiceTypeUPnPContentDirectory1 = @"urn:schemas-upnp-org:service:ContentDirectory:1";
SSDPServiceType const SSDPServiceTypeUPnPRenderingControl1 = @"urn:schemas-upnp-org:service:RenderingControl:1";
SSDPServiceType const SSDPServiceTypeUPnPConnectionManager1 = @"urn:schemas-upnp-org:service:ConnectionManager:1";
SSDPServiceType const SSDPServiceTypeUPnPAVTransport1 = @"urn:schemas-upnp-org:service:AVTransport:1";

// UPnP Microsoft A/V profile
SSDPServiceType const SSDPServiceTypeMicrosoftMediaReceiverRegistrar1 = @"urn:microsoft.com:service:XMSMediaReceiverRegistrar:1";

// UPnP Sonos
SSDPServiceType const SSDPServiceTypeUPnPSonosZonePlayer1 = @"urn:schemas-upnp-org:device:ZonePlayer:1";
