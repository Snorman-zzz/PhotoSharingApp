//
//  AppDelegate.swift
//  c
//
//  Created by Norman Yuan on 11/13/21.
//

import Firebase
import UIKit
import Appirater

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //使用idfa
        let adString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let config = JVAuthConfig()
        config.appKey = "e2725310a355d1408ec1e10d"
        config.channel = "testChannel"
        config.advertisingId = adString
        config.isProduction = false;
        config.timeout = 5000;
        config.authBlock = { (result) -> Void in
            if let result = result {
                if let code = result["code"], let content = result["content"] {
                     print("初始化结果 result: code = \(code), content = \(content)")
                }
            }
        }
        JVERIFICATIONService.setup(with: config)
        JVERIFICATIONService.setDebug(true)
        
        Appirater.appLaunched(true)
        Appirater.setAppId("")
        Appirater.setDebug(false)
        Appirater.setDaysUntilPrompt(3)

        FirebaseApp.configure()
        
        // Add dummy notification for current user
//        let id = NotificationsManager.newIdentifier()
//        let model = ALNotification(
//            identifier: id,
//            notificationType: 3,
//            profilePictureUrl: "https://iosacademy.io/assets/images/brand/icon.jpg",
//            username: "joebiden",
//            dateString: String.date(from: Date()) ?? "Now",
//            isFollowing: false,
//            postId: nil,
//            postUrl: nil
//        )
//        NotificationsManager.shared.create(notification: model, for: "normanyuan4")
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Appirater.appEnteredForeground(true)
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


}

