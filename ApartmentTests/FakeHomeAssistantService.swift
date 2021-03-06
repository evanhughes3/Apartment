import Foundation
@testable import ApartKit

class FakeHomeAssistantService: HomeAssistantService {
    init() {
        super.init(urlSession: NSURLSession.sharedSession(), mainQueue: NSOperationQueue.mainQueue())
    }

    override init(urlSession: NSURLSession, mainQueue: NSOperationQueue) {
        super.init(urlSession: urlSession, mainQueue: mainQueue)
    }

    var apiAvailableCallback: (Bool -> Void)?
    override func apiAvailable(callback: Bool -> Void) {
        apiAvailableCallback = callback
    }

    var configurationCallback: ((HomeConfiguration?, NSError?) -> Void)?
    override func configuration(callback: (HomeConfiguration?, NSError?) -> Void) {
        configurationCallback = callback
    }

    var historyDay: NSDate?
    var historyState: State?
    var historyCallback: (([State], NSError?) -> Void)?
    override func history(day: NSDate, state: State?, callback: ([State], NSError?) -> Void) {
        historyDay = day
        historyState = state
        historyCallback = callback
    }

    var eventsCallback: (([Event], NSError?) -> (Void))? = nil
    override func events(callback: ([Event], NSError?) -> (Void)) {
        self.eventsCallback = callback
    }

    var firedEvent: String? = nil
    var firedEventData: [String: AnyObject]? = nil
    var firedEventCallback: ((String?, NSError?) -> (Void))? = nil
    override func fireEvent(event: String, data: [String : AnyObject]?, callback: (String?, NSError?) -> (Void)) {
        self.firedEvent = event
        self.firedEventData = data
        self.firedEventCallback = callback
    }

    var servicesCallback: (([Service], NSError?) -> (Void))? = nil
    override func services(callback: ([Service], NSError?) -> (Void)) {
        self.servicesCallback = callback
    }

    var calledService: String? = nil
    var calledServiceDomain: String? = nil
    var calledServiceData: [String : AnyObject]? = nil
    var calledServiceCallback: (([State], NSError?) -> (Void))? = nil
    override func callService(service: String, method: String, data: [String : AnyObject]?, callback: ([State], NSError?) -> (Void)) {
        self.calledService = service
        self.calledServiceDomain = method
        self.calledServiceData = data
        self.calledServiceCallback = callback
    }

    var statusCallback: (([State], NSError?) -> (Void))? = nil
    override func status(callback: ([State], NSError?) -> (Void)) {
        self.statusCallback = callback
    }

    var statusEntity: String? = nil
    var statusEntityCallback: ((State?, NSError?) -> (Void))? = nil
    override func status(entityId: String, callback: (State?, NSError?) -> (Void)) {
        self.statusEntity = entityId
        self.statusEntityCallback = callback
    }

    var updatedEntity: String? = nil
    var updatedEntityStatus: String? = nil
    var updatedEntityCallback: ((State?, NSError?) -> (Void))? = nil
    override func update(entityId: String, newStatus: String, callback: (State?, NSError?) -> (Void)) {
        self.updatedEntity = entityId
        self.updatedEntityStatus = newStatus
        self.updatedEntityCallback = callback
    }
}