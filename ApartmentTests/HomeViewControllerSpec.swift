import Quick
import Nimble
import UIKit
import Ra
import Alamofire

class HomeViewControllerSpec: QuickSpec {
    override func spec() {
        var subject: HomeViewController! = nil
        var injector: Ra.Injector! = nil
        var lightsService: FakeLightsService! = nil
        var navigationController: UINavigationController! = nil
        var appModule: SpecApplicationModule! = nil

        beforeEach {
            injector = Ra.Injector()
            appModule = SpecApplicationModule()
            appModule.configureInjector(injector)
            let manager = injector.create(kNetworkManager) as! Alamofire.Manager
            lightsService = FakeLightsService(backendURL: injector.create(kBackendService) as! String, manager: manager)
            injector.bind(kLightsService, to: lightsService)
            subject = injector.create(HomeViewController.self) as! HomeViewController
            navigationController = UINavigationController(rootViewController: subject)
        }

        afterEach {
            appModule.afterTests()
        }

        describe("on view load") {
            beforeEach {
                expect(subject.view).toNot(beNil())
            }

            describe("on view will appear") {
                beforeEach {
                    subject.viewWillAppear(false)
                }

                it("should hide the navigation bar") {
                    expect(subject.navigationController?.navigationBarHidden).to(beTruthy())
                }
            }

            describe("collectionView") {
                it("should have one item") {
                    expect(subject.collectionView.numberOfItemsInSection(0)).to(equal(1))
                }

                describe("the first cell") {
                    var cell : LightsCard! = nil
                    let bulb = Bulb(id: 3, name: "Hue Lamp 2", on: false, brightness: 194, hue: 15051,
                            saturation: 137, colorTemperature: 359, transitionTime: 10, colorMode: .colorTemperature,
                                effect: .none, reachable: true, alert: "none")
                    var bulbs : [Bulb] = []
                    beforeEach {
                        bulbs = [bulb]
                        subject.bulbs = [bulb]
                        cell = subject.collectionView(subject.collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! LightsCard
                    }

                    it("should be passed the bulbs") {
                        expect(cell.bulbs).to(equal(bulbs))
                        expect(cell.delegate).toNot(beNil())
                    }

                    describe("LightsCardDelegate -didTapBulb:") {
                        beforeEach {
                            subject.didTapBulb(bulb)
                        }

                        it("should navigate to a bulb editor for that bulb") {
                            expect(subject.navigationController?.visibleViewController).toEventually(beAnInstanceOf(BulbViewController.self))
                            if let bulbEditor = navigationController.topViewController as? BulbViewController {
                                expect(bulbEditor.bulb).to(equal(bulb))
                            }
                        }
                    }
                }
            }

            describe("Getting all bulbs") {
                it("should ask for all bulbs") {
                    expect(lightsService.didReceiveAllBulbs).to(beTruthy())
                }

                describe("on all bulbs return") {
                    var bulbs : [Bulb] = [Bulb(id: 3, name: "Hue Lamp 2", on: false, brightness: 194, hue: 15051,
                        saturation: 137, colorTemperature: 359, transitionTime: 10, colorMode: .colorTemperature,
                        effect: .none, reachable: true, alert: "none")]
                    beforeEach {

                        lightsService.allBulbsHandler(bulbs, nil)
                    }

                    it("should set the bulbs value") {
                        expect(subject.bulbs).to(equal(bulbs))
                    }
                }

                describe("on all bulbs error") {
                    let errorString = "Unknown error"
                    var window : UIWindow? = nil
                    beforeEach {
                        window = UIWindow()
                        window?.makeKeyAndVisible()
                        window?.rootViewController = subject
                        let error = NSError(domain: "Apartment", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString])
                        lightsService.allBulbsHandler(nil, error)
                    }

                    it("show an error") {
                        let alert = subject.presentedViewController as? UIAlertController
                        expect(alert).toNot(beNil())
                        if let alert = alert {
                            expect(alert.title).to(equal("Error getting lights"))
                            expect(alert.message).to(equal(errorString))
                            expect(alert.actions.count).to(equal(1))
                            let dismiss = alert.actions[0] as! UIAlertAction
                            expect(dismiss.title).to(equal("Ok"))
                        }
                    }
                }
            }
        }
    }
}