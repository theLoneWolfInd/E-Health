//


// rahu kaal : 10 - 12 kuch nai krna
 // === > 1 bje jae , 



//  AppDelegate.swift
//  E health App
//
//  Created by Ranjan on 16/08/21.
//

// // 9501795017
/*
[action] => addanswer
    [userId] => 395
    [answerJson] => [{"questionName":"Patient Name","answer":"neema","questionId":"1"},{"questionName":"Patient Residential Address","answer":"ramprastha ","questionId":"2"},{"questionName":"Patient Date of Birth?","answer":"23 jan 2000","questionId":"3"},{"questionName":"Describe briefly your present symptoms","answer":"","questionId":"6"},{"questionName":"Please list the names of other practitioners you have seen for this problem:","answer":"","questionId":"7"},{"questionName":"Psychiatric Hospitalizations (include where, when, & for what reason):","answer":"","questionId":"8"},{"questionName":"Have you ever had ECT?                          ","answer":"","questionId":"9"},{"questionName":"  Have you had psychotherapy?","answer":"","questionId":"10"},{"questionName":"Drug allergies?","answer":"","questionId":"11"},{"questionName":"Please mention any medications that you are now taking. Include non-prescription medications & vitamins or supplements:","answer":"","questionId":"12"},{"questionName":"PAST MEDICAL HISTORY DETAILS","answer":"","questionId":"13"},{"questionName":"EXTENDED FAMILY PSYCHIATRIC PROBLEMS PAST & PRESENT:","answer":"","questionId":"14"}]
)
*/
/*
 Diagnostic Labs Profile
 welcome(Repeat)
 Login(Repeat)
 Register Option(Repeat)
 Register(Repeat)
 Admin Approval(Repeat)
 DashBoard (done)
 Navigation(Repeat)
 Patient List(Repeat)
 Patient Details(Repeat)
 Patient Medical History(done)
 order history (Repeat)
 Order Details(Repeat)
 Supplier Details(Repeat)
 Supplier(Repeat)
 Supplier Request(Repeat)
 Medicine Details(Repeat)
 information(done)
 Requested Acceted(done)
 Patient(done)
 Add New Patient(done)
 medical History(done)
 change Password(repeat)
 Help(repeat)
 Forgot Password(repeat)
 */

/*
 Pharmacy Profile
 Welcome(repeat)
 Login(repeat)
 Register Option Screen(repeat)
 Register(done)
 Admin Approval Screen(repeat)
 Dashboard Screen(repeat)
 Navigation Screen(repeat)
 Patient List Screen(repeat)
 Patient Details Screen(repeat)
 Patient Medical History Details Screen(repeat)
 Patient Prescription : Request(done)
 Order History(repeat)
 Order Details Screen(done)
 Supplier Screen(repeat)
 Supplier Details Screen(done)
 Supplier Request Screen(repeat)
 Medicine Details Screen(repeat)
 Information Screen(repeat)
 Requested Acceted Screen(repeat)
 Change Password Screen(repeat)
 Patient Screen(repeat)
 Add New Patient Screen(repeat)
 Add Medical History Screen(repeat)
 Help Screen(repeat)
 Forgot Password Screen(repeat)
 */

/*
 Doctor Profile
 Welcome - repeat
 login-repeat
 regester option- repeat
 register- done
 approval- repeat
 Dashboard- done
 Navigation-repeat
 Appointment-done
 Appointments List - repeat
 Appointments Details- done
 Patient Medical History Details Screen- repeat
 Order History Screen- repeat
 Order Details Screen- repeat
 Supplier Screen- repeat
 Supplier Details Screen- repeat
 Supplier Request Screen- repeat
 Medicine Details Screen- repeat
 Information- repeat
 Requested Acceted- repeat
 Patient Screen- repeat
 Add New Patient Screen- repeat
 Add Medical History Screen- repeat
 Change Password Screen- repeat
 Help Screen- repeat
 Forgot Password Screen- repeat
 */

/*
 Hospital/Clinic Profile
 Welcome Screen-repeat
 Login Screen-repeat
 Register Option-repeat
 Register Screen-repeat
 Admin Approval Screen-repeat
 Dashboard Screen-done
 Appointment list--  done
 Appointments Details - repeat
 Patient Medical History Details Request-done
 Patient Medical History Details Screen-done
 Prescription Request- done
 Doctors- done
 Add New Doctor Screen-done
 Pharmacy Screen-done
 Add new pharmacy-done
 Labs-repeat
 add new lab- repeat
 Patient- repeat
 add new pateient - repeat
 Add Medical History -repeat
 Order History- repeat
 Order Details - repeat
 Supplier- repeat
 Supplier Details- repeat
 Supplier Request- repeat
 Medicine Details- repeat
 Information- repeat
 Requested Acceted -repeat
 Change password - repeat
 Help- repeat
 Forgot Password- repeat
 */

