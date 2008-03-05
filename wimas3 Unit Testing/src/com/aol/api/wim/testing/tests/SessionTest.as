package com.aol.api.wim.testing.tests
{
    import com.aol.api.MockServer;
    import com.aol.api.MockURLLoader;
    import com.aol.api.wim.MockSession;
    import com.aol.api.wim.data.types.SessionState;
    import com.aol.api.wim.events.BuddyListEvent;
    import com.aol.api.wim.events.SessionEvent;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    /**
     * This class runs some offline tests of <code>com.aol.api.wim.Session</code>.
     * 
     * It uses the "mock" server available in the wimas3_mock_server project. 
     * @author Rizwan
     * 
     */
    public class SessionTest extends TestCase
    {
        private static var username:String = "myScreenName";
        private static var password:String = "myPassword";
        private static var devId:String = "devId";
        private static var clientName:String = "clientName";
        private static var clientVersion:String = "clientVersion";
        private static var session:MockSession;
        private static var lastSessionState:String = null;
        
        private var asyncEvtHandler:Function;
        
        public function SessionTest(displayObj:DisplayObjectContainer, methodName:String=null) {
            super(methodName);
            if(!SessionTest.session) {
                MockServer.getInstance().aimsidPrefix = "[test_aimsid_prefix]";
                MockURLLoader.emptyFetchEventsNetworkDelayMs = 100;
                
                session = new MockSession(displayObj, devId, clientName, clientVersion);
                session.autoFetchEvents = false;
            }
        }
        
        public static function suite(displayObj:DisplayObjectContainer):TestSuite {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new SessionTest(displayObj, "testSignOn"));
            ts.addTest(new SessionTest(displayObj, "testEmptyFetchEvents"));
            ts.addTest(new SessionTest(displayObj, "testBuddyListEvent"));
            ts.addTest(new SessionTest(displayObj, "testSignOff"));
            return ts;
        }
        
        ////////////////////////////////////////////////////////////////////////
        public function testSignOn():void {
            trace("\n>>>>>>>>>>>>>>>>>>> RUNNING TEST: "+methodName+" <<<<<<<<<<<<<<<<<<<\n");
            asyncEvtHandler = addAsync(validateSignOnTest, 1000);
            session.addEventListener(SessionEvent.STATE_CHANGED, onStateChange);
            session.signOn(username, password);
        }
        
        public function testSignOff():void {
            trace("\n>>>>>>>>>>>>>>>>>>> RUNNING TEST: "+methodName+" <<<<<<<<<<<<<<<<<<<\n");
            asyncEvtHandler = addAsync(validateSignOffTest, 1000);
            session.addEventListener(SessionEvent.STATE_CHANGED, onStateChange);
            session.signOff();
        }
        
        protected function onStateChange(evt:SessionEvent):void {
            // Remove our registration with STATE_CHANGED
            evt.session.removeEventListener(SessionEvent.STATE_CHANGED, asyncEvtHandler);
            
            if(methodName == "testSignOn") {
                
                if(lastSessionState == SessionState.STARTING) {
                    asyncEvtHandler.call(this, null);
                }
                
            } else if(methodName == "testSignOff") {
                
                if(lastSessionState == SessionState.ONLINE) {
                    asyncEvtHandler.call(this, null);
                }
            }
            lastSessionState = session.sessionState;
        }
        
        public function testEmptyFetchEvents():void {
            trace("\n>>>>>>>>>>>>>>>>>>> RUNNING TEST: "+methodName+" <<<<<<<<<<<<<<<<<<<\n");
            asyncEvtHandler = addAsync(validateEmptyFetchEventsTest, 500);
            session.addEventListener(SessionEvent.EVENTS_FETCHED, onEventsFetched);
            session.runFetchEventsNow();
        }
        
        public function testBuddyListEvent():void {
            trace("\n>>>>>>>>>>>>>>>>>>> RUNNING TEST: "+methodName+" <<<<<<<<<<<<<<<<<<<\n");
            MockServer.getInstance().eventsToReturn.push("buddylist");
            
            asyncEvtHandler = addAsync(validateBuddyListTest, 1000);
            session.addEventListener(BuddyListEvent.LIST_RECEIVED, onBLReceived);
            
            session.runFetchEventsNow();
        }
        
        protected function onEventsFetched(evt:SessionEvent):void {
            // TODO: Need a better test for an empty fetch events request, without exposing too much fetchEvents response
            asyncEvtHandler.call(this, null);
            
            //session.removeEventListener(SessionEvent.EVENTS_FETCHED, asyncEvtHandler);
        }
        
        protected function onBLReceived(evt:BuddyListEvent):void {
            asyncEvtHandler.call(this, evt);
        }
        
        // Validates the various tests
        
        protected function validateSignOnTest(evt:Event):void {
            trace("Validating sign on");
            assertTrue(session.sessionState == SessionState.ONLINE);
            assertTrue(session.aimsid.indexOf(":"+username) >= 0);
            
            session.removeEventListener(SessionEvent.STATE_CHANGED, onStateChange);
        }
        
        protected function validateSignOffTest(evt:Event):void {
            trace("Validating sign off");
            assertTrue(session.sessionState == SessionState.OFFLINE);
            
            session.removeEventListener(SessionEvent.STATE_CHANGED, onStateChange);
        }
        
        protected function validateEmptyFetchEventsTest(evt:Event):void {
            trace("Validating empty fetch events");
            assertTrue(500 == session.timeToNextFetchMs);
            
            session.removeEventListener(SessionEvent.EVENTS_FETCHED, onEventsFetched);
        }
        
        protected function validateBuddyListTest(evt:BuddyListEvent):void {
            trace("Validating buddy list event");
            assertTrue(evt.buddyList != null);
            assertTrue(evt.buddyList.owner.aimId == username);
            
            session.removeEventListener(BuddyListEvent.LIST_RECEIVED, onBLReceived);
        }
    }
}