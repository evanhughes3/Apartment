import Foundation
import Ra
import UIKit
import ApartKit

let kBackendService = "backendService"
public let kLightsService = "kLightsService"
public let kLockService = "kLockService"
public let kAuthenticationToken = "kAuthenticationToken"
let authenticationTokenUserDefault = "authenticationToken"

public class ApplicationModule {
    public func configureInjector(injector: Ra.Injector) {
        injector.bind(kBackendService) {
            NSUserDefaults.standardUserDefaults().stringForKey(kBackendService) ?? "http://localhost:3000/"
        }

        injector.bind(kAuthenticationToken) {
            NSUserDefaults.standardUserDefaults().stringForKey(authenticationTokenUserDefault) ?? ""
        }

        let lightsService = LightsService(backendURL: "", urlSession: NSURLSession.sharedSession(), authenticationToken: "", mainQueue: NSOperationQueue.mainQueue())

        injector.bind(kLightsService) {
            lightsService.backendURL = injector.create(kBackendService) as! String
            lightsService.authenticationToken = injector.create(kAuthenticationToken) as! String
            return lightsService
        }

        let lockService = LockService(backendURL: "", urlSession: NSURLSession.sharedSession(), authenticationToken: "", mainQueue: NSOperationQueue.mainQueue())

        injector.bind(kLockService) {
            lockService.backendURL = injector.create(kBackendService) as! String
            lockService.authenticationToken = injector.create(kAuthenticationToken) as! String
            return lockService
        }

        injector.bind(UICollectionView.self) {
            return UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        }
    }

    public init() {}
}