//
//  AppDelegate.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/2/27.
//

import UIKit

let appColor: UIColor = .systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var loginViewController = LoginViewController()
    private var onboardingContainerViewController = OnboardingContainerViewController()
    private var dummyViewController = DummyViewController()
    private var mainViewController = MainViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground

        loginViewController.delegate = self
        dummyViewController.logoutDelegate = self
        onboardingContainerViewController.delegate = self
        
        window?.rootViewController = mainViewController
        window?.rootViewController = AccountSummaryViewController()
//        mainViewController.selectedIndex = 1

        return true
    }

}

extension AppDelegate: LoginViewControllerDelegate{
    func didLogin() {
        if LocalState.hasOnboarded {
            setRootViewController(dummyViewController)
        } else {
            setRootViewController(onboardingContainerViewController)
        }
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate{
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true

        setRootViewController(dummyViewController)
    }
}

extension AppDelegate: LogoutDelegate{
    func didLogout() {
        setRootViewController(loginViewController)
    }
    
}

extension AppDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }

        window.rootViewController = vc
        window.makeKeyAndVisible()
        // 用動畫讓顯示新的畫面看起來平順一點
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}