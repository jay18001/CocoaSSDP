//
//  SSDPServiceTypes.h
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

typedef NSString * SSDPServiceType NS_EXTENSIBLE_STRING_ENUM;

///-----------------------------------------------------------------------------
/// @name General Searches
///-----------------------------------------------------------------------------

/**
 A general search type which all devices should respond to: `ssdp:all`
 */
extern SSDPServiceType const SSDPServiceTypeAll;

/**
 Search target for UPnP Root Devices: `upnp:rootdevice`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPRootDevice;


///-----------------------------------------------------------------------------
/// @name UPnP Internet Gateway Device (IGD)
///-----------------------------------------------------------------------------

/**
 Search target for Internet Gateway Devices:
 `urn:schemas-upnp-org:device:InternetGatewayDevice:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPInternetGatewayDevice1;

/**
 Search target for WAN Connection Devices:
 `urn:schemas-upnp-org:device:WANConnectionDevice:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPWANConnectionDevice1;

/**
 Search target for WAN Devices: `urn:schemas-upnp-org:device:WANDevice:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPWANDevice1;

/**
 Search target for WAN Common Interface Config Services: 
 `urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPWANCommonInterfaceConfig1;

/**
 Search target for WAN IP Connection Services:
 `urn:schemas-upnp-org:service:WANIPConnection:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPWANIPConnection1;

/**
 Search target for Layer 3 Forwarding Services:
 `urn:schemas-upnp-org:service:Layer3Forwarding:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPLayer3Forwarding1;


///-----------------------------------------------------------------------------
/// @name UPnP A/V profile
///-----------------------------------------------------------------------------

/**
 Search target for Media Server 1 Devices:
 `urn:schemas-upnp-org:device:MediaServer:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPMediaServer1;
/**
 Search target for Media Renderer 1 Devices:
 `urn:schemas-upnp-org:device:MediaRenderer:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPMediaRenderer1;
/**
 Search target for Content Directory 1 Services:
 `urn:schemas-upnp-org:service:ContentDirectory:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPContentDirectory1;
/**
 Search target for Connection Manager Services:
 `urn:schemas-upnp-org:service:ConnectionManager:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPConnectionManager1;
/**
 Search target for Rendering Control Services:
 `urn:schemas-upnp-org:service:RenderingControl:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPRenderingControl1;
/**
 Search target for AV Transport 1 Services:
 `urn:schemas-upnp-org:service:AVTransport:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPAVTransport1;


///-----------------------------------------------------------------------------
/// @name UPnP Microsoft A/V profile
///-----------------------------------------------------------------------------

/**
 Search target for Media Receiver Registrar 1 Services:
 `urn:microsoft.com:service:XMSMediaReceiverRegistrar:1`
 */
extern SSDPServiceType const SSDPServiceTypeMicrosoftMediaReceiverRegistrar1;


///-----------------------------------------------------------------------------
/// @name Sonos
///-----------------------------------------------------------------------------

/**
 Search target for Sonos Devices:
 `urn:schemas-upnp-org:device:ZonePlayer:1`
 */
extern SSDPServiceType const SSDPServiceTypeUPnPSonosZonePlayer1;
