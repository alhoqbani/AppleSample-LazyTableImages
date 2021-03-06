//
//  AppDelegate.swift
//  AppleSample-LazyTableImages
//
//  Created by Hamoud Alhoqbani on 3/13/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Fetch the feed
        let topPaidAppsFeed = URL(string: "http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=100/json")!

        let sessionTask = URLSession.shared.dataTask(with: topPaidAppsFeed) { (data: Data?, response: URLResponse?, error: Error?) -> Void in

            guard error == nil else {
                print(error!)
                abort()
            }

            guard let data = data else {
                print("data is nil")
                return
            }


            do {

                let feed = try JSONDecoder().decode(AppsFeed.self, from: data)
                let records = feed.records

                let appRecords: [AppRecord] = records.map {
                    return AppRecord(appName: $0.appName, artist: $0.artist, imageURLString: $0.imageURLString)
                }

                DispatchQueue.main.async {
                    let rootViewController = (self.window?.rootViewController as? UINavigationController)?.topViewController as? RootViewController
                    rootViewController?.entries = appRecords
                    rootViewController?.tableView.reloadData()
                }

            } catch {
                print(error)
            }
        }


        sessionTask.resume()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

