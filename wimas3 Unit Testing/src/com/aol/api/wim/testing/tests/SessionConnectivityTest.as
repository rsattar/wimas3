package com.aol.api.wim.testing.tests
{
    import com.aol.api.MockServer;
    import com.aol.api.MockURLLoader;
    import com.aol.api.wim.MockSession;
    import com.aol.api.wim.data.types.SessionState;
    import com.aol.api.wim.events.SessionEvent;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    public class SessionConnectivityTest extends TestCase
    {
        private static const username:String = "myScreenName";
        private static const password:String = "myPassword";
        private static const devId:String = "devId";
        private static const clientName:String = "clientName";
        private static const clientVersion:String = "clientVersion";
        
        private var session:MockSession;
        private var isOnline:Boolean = false;
        private var lastSessionState:String  =   null;
        
        // For testing reconnects
        private var numReconnects:int   =   0;
        private var maxRetries:int      =   2;
        
        // For testing invalid aimsid and invalid auth token
        private var receivedInvalidAimsid:Boolean = false;
        
        private var asyncEvtHandler:Function;
        
        public function SessionConnectivityTest(displayObj:DisplayObjectContainer, methodName:String=null) {
            super(methodName);
            MockServer.getInstance().aimsidPrefix = "[test_aimsid_prefix]";
            MockURLLoader.emptyFetchEventsNetworkDelayMs = 100;
            
            session = new MockSession(displayObj, devId, clientName, clientVersion);
            //session.autoFetchEvents = false;
            
            session.maxReconnectAttempts = maxRetries;
            // Reconnect every second
            session.reconnectSchedule = [1];
        }
        
        public static function suite(displayObj:DisplayObjectContainer):TestSuite {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new SessionConnectivityTest(displayObj, "testReconnectWithFailure"));
            ts.addTest(new SessionConnectivityTest(displayObj, "testReconnectWithSuccess"));
            ts.addTest(new SessionConnectivityTest(displayObj, "testReconnectWithInvalidSession"));
            ts.addTest(new SessionConnectivityTest(displayObj, "testReconnectWithInvalidAuth"));
            return ts;
        }
        
        /**
         * Called when this particular Test is being torn down, so do cleanup here 
         * 
         */        
        public override function tearDown():void {
            session.removeEventListener(SessionEvent.STATE_CHANGED, onStateChange);
            session.removeEventListener(SessionEvent.EVENTS_FETCHING, onEventsFetching, true);
            session.signOff();
        }
        
        public function testReconnectWithFailure():void {
            trace("\n>>>>>>>>>>>>>>>>>>> RUNNING TEST: "+methodName+" <<<<<<<<<<<<<<<<<<<\n");
            asyncEvtHandler = addAsync(validateReconnectWithFailure, 5000);
            session.addEventListener(SessionEvent.STATE_CHANGED, onStateChange);
            session.addEventListener(SessionEvent.EVENTS_FETCHING, onEventsFetching, true);
            session.signOn(username, password);
        }
        
        public function testReconnectWithSuccess():void {
            trace("\n>>>>>>>>>>>>>>>>>>> RUNNING TEST: "+methodName+" <<<<<<<<<<<<<<<<<<<\n");
            asyncEvtHandler = addAsync(validateReconnectWithSuccess, 5000);
            session.addEventListener(SessionEvent.STATE_CHANGED, onStateChange);
            session.addEventListener(SessionEvent.EVENTS_FETCHING, onEventsFetching, true);
            session.signOn(username, password);
        }
        
        public function testReconnectWithInvalidSession():void {
            trace("\n>>>>>>>>>>>>>>>>>>> RUNNING TEST: "+methodName+" <<<<<<<<<<<<<<<<<<<\n");
            asyncEvtHandler = addAsync(validateReconnectWithInvalidSession, 5000);
            session.addEventListener(SessionEvent.EVENTS_FETCHING, onEventsFetching, true);
            session.signOn(username, password);
        }
        
        public function testReconnectWithInvalidAuth():void {
            trace("\n>>>>>>>>>>>>>>>>>>> RUNNING TEST: "+methodName+" <<<<<<<<<<<<<<<<<<<\n");
            asyncEvtHandler = addAsync(validateReconnectWithInvalidAuth, 5000);
            session.addEventListener(SessionEvent.EVENTS_FETCHING, onEventsFetching, true);
            session.signOn(username, password);
        }
        
        protected function validateReconnectWithFailure(evt:Event):void {
            assertTrue(session.sessionState == SessionState.DISCONNECTED);
        }
        
        protected function validateReconnectWithSuccess(evt:Event):void {
            assertTrue(session.sessionState == SessionState.ONLINE);
        }
        
        protected function validateReconnectWithInvalidSession(evt:Event):void {
            assertTrue(session.sessionState == SessionState.STARTING);
        }
        
        protected function validateReconnectWithInvalidAuth(evt:Event):void {
            assertTrue(session.sessionState == SessionState.AUTHENTICATING);
        }
        
        protected function onStateChange(evt:SessionEvent):void {
            // Remove our registration with STATE_CHANGED
            //evt.session.removeEventListener(SessionEvent.STATE_CHANGED, asyncEvtHandler);
            var previouslyOffline:Boolean = !isOnline;
            // Finally set our 'isOnline' bool
            isOnline = evt.session.sessionState == SessionState.ONLINE || evt.session.sessionState == SessionState.RECONNECTING;

            if (methodName == "testReconnectWithFailure") {
                // Only start test the reconnects if we were already online
                if(!previouslyOffline) {
                    trace("Reconnect attempt: "+numReconnects+" out of "+maxRetries);
                    if(numReconnects < maxRetries) {
                        assertTrue(session.sessionState == SessionState.RECONNECTING);
                    } else {
                        assertTrue(session.sessionState == SessionState.DISCONNECTED);
                        asyncEvtHandler.call(this, null);
                    }
                }
            } else if (methodName == "testReconnectWithSuccess") {
                trace("Reconnect attempt: "+numReconnects+" out of "+maxRetries);
                if(numReconnects > 0 && numReconnects < maxRetries) {
                    assertTrue(session.sessionState == SessionState.RECONNECTING);
                } else if(numReconnects == maxRetries) {
                    assertTrue(session.sessionState == SessionState.ONLINE);
                    asyncEvtHandler.call(this, null);
                }
            }
            lastSessionState = session.sessionState;
        }
        
        protected function onEventsFetching(evt:SessionEvent):void {
            switch(methodName) {
                case "testReconnectWithFailure":
                    // Always force a timeout
                    trace("Fetching Events: Forcing a timeout");
                    MockServer.getInstance().forceNextRequestTimeout = true;
                    if(evt.session.sessionState == SessionState.RECONNECTING) {
                        numReconnects++;
                    }
                    break;
                case "testReconnectWithSuccess":
                    // Only force a timeout if we are under our maximum number of retries
                    if(evt.session.sessionState == SessionState.ONLINE && numReconnects == 0) {
                        MockServer.getInstance().forceNextRequestTimeout = true;
                    } else if(evt.session.sessionState == SessionState.RECONNECTING) {
                        numReconnects++;
                        if(numReconnects < maxRetries) {
                            MockServer.getInstance().forceNextRequestTimeout = true;
                        }
                    } 
                    break;
                case "testReconnectWithInvalidAuth":
                case "testReconnectWithInvalidSession":
                    // Force a bad aimsid
                    if(evt.session.sessionState == SessionState.ONLINE) {
                        trace("Faking an invalid aimsid on fetchEvents...");
                        MockServer.getInstance().simulateInvalidAimSid = true;
                        session.addEventListener(SessionEvent.SESSION_STARTING, onStartingAfterInvalidAimsid, true);
                    } else {
                        MockServer.getInstance().simulateInvalidAimSid = false;
                    }
                    break;
                default:
            }
        }
        
        /**
         * Used during the invalid aimsid and the lost authentication tests 
         * @param evt
         * 
         */        
        protected function onStartingAfterInvalidAimsid(evt:SessionEvent):void {
            receivedInvalidAimsid = true;
            if(methodName == "testReconnectWithInvalidSession") {
                // We successfully received a starting after we set up an invalid aimsid, which means this test passed
                evt.stopPropagation();
                asyncEvtHandler.call(this, null);
            } else if(methodName == "testReconnectWithInvalidAuth") {
                // Set up the startSession to fail 
                MockServer.getInstance().simulateInvalidAuthToken = true;
                session.addEventListener(SessionEvent.SESSION_AUTHENTICATING, onAuthenticatingAfterInvalidAuthToken, true);
            }
        }
        
        protected function onAuthenticatingAfterInvalidAuthToken(evt:SessionEvent):void {
            // We successfully reached 'authenticating' again after we set up an invalid auth token
            evt.stopPropagation();
            asyncEvtHandler.call(this, null);
        }
        
    }
}