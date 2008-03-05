// ActionScript file
import com.aol.api.MockServer;
import com.aol.api.logging.*;
import com.aol.api.openauth.AuthToken;
import com.aol.api.openauth.ClientLogin;
import com.aol.api.openauth.events.AuthEvent;
import com.aol.api.wim.MockSession;
import com.aol.api.wim.Session;
import com.aol.api.wim.data.BuddyList;
import com.aol.api.wim.data.Group;
import com.aol.api.wim.data.User;
import com.aol.api.wim.data.types.AuthChallengeType;
import com.aol.api.wim.data.types.SessionState;
import com.aol.api.wim.events.AuthChallengeEvent;
import com.aol.api.wim.events.BuddyListEvent;
import com.aol.api.wim.events.SessionEvent;
import com.aol.api.wim.testing.testclient.TestClientLogger;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.controls.Alert;

[Bindable]
private var _blObjectTree:BuddyList;
[Bindable]
private var _sessionStarted:Boolean;

private var FETCH_TIMER_TICKS_TOTAL:int = 125; //should be FETCH_TIMER_TICKS_SECOND * total seconds
private var FETCH_TIMER_TICKS_SECOND:int = 5;

private var _logger:Log;
private var _session:Session;
private var _clientLogin:ClientLogin;
private var _authToken:AuthToken;
private var _sessionKey:String;
private var _fetchTimer:Timer;
private var _fetchTimerTicksRemaining:int;
        
// Constants defining server URLs /////////////////////////////////////////////////////
protected static const WIM_BASE:String      =   "http://api.oscar.aol.com/";
protected static const WIM_BASE_QA:String   =   "http://api-qh2.web.aol.com:2048/";
protected static const WIM_BASE_DEV:String  =   "http://reddev-l23.tred.aol.com:8000/";
protected var _wimBaseURL:String  =   WIM_BASE_DEV;

protected static const AUTH_BASE:String          = "https://api.screenname.aol.com/";
protected static const AUTH_BASE_QA:String       = "https://authapi.qh.aol.com:6443/";
protected static const AUTH_BASE_DEV:String      = "https://api-login.tred.aol.com/";
protected static const AUTH_BASE_PRAVEEN:String  = "https://sns.office.aol.com:8443/";
protected var _authBaseURL:String =   AUTH_BASE_DEV;

// Mock testing
[Bindable]
private var _useMockServer:Boolean = false;
private var _numFetchEventsRequested:int = 0;

protected function initPanel():void {
    
    _logger = new TestClientLogger("", this.output);
    logInfo("Test Client Started.");
}

private function updateMockServerOptions():void {
    _useMockServer = serverTarget.selectedItem.value == "mock";
}

private function onAddBuddyClick():void {
    //get the group to add the buddy to
    var item:* = buddyListTree.selectedItem;
    var group:Group;
    if(item != null) {
        if (item is User) {
            item = buddyListTree.getParentItem(item);
            if(item is Group) {
                group = item as Group;
            }
        } else if (item is Group) {
            group = item;
        }
    }
    if(group) {
        var name:String = txtAddBuddy.text;
        if(name) {
            _session.addBuddy(name, group.label);
        }
    } else {
        Alert.show("No group selected.");
    }
    trace(item);
}

private function onSendIMClick():void {
    //get the group to add the buddy to
    var item:* = buddyListTree.selectedItem;
    var user:User;
    if(item != null) {
        if (item is User) {
            user = item;
        }
    }
    if(item) {
        var message:String = txtImInput.text;
        if(name) {
            _session.sendIMToBuddy(user.aimId, message);
        }
    } else {
        Alert.show("No buddy selected.");
    }
    trace(item);
}

private function signOnToggle():void {
    
    if(_session && _session.sessionState == SessionState.ONLINE) {
        signOff();
    } else {
        signOn();
    }
}

private function signOn():void {
    
    
    if(!_session) {
        _session = createSession();
    } 
    
    var username:String = this.textUsername.text;
    var password:String = this.textPassword.text;
    var challengeAnswer:String = "";
    if(captchaContainer.visible) {
        challengeAnswer = this.captchaInput.text;
    }
    
    _session.signOn(username, password, (challengeAnswer.length > 0) ? challengeAnswer : null, toggleCaptcha.selected);
    
    // Clear auth challenge states
    captchaContainer.visible = false;
    captchaInput.text = "";
    userPassErrorCaption.visible = false;
}

private function signOff():void {
    
    if(_session) {
        _session.signOff();
    }
}

