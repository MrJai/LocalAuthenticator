//
//  LocalAuthenticator.swift
//  Local Authenticator
//
//  Created by Junaid Rehmat on 10/11/2018.
//  Copyright © 2018 Junaid Rehmat. All rights reserved.
//

import Foundation
import LocalAuthentication

let LOCAL_AUTH_CREDS = "localAuthCredentials"
public class LocalAuthenticator {
    
//    var completionHandler: ((Bool, String) -> Void)?
    
    //returns all possible Local Authentication values
    public static func canUseLocalAuthentication() -> Int32 {
        if let _ = NSClassFromString("LAContext") {
            let context = LAContext()
            var authError:NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                return kLAPolicyDeviceOwnerAuthenticationWithBiometrics
            }
            else
            {
                switch authError?.code
                {
                case Int(kLAErrorTouchIDNotAvailable):
                    return kLAErrorTouchIDNotAvailable
                case Int(kLAErrorTouchIDNotEnrolled):
                    return kLAErrorTouchIDNotEnrolled
                case Int(kLAErrorTouchIDLockout):
                    return kLAErrorTouchIDLockout
                default:
                    return kLAPolicyDeviceOwnerAuthenticationWithBiometrics
                }
            }
        }
        return kLAErrorTouchIDNotAvailable
    }
    
    //validate local authentication
    //@returns True in case of success
    //@returns false in case of failure
    //@returns reason in case of failure
    public static func validateLocalAuthentication(handler: @escaping ((Bool, String ) -> Void)) {
        
        let deviceType = self.faceIDAvailable() ? "Face" : "Touch"
        
        switch self.canUseLocalAuthentication() {
        case kLAErrorTouchIDNotAvailable:
            handler(false,String(deviceType+" ID isn't available"))
            break
        case kLAErrorTouchIDNotEnrolled:
            handler(false,String("You have not configured "+deviceType+" ID on your device. Please configure it in order to use this feature."))
            break
        case kLAErrorAuthenticationFailed:
            handler(false, String("AuthenticationFailed"))
            break
        case kLAErrorTouchIDLockout:
            handler(false,String("Your "+deviceType+" ID is locked due to 5 unsuccessful attempts. Please unlock it through settings using your passcode."))
           break
        case kLAPolicyDeviceOwnerAuthenticationWithBiometrics:
            let context = LAContext()
            context.localizedFallbackTitle = ""
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: String(deviceType+" ID is required to login to this app automatically."))
            { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        handler(true, "")
                    }
                    else
                    {
                        let errorObj = error;
                        handler(false,(errorObj?.localizedDescription)!)
                    }
                }
            }
            break
        default:
            break
        }
    }
    
    public static func localAuthenticationAvailable() -> Bool {
        guard self.canUseLocalAuthentication()==kLAErrorTouchIDNotAvailable else {
            return true
        }
        return false
    }
    
    public static func localAuthenticationConfigured() -> Bool {
        guard self.localAuthenticationAvailable() && (self.canUseLocalAuthentication() == kLAErrorTouchIDNotEnrolled) else {
            return true
        }
        return false
    }
    
    public static func touchIDAvailable() -> Bool {
        if let _ = NSClassFromString("LAContext") {
            let context = LAContext()
            var authError:NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
            {
                if  #available(iOS 11, *) {
                    return context.biometryType == LABiometryType.touchID
                }
            }
        }
        return false;
    }
    
    public static func faceIDAvailable() -> Bool {
        if let _ = NSClassFromString("LAContext") {
            let context = LAContext()
            var authError:NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
            {
                if  #available(iOS 11, *) {
                    return context.biometryType == LABiometryType.faceID
                }
            }
        }
        return false;
    }
    
    public static func saveCredentials(credentials: Dictionary<String, String>) -> Bool {
        do {
            if #available(iOS 11.0, *) {
                let credData = try NSKeyedArchiver.archivedData(withRootObject: credentials, requiringSecureCoding: true)
                UserDefaults.standard.set(credData, forKey: LOCAL_AUTH_CREDS)
                return UserDefaults.standard.synchronize()

            } else {
                // Fallback on earlier versions
            }
            return false
        } catch {
            print("Some error in credentials object",credentials)
        }
        return false
    }
    
    public static func updateCredentials(value: String, key: String) -> Bool {
        var savedCred = self.getSavedCredentials()
        savedCred[key] = value
        return self.saveCredentials(credentials: savedCred)
    }
    
    public static func getSavedCredentials() -> Dictionary<String, String> {
        if  let credData = UserDefaults.standard.object(forKey: LOCAL_AUTH_CREDS) {
            do
            {
                if #available(iOS 9.0, *) {
                    if let credDict = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(credData as! Data)
                    {
                        return credDict as! Dictionary<String, String>
                    }
                    else
                    {
                        print("Fatal Error: Could not decode archived object");
                        return [:]
                    }
                } else {
                    // Fallback on earlier versions
                    return [:]
                }
            }
            catch
            {
                print("Exception Caught")
                return [:]
            }
            
        }
        return [:]
    }
    
    public static func removeSavedCredentials() -> Bool {
        UserDefaults.standard.removeObject(forKey: LOCAL_AUTH_CREDS)
        return UserDefaults.standard.synchronize()
    }
}


