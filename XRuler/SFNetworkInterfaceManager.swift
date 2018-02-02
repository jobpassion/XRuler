//
//  STNetworkInterfaceManager.swift
//  SimpleTunnel
//
//  Created by yarshure on 15/11/11.
//  Copyright © 2015年 Apple Inc. All rights reserved.
//

import Foundation
import DarwinCore
import AxLogger
func getIFAddresses() -> [NetInfo] {
    var addresses = [NetInfo]()
    let x = DCIPAddr.cellAddress()
    for (key,value) in x! {
        let info = NetInfo.init(ip: value as! String, netmask: "255.255.255.0", ifName: key as! String)
        addresses.append(info)
    }
    return addresses
}
public class SFNetworkInterfaceManager: NSObject {
    
     static public var defaultIPAddress:String = ""
     static public var WiFiIPAddress:String = ""
     static public var WWANIPAddress:String = ""
    
      static   var networkInfo:[NetInfo] = []
    


     static public  func updateIPAddress(){
        XRuler.log("clear ipaddress",level: .Info)

        networkInfo  = getIFAddresses()
        //en1 pdp_ip1
        for info in networkInfo{
            if info.ifName.hasPrefix("en") && (info.ip.range(of: "169.254") == nil){
                WiFiIPAddress = info.ip
            }
            
            if info.ifName.hasPrefix("pdp_ip"){
                WWANIPAddress = info.ip
            }
            XRuler.log(info.ip + " " + info.ifName, level: .Trace)
        }
        
        if SFEnv.hwType == .wifi {
            defaultIPAddress = WiFiIPAddress
        }else if  SFEnv.hwType == .cell {
            defaultIPAddress = WWANIPAddress
        }

        XRuler.log("Now default IPaddr \(defaultIPAddress)",level: .Info)
        XRuler.log("WI-FI:\(WiFiIPAddress) CELL:\(WWANIPAddress)",level: .Info)
        SFEnv.updateEnvIP(defaultIPAddress)
        
        
    }
 
   
     static public  func interfaceMTUWithName(_ name:String) ->Int {
        return 1500
    }
    deinit {
    }
}