private function createSession():Session {
    logInfo(">>>> Creating '"+serverTarget.selectedItem.label+"' session");
    //logInfo(">>> Creating " + (toggleMockServer.selected ? "Mock" : "Regular") + " session");
    var selectedTarget:String = serverTarget.selectedItem.value;
    switch(selectedTarget) {
        case "mock":
        case "prod":
            _wimBaseURL = WIM_BASE;
            _authBaseURL = AUTH_BASE;
            break;
        case "dev":
            _wimBaseURL = WIM_BASE_DEV;
            _authBaseURL = AUTH_BASE_DEV;
            break;
        case "qa":
            _wimBaseURL = WIM_BASE_QA;
            _authBaseURL = AUTH_BASE_QA;
            break;
    }
    var devId:String = this.textDevId.selectedItem ? this.textDevId.selectedItem.value : this.textDevId.text;
    var session:Session = _useMockServer ? new MockSession(this.stage, devId, null, null, _logger, _wimBaseURL, _authBaseURL) : new Session(this.stage, devId, null, null, _logger, _wimBaseURL, _authBaseURL);
    if(_useMockServer) {
        //session.reconnectSchedule = [2];
        session.reconnectSchedule = new Array();
        session.reconnectSchedule[0] = [1];
        session.reconnectSchedule[2] = [2];
        session.reconnectSchedule[5] = [5];
    }
    //register listeners here
    // Add 'pre' event listeners (note we are registering with the parentDispatch
    session.addEventListener(SessionEvent.SESSION_AUTHENTICATING, onCaptureAuthenticating, true);
    session.addEventListener(SessionEvent.SESSION_AUTHENTICATING, onCaptureAuthenticatingLater); // example of catching during bubble phase
    session.addEventListener(SessionEvent.SESSION_STARTING, onCaptureStarting, true);
    session.addEventListener(SessionEvent.EVENTS_FETCHING, onCaptureEventsFetching, true);
    // Add 'post' event listeners (register directly on AIMSession)
    session.addEventListener(AuthChallengeEvent.AUTHENTICATION_CHALLENGED, onAuthChallenge);
    session.addEventListener(SessionEvent.STATE_CHANGED, onSessionStateChange);
    session.addEventListener(SessionEvent.EVENTS_FETCHED, onEventsFetched);
    session.addEventListener(BuddyListEvent.LIST_RECEIVED, onBLReceived);
    
    return session;
}

private function destroySession():void {
    logInfo(">>> Destroying session");
    //register listeners here
    // Add 'pre' event listeners (note we are registering with the parentDispatch
    _session.removeEventListener(SessionEvent.SESSION_AUTHENTICATING, onCaptureAuthenticating, true);
    _session.removeEventListener(SessionEvent.SESSION_AUTHENTICATING, onCaptureAuthenticatingLater); // example of catching during bubble phase
    _session.removeEventListener(SessionEvent.SESSION_STARTING, onCaptureStarting, true);
    _session.removeEventListener(SessionEvent.EVENTS_FETCHING, onCaptureEventsFetching, true);
    // Add 'post' event listeners (register directly on AIMSession)
    _session.removeEventListener(AuthChallengeEvent.AUTHENTICATION_CHALLENGED, onAuthChallenge);
    _session.removeEventListener(SessionEvent.STATE_CHANGED, onSessionStateChange);
    _session.removeEventListener(SessionEvent.EVENTS_FETCHED, onEventsFetched);
    _session.removeEventListener(BuddyListEvent.LIST_RECEIVED, onBLReceived);
    _session = null;
}

private function onDestroyAuthToken():void {
    if(_session && _session.authToken) {
        if(!_clientLogin) {
            _clientLogin = new ClientLogin(_session.devId, null, null, _logger, _authBaseURL);
            _clientLogin.addEventListener(AuthEvent.LOGOUT, onAuthLogout);
        }
        _clientLogin.signOff(_session.authToken, _session.sessionKey);
    }
}

private function onAuthLogout(evt:AuthEvent):void {
    _logger.debug(">>>> Authentication Token Destroyed outside of Session");
}

// Test trace for our event model
private function onCaptureAuthenticating(evt:SessionEvent):void {
    logInfo(">>>>    Client captured SESSION_AUTHENTICATING");
}

private function onCaptureAuthenticatingLater(evt:SessionEvent):void {
    logInfo(">>>>    Client received SESSION_AUTHENTICATING");
}

private function onCaptureStarting(evt:SessionEvent):void {
    logInfo(">>>>    Client captured SESSION_STARTING");  
}