/*
 Customer/Patient Profile
 Login-repeat
 Admin Approval- repeat
 Dashboard- done
 Appointment- done
 Book an Appointment : Near Hospital---done
 Book an Appointment : Hospital Details Screen--done
 Book an Appointment : Select Doctor Screen-----done
 Book an Appointment : Select Date & Time Screen----done
 Appointment Details Screen-done
 e Health Medical Card Screen- pending
 Medical History Screen-repeat
 Change Password Screen- repeat
 Help Screen-screen
 Forgot Password Screen-done
 
 */

import UIKit
import Firebase
import AudioToolbox
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate , MessagingDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
        self.fetchDeviceToken()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    // MARK:- FIREBASE NOTIFICATION -
    @objc func fetchDeviceToken() {
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                
                let defaults = UserDefaults.standard
                defaults.set("\(token)", forKey: "key_my_device_token")
                
                
            }
        }
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error = ",error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // MARK:- WHEN APP IS OPEN -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("User Info = ",notification.request.content.userInfo)
        
        /*
         WHEN PATIENT ACCEPT PERMISSION FOR PHARMACY MEDICAL HISTORY REQUEST
         
         User Info dishu =  [AnyHashable("PatientName"): qwe try you, AnyHashable("google.c.fid"): dDOtbeM2g0n4nl_5aXAaln, AnyHashable("HospitalName"): Medicare  , AnyHashable("gcm.message_id"): 1634816326404274, AnyHashable("google.c.a.e"): 1, AnyHashable("google.c.sender.id"): 457781230976, AnyHashable("message"): Request Permission Accepted., AnyHashable("type"): Accept, AnyHashable("aps"): {
             alert = "Request Permission Accepted.";
         }]

         
         */
        
        print("User Info dishu = ",notification.request.content.userInfo)
        
        let notification_item = notification.request.content.userInfo
        // print(notification_item as Any)
        
        
        // PANIC NOTIFICATION
        if (notification_item["type"] as! String) == "Panic" {
            
            completionHandler([/*.banner,*/.badge, .sound])
             self.notification_panic_show(dictOfNotification: notification_item as NSDictionary)
            
        } else if (notification_item["type"] as! String) == "Lab Request" { // request permission from lab to patient
            
            completionHandler([/*.banner,*/.badge, .sound])
             self.notification_medical_permission_show(dictOfNotification: notification_item as NSDictionary)
            
        } else if (notification_item["type"] as! String) == "Pharmacy Request for Medical History" {
            
            completionHandler([/*.banner,*/.badge, .sound])
             self.notification_medical_request_pharmacy_show(dictOfNotification: notification_item as NSDictionary)
            
        } else if (notification_item["type"] as! String) == "Pharmacy Request for Prescription" {
            
            completionHandler([/*.banner,*/.badge, .sound])
             self.notification_prescription_request_pharmacy_show(dictOfNotification: notification_item as NSDictionary)
            
        } else {
            
        }
        
    }
    
    // MARK:- WHEN APP IS IN BACKGROUND - ( after click popup ) -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        
        let background_notification_item = response.notification.request.content.userInfo
        
        self.notification_medical_permission_show(dictOfNotification: background_notification_item as NSDictionary)
        
    }
    
    // MARK: - NOTIFICATION ( PANIC ) -
    @objc func notification_panic_show(dictOfNotification:NSDictionary) {
        print(dictOfNotification as Any)
        
        /*
         AudioServicesPlaySystemSound(1519) // Actuate "Peek" feedback (weak boom)
         AudioServicesPlaySystemSound(1520) // Actuate "Pop" feedback (strong boom)
         AudioServicesPlaySystemSound(1521) // Actuate "Nope" feedback (series of three weak booms)
         */
        
        AudioServicesPlaySystemSound(1521)
        
        let panic_notification_title    = (dictOfNotification["title"] as! String)
        let panic_notification_message  = (dictOfNotification["message"] as! String)
        
        let alert = NewYorkAlertController(title: panic_notification_title, message: panic_notification_message, style: .alert)
        
        // alert.addImage(UIImage.gif(name: "successRecharge"))
        alert.addImage(UIImage(named: "notification_alert"))
        
        let cancel1 = NewYorkButton(title: "Patient Profile", style: .default) {
            _ in
            print("i clicked")
        }
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        
        alert.addButtons([cancel1,cancel])
        UIApplication.topMostViewController2?.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - NOTIFICATION ( REQUEST PERMISSION : FROM LAB TO PATIENT ) -
    @objc func notification_medical_permission_show(dictOfNotification:NSDictionary) {
        print(dictOfNotification as Any)
        
        AudioServicesPlaySystemSound(1521)
        
        let medical_request_notification_title    = (dictOfNotification["title"] as! String)
        let medical_request_notification_message  = (dictOfNotification["message"] as! String)
        
        let full_name  = (dictOfNotification["LoginUserName"] as! String)
        
        let alert = NewYorkAlertController(title: medical_request_notification_title, message: medical_request_notification_message+"\n\nLab Name: "+String(full_name), style: .alert)
        
        alert.addImage(UIImage(named: "medical_permission"))
        
        let cancel1 = NewYorkButton(title: "Yes, Approve", style: .default) {
            _ in
            print("i clicked accept")
            self.change_Status_medical_history_request_forr_labs_wb(dictGetPatientDetails: dictOfNotification, strStatus: "Accept")
        }
        
        let cancel = NewYorkButton(title: "decline", style: .cancel) {
            _ in
            print("i clicked decline")
            
            self.change_Status_medical_history_request_forr_labs_wb(dictGetPatientDetails: dictOfNotification, strStatus: "Decline")
        }
        
        cancel1.setDynamicColor(.purple)
        cancel.setDynamicColor(.red)
        
        alert.addButtons([cancel1,cancel])
        UIApplication.topMostViewController2?.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - NOTIFICATION ( REQUEST PERMISSION : FROM PHARMACY TO PATIENT ==> MEDICAL REQUEST ) -
    @objc func notification_medical_request_pharmacy_show(dictOfNotification:NSDictionary) {
        print(dictOfNotification as Any)
        
        AudioServicesPlaySystemSound(1521)
        
        let medical_request_notification_title    = (dictOfNotification["title"] as! String)
        let medical_request_notification_message  = (dictOfNotification["message"] as! String)
        
        let full_name  = (dictOfNotification["LoginUserName"] as! String)
        
        let alert = NewYorkAlertController(title: medical_request_notification_title, message:"'"+String(full_name)+"' "+medical_request_notification_message , style: .alert)
        
        alert.addImage(UIImage(named: "medical_permission"))
        
        let cancel1 = NewYorkButton(title: "Yes, Approve", style: .default) {
            _ in
            print("i clicked accept")
            self.change_Status_medical_history_request_forr_labs_wb(dictGetPatientDetails: dictOfNotification, strStatus: "Accept")
        }
        
        let cancel = NewYorkButton(title: "decline", style: .cancel) {
            _ in
            print("i clicked decline")
            
            self.change_Status_medical_history_request_forr_labs_wb(dictGetPatientDetails: dictOfNotification, strStatus: "Decline")
        }
        
        cancel1.setDynamicColor(.purple)
        cancel.setDynamicColor(.red)
        
        alert.addButtons([cancel1,cancel])
        UIApplication.topMostViewController2?.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - NOTIFICATION ( REQUEST PERMISSION : FROM PHARMACY TO PATIENT ==> PRESCRIPTION ) -
    @objc func notification_prescription_request_pharmacy_show(dictOfNotification:NSDictionary) {
        print(dictOfNotification as Any)
        
        AudioServicesPlaySystemSound(1521)
        
        let medical_request_notification_title    = (dictOfNotification["title"] as! String)
        let medical_request_notification_message  = (dictOfNotification["message"] as! String)
        
        let full_name  = (dictOfNotification["LoginUserName"] as! String)
        
        let alert = NewYorkAlertController(title: medical_request_notification_title, message:"'"+String(full_name)+"' "+medical_request_notification_message , style: .alert)
        
        alert.addImage(UIImage(named: "medical_permission"))
        
        let cancel1 = NewYorkButton(title: "Yes, Approve", style: .default) {
            _ in
            print("i clicked accept")
            self.change_Status_prescription_request_wb(dictGetPatientDetails: dictOfNotification, strStatus: "Accept")
        }
        
        let cancel = NewYorkButton(title: "decline", style: .cancel) {
            _ in
            print("i clicked decline")
            
            self.change_Status_prescription_request_wb(dictGetPatientDetails: dictOfNotification, strStatus: "Decline")
        }
        
        cancel1.setDynamicColor(.purple)
        cancel.setDynamicColor(.red)
        
        alert.addButtons([cancel1,cancel])
        UIApplication.topMostViewController2?.present(alert, animated: true, completion: nil)
        
    }
    
    
    // WEBSERVICES
    @objc func change_Status_medical_history_request_forr_labs_wb(dictGetPatientDetails:NSDictionary,strStatus:String) {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        /*let x : Int = (dictGetPatientDetails["userId"] as! Int)
        let myString = String(x)*/
        
        var hospitalIdInString:String!
        
        // hospital id
        if (dictGetPatientDetails["hospitalId"] is String) {
            
            print("Yes, it's a String")
            
            hospitalIdInString = (dictGetPatientDetails["hospitalId"] as! String)
            
        } else if dictGetPatientDetails["hospitalId"] is Int {
            
            print("It is Integer")
            
            let x2 : Int = (dictGetPatientDetails["hospitalId"] as! Int)
            let myString2 = String(x2)
            hospitalIdInString = String(myString2)
            
        }
        
        /*let x3 : Int = (dictGetPatientDetails["medicalHistoryId"] as! Int)
        let myString2 = String(x3)*/
        
        let params = status_change_request_medical_history_from_labs(action: "medicalhistoryreply",
                                                                     userId: dictGetPatientDetails["userId"] as! String,
                                                                     hospitalId: String(hospitalIdInString),
                                                                     medicalHistoryId: dictGetPatientDetails["medicalHistoryId"] as! String,
                                                                     request_reply: String(strStatus))
        
        print(params as Any)
        
        AF.request(APPLICATION_BASE_URL,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = JSON["status"]as Any as? String
                
                // var strSuccess2 : String!
                // strSuccess2 = JSON["msg"]as Any as? String
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    // var dict: Dictionary<AnyHashable, Any>
                    // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    // print(dict as Any)
                    
                     // var strSuccess3 : String!
                     // strSuccess3 = dict["permission"]as Any as? String
                    
                    
                    
                } else {
                    
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    /*var strSuccess1 : String!
                    strSuccess1 = JSON["status"]as Any as? String
                    
                    var strSuccess : String!
                    strSuccess = JSON["msg"]as Any as? String
                    
                    let alert = NewYorkAlertController(title: strSuccess1, message: String(strSuccess), style: .alert)
                    
                    alert.addImage(UIImage(named: "medical_history"))
                    
                    let cancel = NewYorkButton(title: "Ok", style: .cancel)
                    alert.addButtons([cancel])
                    
                    self.present(alert, animated: true)*/
                    
                }
                
            case let .failure(error):
                print(error)
                ERProgressHud.sharedInstance.hide()
                
                // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
            }
        }
        
        // }
    }
    
    // WEBSERVICES
    @objc func change_Status_prescription_request_wb(dictGetPatientDetails:NSDictionary,strStatus:String) {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        /*let x : Int = (dictGetPatientDetails["userId"] as! Int)
         let myString = String(x)*/
        
        var hospitalIdInString:String!
        
        // hospital id
        if (dictGetPatientDetails["hospitalId"] is String) {
            
            print("Yes, it's a String")
            
            hospitalIdInString = (dictGetPatientDetails["hospitalId"] as! String)
            
        } else if dictGetPatientDetails["hospitalId"] is Int {
            
            print("It is Integer")
            
            let x2 : Int = (dictGetPatientDetails["hospitalId"] as! Int)
            let myString2 = String(x2)
            hospitalIdInString = String(myString2)
            
        }
        
        /*let x3 : Int = (dictGetPatientDetails["medicalHistoryId"] as! Int)
         let myString2 = String(x3)*/
        
        let params = status_change_request_prescription_from_pharmacy(action: "prescriptionreply",
                                                                      userId: dictGetPatientDetails["userId"] as! String,
                                                                      hospitalId: String(hospitalIdInString),
                                                                      prescriptionId: dictGetPatientDetails["prescriptionId"] as! String,
                                                                      request_reply: String(strStatus))
        
        print(params as Any)
        
        AF.request(APPLICATION_BASE_URL,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = JSON["status"]as Any as? String
                
                // var strSuccess2 : String!
                // strSuccess2 = JSON["msg"]as Any as? String
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    // var dict: Dictionary<AnyHashable, Any>
                    // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    // print(dict as Any)
                    
                    // var strSuccess3 : String!
                    // strSuccess3 = dict["permission"]as Any as? String
                    
                } else {
                    
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    /*var strSuccess1 : String!
                     strSuccess1 = JSON["status"]as Any as? String
                     
                     var strSuccess : String!
                     strSuccess = JSON["msg"]as Any as? String
                     
                     let alert = NewYorkAlertController(title: strSuccess1, message: String(strSuccess), style: .alert)
                     
                     alert.addImage(UIImage(named: "medical_history"))
                     
                     let cancel = NewYorkButton(title: "Ok", style: .cancel)
                     alert.addButtons([cancel])
                     
                     self.present(alert, animated: true)*/
                    
                }
                
            case let .failure(error):
                print(error)
                ERProgressHud.sharedInstance.hide()
                
                // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
            }
        }
        
        // }
    }
}

extension UIApplication {
    
    /// The top most view controller
     static var topMostViewController2: UIViewController? {
         return UIApplication.shared.keyWindow?.rootViewController?.visibleViewController2
     }
    
}

extension UIViewController {
    
    /// The visible view controller from a given view controller
    var visibleViewController2: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController2
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController2
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController2
        } else {
            return self
        }
    }
    
}