private function onSessionStateChange(evt:SessionEvent):void {
    logInfo(">>>>    Client received STATE_CHANGE event! state is: "+evt.session.sessionState);
    var state:String = evt.session.sessionState;
    switch (state) {
        case SessionState.ONLINE:
            _sessionStarted = true;
            this.toggleSignOnButton.label = "Sign Off";
            break;
        case SessionState.OFFLINE:
        case SessionState.DISCONNECTED:
        case SessionState.RATE_LIMITED:
        case SessionState.UNAUTHENTICATED:
        case SessionState.AUTHENTICATION_FAILED:
            _sessionStarted = false;
            this.toggleSignOnButton.label = "Sign On";
            destroySession();
            if(_fetchTimer && _fetchTimer.running) {
                _fetchTimer.stop();
            }
            this.fetchProgress.setProgress(0, FETCH_TIMER_TICKS_TOTAL);
            break;
        default:
    }
}

private function onCaptureEventsFetching(evt:SessionEvent):void {
    
    logInfo(">>>>    Client captured EVENTS_FETCHING");
    _fetchTimerTicksRemaining = FETCH_TIMER_TICKS_TOTAL;
    
    if(!_fetchTimer) {
        _fetchTimer = new Timer(1000 / FETCH_TIMER_TICKS_SECOND);
        _fetchTimer.addEventListener(TimerEvent.TIMER, fetchTimerTick);
    }
    
    if(!_fetchTimer.running) {
        _fetchTimer.start();
    }
    
    if(_useMockServer) {
        // Specify the eventsToReturn with each fetchEvents.

        if (forceFetchTimeout.selected) {
            MockServer.getInstance().forceNextRequestTimeout = true;
            //forceFetchTimeout.selected = false;
        } else {
            // We check all of our 'simulate' check boxes. Clear them if they are selected.
            if(simulateBL.selected) {
                MockServer.getInstance().eventsToReturn.push("buddylist");
                simulateBL.selected = false;
            }
            if(simulateIM.selected) {
                MockServer.getInstance().eventsToReturn.push("im");
                simulateIM.selected = false;
            }
            if(simulateMyInfo.selected) {
                MockServer.getInstance().eventsToReturn.push("myInfo");
                simulateMyInfo.selected = false;
            }
            if(simulatePresence.selected) {
                MockServer.getInstance().eventsToReturn.push("presence");
                simulatePresence.selected = false;
            }
        }
    }
}

private function fetchTimerTick(event:TimerEvent):void {
    
    this.fetchProgress.setProgress(_fetchTimerTicksRemaining--, FETCH_TIMER_TICKS_TOTAL);
    if(_fetchTimerTicksRemaining <= 0) {
        _fetchTimer.stop();
    }
}

private function onEventsFetched(evt:SessionEvent):void {
    logInfo(">>>>    Client received EVENTS_FETCHED");
    _numFetchEventsRequested++;
}

private function onBLReceived(event:BuddyListEvent):void {
    logInfo("Buddy List Received: "+event.buddyList);
    _blObjectTree = event.buddyList;
}

private function logInfo(s:String):void {
    _logger.info("TestClient:" + s);
}

private function onAuthChallenge(evt:AuthChallengeEvent):void {
    switch(evt.challengeType) {
        case AuthChallengeType.USERPASS_CHALLENGE:
            userPassErrorCaption.visible = true;
            textPassword.text = "";
            // Get captcha image
            _logger.debug("Need to re-enter password");
            break;
        case AuthChallengeType.CAPTCHA_CHALLENGE:
            captchaContainer.visible = true;
            // Get captcha image
            _logger.debug("Loading captcha image: "+evt.challenge.captchaImageUrl);
            captchaImage.load(evt.challenge.captchaImageUrl);
            break;
        default:
            _logger.debug("Unhandled auth challenge: "+evt.challengeType);
    }
}


// Environment Configuration /////////////////////////////////////
public function setEnvParameters(params:Object):void {
    if(!params) { return; }
    //var paramsStr:String = "";
    if(params.environment) {
        var env:String = params.environment.toLowerCase();
        switch(env) {
            case "dev":
                serverTarget.selectedIndex = 0;
                break;
            case "qa":
                serverTarget.selectedIndex = 1;
                break;
            case "mock":
                serverTarget.selectedIndex = 2;
                break;
            case "prod":
                serverTarget.selectedIndex = 3;
                break;
        }
        //paramsStr += "environment="+params.environment;
    }
    /*
    if(params.wimBaseURL) {
        _wimBaseURL = params.wimBaseURL;
        paramsStr += ", wimBaseURL="+params.wimBaseURL;
    }
    if(params.authBaseURL) {
        _authBaseURL = params.authBaseURL;
        paramsStr += ", authBaseURL="+params.authBaseURL;
    }
    
    _logger.debug("Environment parameters supplied: "+paramsStr);
    */
}