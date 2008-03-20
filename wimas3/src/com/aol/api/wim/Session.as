/* 
Copyright (c) 2008 AOL LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the AOL LCC nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/

package com.aol.api.wim {
    
    import com.aol.api.logging.ILog;
    import com.aol.api.logging.Log;
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.openauth.ClientLogin;
    import com.aol.api.openauth.HMAC;
    import com.aol.api.openauth.events.AuthEvent;
    import com.aol.api.wim.data.AuthChallenge;
    import com.aol.api.wim.data.BuddyList;
    import com.aol.api.wim.data.DataIM;
    import com.aol.api.wim.data.IM;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.data.types.AuthChallengeType;
    import com.aol.api.wim.data.types.FetchEventType;
    import com.aol.api.wim.data.types.SessionState;
    import com.aol.api.wim.events.AddedToBuddyListEvent;
    import com.aol.api.wim.events.AuthChallengeEvent;
    import com.aol.api.wim.events.BuddyListEvent;
    import com.aol.api.wim.events.DataIMEvent;
    import com.aol.api.wim.events.EventController;
    import com.aol.api.wim.events.IMEvent;
    import com.aol.api.wim.events.SessionEvent;
    import com.aol.api.wim.events.TypingEvent;
    import com.aol.api.wim.events.UserEvent;
    import com.aol.api.wim.interfaces.IResponseParser;
    import com.aol.api.wim.transactions.AddBuddy;
    import com.aol.api.wim.transactions.GetPresence;
    import com.aol.api.wim.transactions.RemoveBuddy;
    import com.aol.api.wim.transactions.ResultLoader;
    import com.aol.api.wim.transactions.SendIM;
    import com.aol.api.wim.transactions.SetState;
    import com.aol.api.wim.transactions.SetTyping;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
        
    /**
     * This object represents the main integration point for a client application.
     * It represents a AOL Instant Messenger or ICQ "session" for an identity in the AIM/ICQ network.
     * It dispatches many events representing the state of the session as well as responses to
     * server requests.
     * 
     * <p>
     * Session wraps the WIM APIs (see http://developer.aim.com/ref_api).  It maintains
     * internal state to handle
     * authentication, signon/signoff, and reconnection, and polling for updates from the user.  
     * It dispatches events to handle
     * instant messages, buddy list changes, etc.
     * Certain calls (such as getPresence) may be usable to a limited extent without having to
     * first call signOn.
     * </p>
     * <p>
     * <strong>NOTE:</strong>  There are a number of transactions which are not yet implemented.  We will be supplying updates
     * as these are completed. 
     * </p>
     * <p> 
     * GENERAL USAGE:
     * <br/>
     * <code>
     * var session:Session = new Session(stageOrSprite, devId);
     * // add event listensers (capturable)
     * session.addEventListener(SessionEvent.SESSION_AUTHENTICATING, onAuthenticating, true);
     * // non-capture
     * session.addEventListener(SessionEvent.STATE_CHANGED, onSessionStateChange);
     * ...
     * session.signOn(username, password);
     * </code>
     * 
     * @see com.aol.api.wim.events.EventController
     */  
    public class Session implements IEventDispatcher {
        // Maintain session variables and the auth token
        // WIM Variables
        protected static const API_BASE:String      =   "http://api.oscar.aol.com/";
        
        /**
         * 
         */        
        public var apiBaseURL:String     =  API_BASE;
        
        /**
         * AIM Session Id. This is passed to several api calls. It is set after a successful startSession call
         * 
         * @private
         */
        protected var _aimsid:String                =   null;
        
        /**
         * Represents our clientLogin instance.
         * 
         * @private
         */
        protected var _auth:ClientLogin             =   null;
        
        /**
         * Represents our clientLogin instance's base URL (provided to us through the constructor).
         * 
         * @private
         */
        protected var _authBaseURL:String           =   null;
        
        /**
         * Represents whether we are authenticated
         * 
         * @private
         */
        protected var _authenticated:Boolean        =   false;
        
        /**
         * Authentication token string. This token is passed to several api calls. It is either provided to us
         * during construction, or is acquired through our built-in authentication mechanism.
         * 
         * @private
         */
        protected var _token:AuthToken              =   null;
        
        /**
         * Holds the screename of the identity which is authenticated.
         * This is only used to remember our data when we dispatch a SESSION_AUTHENTICATING event.
         * 
         * @private
         */
        protected var _username:String              =   null;
        
        /**
         * Holds the password of the identity being authenticated. This is held only temporarily.
         * This is only used to remember our data when we dispatch a SESSION_AUTHENTICATING event.
         * 
         * @private
         */
        protected var _password:String              =   null;
        
        /**
         * Holds the challengeAnswer during authentication, if provided.
         * This is only used to remember our data when we dispatch a SESSION_AUTHENTICATING event.
         * 
         * @private
         */
        protected var _challengeAnswer:String       =   null;
        
        /**
         * When using clientLogin, sessionKey holds the HMAC sha256 hash of sessionSecret and user's password.
         * This is only used to remember our data when we dispatch a SESSION_AUTHENTICATING event.
         * 
         * @private
         */
        protected var _sessionKey:String            =   null;
        
        /**
         * When using clientLogin, this holds the name of your client and it is sent up during authentication.
         * 
         * @private
         */
        protected var _clientName:String            =   null;
        
        /**
         * When using clientLogin, this holds your client version and it is sent up during authentication.
         * 
         * @private
         */
        protected var _clientVersion:String         =   null;          
        
        /**
         * Our devId which is supplied during construction
         * 
         * @private
         */
        protected var _devId:String                 =   null;
        
        /**
         * Stores our transaction objects.
         * 
         * @private 
         */
        protected var _transactions:Object          =   null;
        
        /**
         * Our protected 'Class' instance of the ClientLogin class.
         * We set this object a subclass of ClientLogin designed to facilitate offline testing
         * of our authentication code. It is protected so that we may override it during testing.
         * 
         * @private
         */
        protected var _authClass:Class              =   ClientLogin;
        
        /**
         * Our protected 'Class' instance of the URLLoader class.
         * We set this object a subclass of URLLoader designed to facilitate offline testing
         * of our network access code. It is protected so that we may override it during testing.
         * 
         * @private
         */
        protected var _loaderClass:Class            =   ResultLoader;
        
        /**
         * Our protected 'Class' instance of a IResponseParser.
         * This object is used to parse response data, and converts all formatted response to a usable
         * Actionscript object.
         * 
         * @private
         */
        protected var _parser:IResponseParser       =   null;
        /**
         * This array can be set with numbers which represent each retry latency (in seconds) for each retry attempt.
         * For each retry attempt, Session will look up reconnectSchedule[attemptNum]. If it is not available, it
         * uses the last available latency. This means you can supply something like [10,20,20,20,30], or you can 
         * construct the Array so that [0]=10, [1]=20, [4]=30.
         */        
        public var reconnectSchedule:Array          =   null;
        
        /**
         * This represents the number of times the session will try to reconnect. If -1, unlimited retries.
         */        
        public var maxReconnectAttempts:uint        =   2;
        
        // Protected session variables
        /**
         * @private
         */ 
        protected var _fetchTimer:Timer             =   null;

        /**
         * @private
         */
        protected var _fetchRetryTimer:Timer        =   null;
 
        /**
         * @private
         */
        protected var _fetchEventsBaseUrl:String    =   null;

        /**
         * @private
         */
        protected var _timeToNextFetchMs:uint       =   0;

        /**
         * @private
         */
        protected var _maxFetchTimeoutMs:uint       =   25000;

        /**
         * @private
         */
        protected var _lastFetchEventsQuery:String  =   null;

        /**
         * @private
         */
        protected var _numFetchRetries:int          =   0;

        /**
         * @private
         */
        protected var _secondsToNextReconnect:uint    =   30;

        /**
         * @private
         */
        internal  var _autoFetchEvents:Boolean      =   true;
        
        // Private variables for certain getter methods

        /**
         * @private
         */
        protected var _isAnonymousSession:Boolean   =   false;

        /**
         * @private
         */
        protected var _state:String                 =   SessionState.OFFLINE;

        /**
         * @private
         */
        protected var _myInfo:User                  =   null;
        
        // Event Model variables

        /**
         * @private
         */
        internal var _evtDispatch:EventController=   null;
        
        // Logging object
        private var _logger:ILog                    =   null;
        
        /**
         * This flag allows us to request a captcha challenge from open auth when we do a client login.
         * 
         * @private
         */        
        protected var _forceCaptcha:Boolean         =   false;
        
        // Ensure namespace is set (for this class) or E4X won't work.
        private namespace _aimNS    =   "http://developer.aim.com/xsd/aim.xsd";
        use namespace _aimNS;
        
        /**
         * Initialize a session.  
         */
        public function Session(stageOrContainer:DisplayObjectContainer, developerKey:String,
                                   clientName:String=null, clientVersion:String=null, 
                                   logger:ILog=null, wimBaseURL:String=null, authBaseURL:String=null) {
                                       
            this._devId = developerKey;
            this._clientName = clientName;
            this._clientVersion = clientVersion;
            
            this._logger = (logger) ? logger : new Log("Session");
           
            this._evtDispatch = new EventController(stageOrContainer, _logger);
            this._parser = new AMFResponseParser();
            

            if(!_devId) {
                this._logger.error("No developer / wimzi key specified!");
            }
            
            if(wimBaseURL && wimBaseURL != "") {
                this.apiBaseURL = wimBaseURL;
            }
            
            _authBaseURL = authBaseURL;
            
            _logger.info("Session baseURL: "+this.apiBaseURL);
            
            _transactions = new Array();
            
            // Now register as targets for all of our events so we can allow being cancelled, modified, etc.
            _evtDispatch.addEventListener(SessionEvent.SESSION_AUTHENTICATING, this.doAuthenticateSession, false, 0, true);
            _evtDispatch.addEventListener(SessionEvent.SESSION_STARTING, this.doStartSignedSession, false, 0, true);
            _evtDispatch.addEventListener(SessionEvent.EVENTS_FETCHING, this.doFetchEvents, false, 0, true);
            _evtDispatch.addEventListener(SessionEvent.SESSION_ENDING, this.doSignOff, false, 0, true);
            
            // Fetch events retry schedule
            // TODO: Load our retry schedule externally?
            //["0":1,"1":15,"2":30,"3":60,"8":120]
            reconnectSchedule = new Array();
            reconnectSchedule[0] = 1;
            reconnectSchedule[1] = 15;
            reconnectSchedule[2] = 30;
            reconnectSchedule[4] = 60;
            reconnectSchedule[8] = 120;
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////////
        // Full propagation Event dispatching support //////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////
        
        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void {
            // really on the parent
            _evtDispatch.addEventListener(type,listener,useCapture,priority,useWeakReference);
        }
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
            // really on the parent
            _evtDispatch.removeEventListener(type,listener,useCapture);
        }
        public function dispatchEvent(event:Event):Boolean {
            return _evtDispatch.dispatchEvent(event);
        }
        public function hasEventListener(type:String):Boolean {
            // really on the parent
            return _evtDispatch.hasEventListener(type);
        }
        public function willTrigger(type:String):Boolean {
            // really on the parent
            return _evtDispatch.willTrigger(type);
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////
        // Util Methods /////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////

        public function createURLLoader():ResultLoader {
            return new _loaderClass();
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////////
        // AIM API Methods /////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////
        /**
         * Signs on with the supplied screenname and password. This uses the clientLogin method.
         * This passes the data along to a ClientLogin instance. Note an authentication challenge may be
         * dispatched, at which point the client would have to call this method again, with the correct
         * challenge answer (ASQ answer, securid, captcha string, etc.).
         * Fires a <code>SESSION_AUTHENTICATING</code> state.
         * 
         * @param user The screenname of the user
         * @param pass The password of the user
         */
        public function signOn(user:String, pass:String, challengeAnswer:String=null, forceCaptcha:Boolean=false):void {
            
            // TODO: Perhaps add a 'signInAsInvisible' param? or even a 'signInAs' state object? (so you can sign in as away)
            if(!user) {
                _logger.error("signOn: no username specified");
                return;
            }
            if(!pass) {
                _logger.error("signOn: no password specified");
                return;
            }
            // Initiate a clientLogin and do a signed start session
            this._username = user;
            this._password = pass;
            this._challengeAnswer = challengeAnswer;
            this._forceCaptcha = forceCaptcha;
            // Fire a sessionevent that is that we are authenticating
            this.sessionState = SessionState.AUTHENTICATING;
            // TODO: should this just be a STATE_CHANGE? Hmm, then we can't really be a target for that event.
            dispatchEvent(new SessionEvent(SessionEvent.SESSION_AUTHENTICATING, this, true, true));
            
        }
        
        private function doAuthenticateSession(evt:SessionEvent):void {
            
            // We are here because we successfully dispatched a SESSION_AUTHENTICATING event and we are
            // cleared to authenticate.
            /*
            if(_auth) {
                _auth.removeEventListener(AuthEvent.LOGIN,    onAuthSignOn);
                _auth.removeEventListener(AuthEvent.LOGOUT,   onAuthSignOut);
                _auth.removeEventListener(AuthEvent.CHALLENGE, onAuthChallenge);
                _auth.removeEventListener(AuthEvent.ERROR,     onAuthError);
                _auth = null;
            }
            */
            if(!_auth) {
                _auth = new _authClass(this._devId, this._clientName, this._clientVersion, _logger, _authBaseURL);
                _auth.addEventListener(AuthEvent.LOGIN,    onAuthSignOn, false, 0, true);
                _auth.addEventListener(AuthEvent.LOGOUT,   onAuthSignOut, false, 0, true);
                _auth.addEventListener(AuthEvent.CHALLENGE, onAuthChallenge, false, 0, true);
                _auth.addEventListener(AuthEvent.ERROR,     onAuthError, false, 0, true);
            }
            
            _auth.signOn(this._username, this._password, this._challengeAnswer, !this._challengeAnswer ? _forceCaptcha : false);
        }
        
        /**
         * On a successful sign on from ClientLogin, we initiate a start Session. 
         * @param evt
         * 
         */        
        private function onAuthSignOn(evt:AuthEvent):void {
            if(sessionState != SessionState.AUTHENTICATING)
            {
                signOff();
                return;
            }
            if(evt.statusCode == 200) {
                _authenticated = true;
                _challengeAnswer = null;
                // Start a signed session
                this.startSignedSession(evt.token, evt.sessionKey);
            }
        }
        private function onAuthSignOut(evt:AuthEvent):void {
            
            _logger.debug("AuthSignOut");
            this.sessionState = SessionState.OFFLINE;
        }
        private function onAuthChallenge(evt:AuthEvent):void {
            if(sessionState != SessionState.AUTHENTICATING)
            {
                signOff();
                return;
            }
            _logger.debug("AuthChallenge");
            var challenge:AuthChallenge = null;
            if(evt.statusDetailCode==3015) {
                var context:String = evt.challengeContext;
                var url:String = evt.challengeUrl + "?devId="+_devId+"&context="+context+"&language=en-us";
                var captchaImageUrl:String = url + "&f=image";
                var captchaAudioUrl:String = url + "&f=audio";
                var info:String = evt.info; // "PLease enter word in the image"
                challenge = new AuthChallenge(AuthChallengeType.CAPTCHA_CHALLENGE, info, null, captchaImageUrl, captchaAudioUrl);
            } else if(evt.statusDetailCode==3011) {
                // Invalid password
                challenge = new AuthChallenge(AuthChallengeType.USERPASS_CHALLENGE, evt.info);
            } else if(evt.statusDetailCode==3012) {
                // Securid challenge
                challenge = new AuthChallenge(AuthChallengeType.SECURID_CHALLENGE, evt.info);
            } else if(evt.statusDetailCode==3013) {
                // Securid 'next' challenge
                challenge = new AuthChallenge(AuthChallengeType.SECURID_NEXT_CHALLENGE, evt.info);
            }  else if(evt.statusDetailCode==3014) {
                // ASQ challenge
                challenge = new AuthChallenge(AuthChallengeType.ASQ_CHALLENGE, evt.info);
            }
            dispatchEvent(new AuthChallengeEvent(challenge, true, true));
            this.sessionState = SessionState.AUTHENTICATION_CHALLENGED;
        }
        private function onAuthError(evt:AuthEvent):void {
            if(sessionState != SessionState.AUTHENTICATING)
            {
                signOff();
                return;
            }
            
            _logger.error("AuthError");
            this.sessionState = SessionState.AUTHENTICATION_FAILED;
        }
        
        /**
         * Initiates a <code>SESSION_STARTING</code> event, which can be cancelled.
         * If it is not cancelled, then a signed startSession request is sent to the server.
         * @param authToken The <code>AuthToken</code> object represesenting our authentication credentials
         * @param sessionKey The key with which we sign our request string (using sha256).
         * 
         */        
        public function startSignedSession (authToken:AuthToken, sessionKey:String):void {
            // For now, store the params internally - this needs to be marshalled out as part of event data
            _token  = authToken;
            _sessionKey = sessionKey;
            
            // Set our state to STARTING
            this.sessionState = SessionState.STARTING;
            // Dispatch a capturable SESSION_STARTING event
            // TODO: Rename SESSION_STARTING to SESSION_SIGNING_ON to avoid confusion with SessionState.STARTING?
            dispatchEvent(new SessionEvent(SessionEvent.SESSION_STARTING, this, true, true));
        }
        
        /**
         * Actually performs a startSession query to WIM. It is the target of the SESSION_STARTING event.
         * It packages up all the parameters into a query string and SHA256 signs the resulting string.
         * @param evt
         * 
         */
        private function doStartSignedSession(evt:SessionEvent):void {
            
            var method:String = "aim/startSession";
            var queryString:String = "";
            var sig_sha256:String = "";

            // Set up params in alphabetical order
            queryString += "a="+_token.a;
            queryString += "&clientName="+encodeStrPart(_clientName);
            queryString += "&clientVersion="+encodeStrPart(_clientVersion);
            queryString += "&events="+encodeStrPart("myInfo,presence,buddylist,typing,im,dataIM,offlineIM");
            queryString += "&f=amf3";
            queryString += "&k="+_devId;
            
            var now:Number = new Date().getTime() / 1000;           
            _logger.debug("Host Time: {0}, Now: {1}", _token.hostTime, now);
            queryString += "&ts="+(_token.hostTime + Math.floor(now - _token.clientTime) as uint);
            
            var encodedQuery:String = escape(queryString);
            
            
            //_logger.debug("AIMBaseURL     : "+apiBaseURL + method);
            //_logger.debug("QueryParams    : "+queryString);
            //_logger.debug("Session Key    : "+_sessionKey);
        
        
            // Generate OAuth Signature Base
            var sigBase:String = "GET&"+encodeStrPart(apiBaseURL + method)+"&"+encodedQuery;
            //_logger.debug("Signature Base : "+sigBase);
            // Generate hash signature
            var sigData:String = (new HMAC()).SHA256_S_Base64(_sessionKey, sigBase);
            sig_sha256 = sigData;
            //_logger.debug("Signature Hash : "+encodeURIComponent(sig_sha256));

            // Append the sig_sha256 data
            queryString += "&sig_sha256="+encodeURIComponent(sig_sha256);
            _logger.debug("StartSessionQuery: "+queryString);
            sendRequest(apiBaseURL + method + "?"+queryString, startSessionResponse);
        }
                
        private function encodeStrPart(s:String):String {
            var r:String = encodeURIComponent(s);
            r = r.replace(/\+/, "%2B");
            r = r.replace(/_/, "%5F");
            return r;
        }
        
        private function startSessionResponse(evt:Event):void {
            if(sessionState != SessionState.STARTING)
            {
                //umm....something is messed up. Maybe the user cancelled? bail!
                signOff();
                return;
            }
            var loader:URLLoader = evt.target as ResultLoader;
            //_logger.debug("StartSession Response XML: "+String(loader.data));
            var response:Object = getResponseObject(loader.data);
            
            var statusCode:uint = response.statusCode;
            var statusText:String = response.statusText;
            
            if(statusCode == 200) {
                _fetchEventsBaseUrl = response.data.fetchBaseURL;
                var myInfo:User               = _parser.parseUser(response.data.myInfo);

                _aimsid     = response.data.aimsid;
                _logger.debug("Session Started");
                // this will dispatch a STATE_CHANGED event
                this.sessionState = SessionState.ONLINE;
                // this will dipatch a MY_INFO_UPDATED event
                this.myInfo = myInfo;                
                // start the fetchevents loop  
                if(_autoFetchEvents) {
                    fetchEvents();
                }
            } else if (statusCode == 607) {
                // Rate limited
                _logger.debug(statusText+" ["+statusCode+"]: ");
                this.sessionState = SessionState.RATE_LIMITED;
            } else if (statusCode == 401) {
                // We have a bad authentication token, we must re-authenticate
                _logger.debug("Received 401 - assuming bad auth token, reauthenticating with cached user/pass...");
                signOn(this._username, this._password, _challengeAnswer, _forceCaptcha);
            } else {
                _logger.error("startSession Error Response: "+ loader.data);
                _logger.error("Error during startSession: ["+statusCode+"] "+(response.statusDetailCode)+
                             " - "+statusText);
                this.sessionState = SessionState.OFFLINE;
            }
        }
        
        /**
         * Optional method to start an anonymous session.
         * @param displayName This sets our 'friendly name' when we start the session. Optional.
         */
        public function signOnAnonymous(displayName:String=null):void {
            // startSession
            // TODO: Perhaps add a 'signInAsInvisible' param? or even a 'signInAs' state object? (so you can sign in as away)
            _isAnonymousSession = true;
        }
        
        /**
         * Ends the session.
         */
        public function signOff():void {
            // endSession
            
            // TODO: Rename SESSION_ENDING to SESSION_SIGNING_OFF to avoid confusion with SessionState.OFFLINE ?
            dispatchEvent(new SessionEvent(SessionEvent.SESSION_ENDING, this, true, true));
        }
        
        /**
         * @private 
         */
        protected function doSignOff(evt:SessionEvent):void {
            
            if(sessionState == SessionState.ONLINE || 
               sessionState == SessionState.STARTING )
            {
                var query:String = generateSignOffURL();
                _logger.debug("EndSessionQuery: "+query);
                sendRequest(query, signOffResponse);
            }
            if(sessionState != SessionState.ONLINE)
            {
                clearSession();
            }
        }
        
        /**
         * @private 
         */        
        protected function signOffResponse(evt:Event):void {
            
            var loader:ResultLoader = ResultLoader(evt.target);
           
            var response:Object = getResponseObject(loader.data);
            
            if(response.statusCode == 200) {
                clearSession();
            }
            
        }
        
        /**
         * Clears important session variables. This is called after we go offline.
         * 
         * Mainly, the fetchEvents mechanism is turned off along with associated
         * timers, and we dispatch a SessionEvent.STATE_CHANGE event. 
         * 
         * @private
         */        
        protected function clearSession():void {
            if(_fetchTimer && _fetchTimer.running) {
                _fetchTimer.stop();
            }
            stopFetchRetryTimer();
            _numFetchRetries = 0;
            this.sessionState = SessionState.OFFLINE;
        }
        
        /**
         * Helpful if you need to signoff from JavaScript.  This happens if the user
         * closes the browser window which results in the Flash Player being
         * torn down.
         */ 
        public function generateSignOffURL():String
        {
            return apiBaseURL + "aim/endSession" +
                "?f=amf3" +
                "&aimsid=" + _aimsid;
        }

        ////////////////////////////////////////////////////////////////////////
        // Fetch Events Related
        ////////////////////////////////////////////////////////////////////////
        
        /**
         * Called by the timer, and also invoked the first time during a startSessionResponse
         * @param evt Optional timer event
         * 
         * @private
         */
        protected function fetchEvents(evt:TimerEvent=null):void {
            if(this._state == SessionState.ONLINE || this._state == SessionState.RECONNECTING) {
                // fetchEvents
                dispatchEvent(new SessionEvent(SessionEvent.EVENTS_FETCHING, this, true, true));
            }
        }
        
        /**
         * Does the actual <code>fetchEvents</code> request.
         * 
         * @private
         */
        protected function doFetchEvents(evt:SessionEvent):void {
            // constructs the method request url
            var query:String = this._fetchEventsBaseUrl +
                "&f=amf3" +
                "&timeout=" + _maxFetchTimeoutMs;
                
            _logger.debug("FetchEventsQuery: "+query);
            
            _lastFetchEventsQuery = query;
            // Manual sending of fetch events request
            var theRequest:URLRequest = new URLRequest(query);
            
            var loader:ResultLoader = createURLLoader();
            loader.maxTimeoutMs = _maxFetchTimeoutMs + 2000;
            loader.addEventListener(Event.COMPLETE, fetchEventsResponse, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, handleFetchEventsIOError, false, 0, true);
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.load(theRequest);
        }
        
        /**
         * Checks any returned HTTP status code for errors, such as server-side timeouts, etc. 
         * @param evt
         * 
         * @private
         */        
        protected function handleFetchEventsIOError(evt:IOErrorEvent):void {
            _logger.error("Fetch events IOError: "+evt.text);
            
            
            
            /*
             Respond to event here
             */
             // status code 2032 is stream error - socket could not be opened
             // that should happen when we are
             // 1 - lost connectivity
             // 2 - came back from standby?
            if(this._state == SessionState.ONLINE || this._state == SessionState.RECONNECTING) {
                // If maxReconnectAttemps is -1 or our num retries is less than the max...
                if(maxReconnectAttempts < 0 || _numFetchRetries < maxReconnectAttempts) {
                    // we are currently online, so attempt reconnecting
                    this.sessionState = SessionState.RECONNECTING;
                    if(reconnectSchedule[_numFetchRetries]) {
                        _secondsToNextReconnect = reconnectSchedule[_numFetchRetries];
                    }
                    _logger.debug("Retry attempt: "+_numFetchRetries+": wait "+_secondsToNextReconnect+" seconds");
                    if(_secondsToNextReconnect <= 0) {
                        _secondsToNextReconnect = 0.1;
                    }
                    startFetchRetryTimer(_secondsToNextReconnect * 1000);
                } else {
                    // We have given up attempting to reconnect
                    _logger.debug("Max number of retries reached, abandoning reconnect");
                    // we went from online --> disconnected 
                    this.sessionState = SessionState.DISCONNECTED;
                }
            } else if(_state != SessionState.ONLINE && _state != SessionState.RECONNECTING) {
                // we went from !online|reconnecting --> error, so just go back to offline
                this.sessionState = SessionState.OFFLINE;
            }
        }
         
        /**
         * This is called by the fetchRetryTimer, when we are attempting
         * a resending of the last fetchEvents query.
         *  
         * @param evt
         * 
         * @private
         * 
         */         
        protected function onFetchRetry(evt:TimerEvent):void {
            //_logger.debug("Timeout exceeded! Relaunching fetch Events");
            // automatically launch another fetchevents
            _numFetchRetries++;
            _logger.debug("Retrying fetchEvents (attempt " + _numFetchRetries + 
                          " out of " + this.maxReconnectAttempts + ")");
            fetchEvents();
        }
        
        /**
         * Handles the returned data from a fetchEvents request
         * 
         * @private
         */
        protected function fetchEventsResponse(evt:Event):void {
            var loader:ResultLoader = ResultLoader(evt.target);
            
            var response:Object = getResponseObject(loader.data);
            
            if(response == null) {
                _logger.error("fetchEvents could not parse response");
                return;
            }
            
            if(statusCode != 200) _logger.debug("fetchEvents response: {0} ", response);
            
            var statusCode:uint = response.statusCode;
            var statusText:String = response.statusText;
            
            //var response:FetchEventsResponse = _parser.parseFetchEventsResponse(loader.data);
            if(statusCode == 200) {
                /* removing fetchEvents debug output because it is just too much :)
                _logger.debug("FetchEvents: ["+response.statusCode+"] "+response.statusDetailCode+
                             " - "+response.statusText);
                */
                // If were previously trying to reconnect, set ourselves online again
                if(_state == SessionState.RECONNECTING) {
                    stopFetchRetryTimer();
                    _numFetchRetries = 0;
                    sessionState = SessionState.ONLINE;
                }
                
                _fetchEventsBaseUrl= response.data.fetchBaseURL;
                _timeToNextFetchMs = response.data.timeToNextFetch;
                
                dispatchEvent(new SessionEvent(SessionEvent.EVENTS_FETCHED, this, true, true));
                handleAIMEvents(response.data.events);
                
                if(_state == SessionState.ONLINE) {
                 
                    // We are still online, so go attempt another fetchEvents.
                    // We have to check if we are online in case we sent an endSession event
                    // and/or got knocked offline.
                    if(this._autoFetchEvents) {
                        if(!_fetchTimer) {
                            this._fetchTimer = new Timer(_timeToNextFetchMs, 1); // Create a default Timer object for 0ms.
                            this._fetchTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fetchEvents, false, 0, true);
                        }
                        this._fetchTimer.repeatCount = 1;
                        this._fetchTimer.delay = _timeToNextFetchMs;
                        this._fetchTimer.start(); 
                    }
                } else {
                    _logger.error("Received a successful fetchEvents, but our state is: "+this._state);
                }
                
            } else if(statusCode == 460) {
                // We have an invalid aimsid (perhaps because we were disconnected for a while and during a success reconnect we
                // get told that our session has expired.
                
                // Attempt start the session again (with the same auth token that we have)
                _logger.debug("Invalid aimsid during fetchEvents, attempting startSession");
                startSignedSession(this._token, this._sessionKey);
                
            } else {
                _logger.error("Error during fetchEvents!!");
            }
        }
        
        /**
         * @private 
         */        
        protected function startFetchRetryTimer(timeUntilFetch:int):void {
            stopFetchRetryTimer();
            // Set up a timer to verify that we get a response within our specified 
            // max timeout - if we don't it means we lost connection to the server
            if(!_fetchRetryTimer) {
                _fetchRetryTimer = new Timer(0, 1);
                _fetchRetryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFetchRetry, false, 0, true);
            }
            _fetchRetryTimer.delay = timeUntilFetch;
            _fetchRetryTimer.start();
        }
        
        /**
         * @private 
         */        
        protected function stopFetchRetryTimer(): void {
            
            if(_fetchRetryTimer && _fetchRetryTimer.running) {
                _fetchRetryTimer.stop();
            }
        }
        
        /**
         * Inspects each 'event' in the <code>evts</code> array and dispatches the appropriate event.
         * Currently only the BuddyList event and the ENDSESSION is handled correctly.
         * TODO: Finish all other event handling.
         * @param evts An array of events
         * 
         * @private
         * 
         */        
        protected function handleAIMEvents(evts:Array):void {
            if(!evts || evts.length == 0) { return; }

            // TODO: Need to complete, once we receive a correctly formatted fetchEvents response

            for each(var evt:Object in evts) {
                var type:String = evt.type;
                var eventData:Object = evt.eventData;
                switch(type) {
                    case (FetchEventType.MY_INFO) : {
                        _logger.debug("Dispatching MY_INFO_UPDATED");
                        // TODO: Create a UserEvent to represent MY_INFO and PRESENCE events?
                        var myNewInfo:User = _parser.parseUser(eventData);
                        dispatchEvent(new UserEvent(UserEvent.MY_INFO_UPDATE_RESULT, myNewInfo, true, true));
                        break;
                    }
                    case (FetchEventType.PRESENCE) : {
                        _logger.debug("Dispatching BUDDY_PRESENCE_UPDATED");
                        // TODO: Create a UserEvent to represent MY_INFO and PRESENCE events?
                        var buddy:User = _parser.parseUser(eventData);
                        dispatchEvent(new UserEvent(UserEvent.BUDDY_PRESENCE_UPDATED, buddy, true, true));
                        break;
                    }
                    case (FetchEventType.BUDDY_LIST) : {
                        _logger.debug("Dispatching LIST_RECEIVED");
                        // Dispatch a BuddyListEvent.LIST_RECEIVED
                        var bl:BuddyList = _parser.parseBuddyList(eventData);
                        bl.owner = _myInfo;
                        dispatchEvent(new BuddyListEvent(BuddyListEvent.LIST_RECEIVED,null,null,bl,true,true));
                        break;
                    }
                    case (FetchEventType.TYPING) : {
                        _logger.debug("Dispatching TYPING_STATUS_RECEIVED");
                        // Dispatch a new TypingEvent?
                        var typing:String = eventData.typingStatus;
                        var sourceId:String = eventData.aimId;
                        dispatchEvent(new TypingEvent(TypingEvent.TYPING_STATUS_RECEIVED, typing, sourceId, true, true));
                        break;
                    }
                    case (FetchEventType.IM) : {
                        _logger.debug("Dispatching IM");
                        // Dispatch a new IMEvent.IM_RECEIVED
                        var im:IM = _parser.parseIM(eventData);
                        dispatchEvent(new IMEvent(IMEvent.IM_RECEIVED, im, true, true));
                        break;
                    }
                    case (FetchEventType.DATA_IM) : {
                        _logger.debug("TODO: Dispatch DATA_IM");
                        var dataIM:DataIM = _parser.parseDataIM(eventData);
                        dispatchEvent(new DataIMEvent(DataIMEvent.DATA_IM_RECEIVED, dataIM, true, true));
                        break;
                    }
                    case (FetchEventType.END_SESSION) : {
                        _logger.debug("Received END_SESSION");
                        clearSession();
                        break;
                    }
                    case (FetchEventType.OFFLINE_IM) : {
                        // Dispatch a new IMEvent.OFFLINE_IM_RECEIVED ? or just dispatch IM_RECEIVED?
                        // The IM object contains the context for whether it's offline or not
                        var offIM:IM = _parser.parseIM(eventData, _myInfo, true);
                        dispatchEvent(new IMEvent(IMEvent.IM_RECEIVED, offIM, true, true));
                        break;
                    }
                    case (FetchEventType.ADDED_TO_LIST) : {
                        var aimId:String = eventData.requester;
                        var message:String = eventData.msg;
                        var authRequested:Boolean = eventData.authRequested;
                        if(aimId)
                        {
                            dispatchEvent(new AddedToBuddyListEvent(AddedToBuddyListEvent.ADDED_TO_LIST, aimId, message, authRequested, true, true));
                        }
                        else
                        {
                            _logger.warn("Received '{0}' event, but there is no aimId", type);
                        }
                    }
                    default: {
                        _logger.warn("Received an unknown type of event, type is: "+type);
                    }
                } 
            } 
 
        }

        // Presence Methods ///////////////////////////////////////////////////////
        // Notes - do we want to continue the idea of 'get' prefixed calls? to me they've always meant
        // to return something immediately. What's an alternative?
        
        /**
         * Retrieves the presence information for a buddy or an array of buddies.
         * When the call returns, a <pre>UserEvent.BUDDY_PRESENCE_UPDATED</pre> will fire for each user.
         * 
         * For options, the following params are available. They should be properties 
         * on the options object.
         * 
         * Boolean    awayMsg       [Default 0] - Return away messages
         * Boolean    profileMsg    [Default 0] - Return profile messages
         * Boolean    presenceIcon  [Default 1] - Return presence icon
         * Boolean    location      [Default 1] - Return location information
         * Boolean    capabilities  [Default 0] - Return capability information
         * Boolean    memberSince   [Default 0] - Return member since information
         * Boolean    statusMsg     [Default 0] - Return status message information
         * Boolean    friendly      [Default 0] - Return friendly name
         * 
         * @param buddyOrBuddies A string or an array of string screennames.
         * @param options [optional] An object with properties for optional parameters
         */
        public function requestBuddyInfo(screenNameOrNames:*, options:Object=null):void {
            var names:Array = null;
            if(screenNameOrNames is String) {
                names = [screenNameOrNames];
            } else if(screenNameOrNames is Array) {
                names = screenNameOrNames;
            }
            var transaction:GetPresence;
            if(!_transactions.getPresence) {
               transaction = new GetPresence(this);
               _transactions.getPresence = transaction;
            } else {
                transaction = _transactions.getPresence as GetPresence;
            }
            transaction.run(names, options);
        }
        
        /**
         * @private
         *  
         * Requests a buddy list from the server.
         * @param buddyOrBuddies A string or an array of string screennames.
         */
        public function requestBuddyList():void {
            // getPresence (bl=1)
        }
        
        /**
         * @private
         *  
         * Sets our buddy status msg with the server.
         * @param msg A string message.
         */
        public function setStatusMsg(statusMsg:String):void {
            // setStatus
        }
        
        /**
         * @private
         * 
         * Sets our buddy profile msg with the server.
         * @param profileMsg A profile message.
         */
        public function setProfileMsg(profileMsg:String):void {
            // setProfile
        }
        
        // IM Methods //////////////////////////////////////////////////////////////
        // *** See design notes above
        /**
         * Sends an IM to a screenname
         * @param buddyScreenName The screenName of the buddy being IMed.
         * @param msg The message to be sent. This message is <code>escape()</code>ed before sending.
         * @param isAutoResponse Whether or not this message should be marked as an auto-response.
         * @param attempOffline If <code>true</code>, the message will be scheduled for offline delivery if needed.
         * 
         * @see com.aol.api.wim.events.IMEvent#IM_SENDING
         * @see com.aol.api.wim.events.IMEvent#IM_SEND_RESULT
         */
        public function sendIMToBuddy(buddyScreenName:String, msg:String, 
                                      isAutoResponse:Boolean=false, attemptOffline:Boolean=false):void {
            var transaction:SendIM;
            if(!_transactions.sendIM) {
               transaction = new SendIM(this);
               _transactions.sendIM = transaction;
            } else {
                transaction = _transactions.sendIM as SendIM;
            }
            transaction.run(buddyScreenName, msg, isAutoResponse, attemptOffline);
        }
        
        /**
         * @private
         *  
         * Sends a data IM
         * This needs to be fleshed out.
         * 
         */
        public function sendDataIMToBuddy(buddyScreenName:String, type:String, data:String, base64Encoded:Boolean=false, 
                                   isAutoResponse:Boolean=false, inviteMsg:String=null):void {
            // sendDataIM
        }
        
        /**
         * Sets a typing status, directed at a buddy we're talking to.
         * 
         * @param buddyName The name of the buddy who should receive the typing status
         * @param typingStatus The typing status
         * 
         */         
        public function setTypingStatus(buddyName:String, typingStatus:String):void {
            // setTyping
            var transaction:SetTyping;
            if(!_transactions.setTyping) {
               transaction = new SetTyping(this);
               _transactions.setTyping = transaction;
            } else {
                transaction = _transactions.setTyping as SetTyping;
            }
            transaction.run(buddyName, typingStatus);
        }
        
        // Expression Methods (many of these don't require a session id) //////////
        /**
         * @private
         *  
         * Gets an expression based on expression type for a buddy.
         * @param buddyScreenName The screenName of the buddy whose expression we want.
         * @param expressionType The type of expression we want to request.  Constants are in <code>ExpressionType</code>.
         */
        public function requestExpression(buddyScreenName:String, expressionType:String):void {
        }
        
        // NOTE skipping getAsset (which retrieves binary data)
        
        /**
         * @private
         * 
         * Sets one of our own expressions based on type.
         * @param expressionType The type of expression. Constants are in <code>ExpressionType</code>.
         * @param id The id of the expression ? I think this is the id returned from an uploadExpression request.
         */
        public function setExpression(expressionType:String, id:String):void {
        }      
        
        public function addBuddy(buddyName:String, groupName:String):void {
            var transaction:AddBuddy;
            if(!_transactions.addBuddy) {
               transaction = new AddBuddy(this);
               _transactions.addBuddy = transaction;
            } else {
                transaction = _transactions.addBuddy as AddBuddy;
            }
            transaction.run(buddyName, groupName);
        }
        
        public function removeBuddy(buddyName:String, groupName:String):void {
            var transaction:RemoveBuddy;
            if(!_transactions.removeBuddy) {
               transaction = new RemoveBuddy(this);
               _transactions.removeBuddy = transaction;
            } else {
                transaction = _transactions.removeBuddy as RemoveBuddy;
            }
            transaction.run(buddyName, groupName);
        }
        
        /** 
         * Sets the state of the logged in user. 
         * 
         * @param user This is the session's user with its state set to the
         * appropriate value.   
         *
         *
         * @see com.aol.api.wim.events.UserEvent#MY_INFO_UPDATING
         * @see com.aol.api.wim.events.UserEvent#MY_INFO_UPDATE_RESULT  
         */ 
        public function setState(user:User):void {
            var transaction:SetState;
            if(!_transactions.setState) {
               transaction = new SetState(this);
               _transactions.setState = transaction;
            } else {
                transaction = _transactions.setState as SetState;
            }
            transaction.run(user);
        }
 
        
        // Fetch Events specific methods (for robust connectedness)
        
        // Generic Request methods
        // fetchEvents will have its own fetchEvents request
        private function sendRequest(query:String, callbackFunc:Function, requestMethod:String=URLRequestMethod.GET):void {
            
            var theRequest:URLRequest = new URLRequest(query);
            theRequest.method = requestMethod;
            
            var loader:ResultLoader = createURLLoader();
            loader.addEventListener(Event.COMPLETE, callbackFunc, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
            if(query.indexOf("f=amf3") >= 0) {
                loader.dataFormat = URLLoaderDataFormat.BINARY;
            }
            loader.load(theRequest);
        }
        
        // Generic IO Error Event Listener
        private function handleIOError(evt:IOErrorEvent):void {
            _logger.error("IOError: "+evt.text);
            /*
             Respond to event here
             */
            /*
            if(this._state == SessionState.ONLINE) {
                // we went from online --> disconnected 
                this.sessionState = SessionState.DISCONNECTED;
            } else {
                // we went from !online --> error, so just go back to offline
                this.sessionState = SessionState.OFFLINE;
            }
            */
        }
        
        // Getter Methods /////////////////////////////////////////////////////////
        
        public function get logger():ILog {
            return _logger;
        }
        
        public function set logger(log:ILog):void {
            _logger = log;
        }
        
        public function get parser():IResponseParser {
            return _parser;
        }
        
        public function set parser(parser:IResponseParser):void {
            _parser = parser;
        }
        
        /**
         * Retrieves the state of our session.  
         * 
         * @see com.aol.api.wim.events.SessionEvent
         */
        public function get sessionState():String {
            return _state;
        }
        
        public function set  sessionState(s:String):void {
            //TODO: check if state is valid? Maybe not for extensibility?
            if(this._state != s) {
                this._state = s;
                _logger.debug("Session state --> "+this._state);
                dispatchEvent(new SessionEvent(SessionEvent.STATE_CHANGED, this, true, true));
            }
        }
        
        /**
         * Retrieves our buddy data object.
         */
        public function get myInfo():User {
            return _myInfo;
        }
        
        public function set myInfo(info:User):void {
            //TODO: add a .equals call on the user to check and see if both user objects are the same
            _myInfo = info;
            dispatchEvent(new UserEvent(UserEvent.MY_INFO_UPDATING, info, true, true));
        }
        
        public function get devId():String {
            return _devId;
        }
        
        public function get authToken():AuthToken {
            return _token;
        }
        
        public function get sessionKey():String {
            return _sessionKey;
        }
        
        public function get aimsid():String {
            return _aimsid;
        }
        
        /**
         * Returns true if we are an anonymous session.
         */
        public function get isAnonymous():Boolean {
            return _isAnonymousSession;
        }
        
        /**
         * Returns the time until the next fetch timer should be called.
         * 
         * This value is updated on every <code>fetchEventsResponse</code> 
         * @return The time to the next fetch events, in ms.
         * 
         */        
        public function get timeToNextFetchMs():uint {
            return _timeToNextFetchMs;
        }
        
        /**
         * Returns the base url for the next fetch events.
         * 
         * This value is updated on every <code>fetchEventsResponse</code> 
         * @return The time to the next fetch base url, which includes the seqnum
         * 
         */  
        public function get fetchEventsBaseURL():String {
            return _fetchEventsBaseUrl;
        }
        
        /**
         * Returns the maximum timeout for our fetch events request, in milliseconds
         */
        public function get maxFetchTimeoutMs():uint {
            return _maxFetchTimeoutMs;
        }
        
        // Setter Methods ////////////////////////////////////////////////////////
        
        /**
         * Sets the maximum timeout, in milliseconds, for the fetch events request. Minimum is 500, maximum is 3600000 (1 hour)
         */
        public function set maxFetchTimeoutMs(timeout:uint):void {
            if(timeout < 500) timeout = 500;
            else if(timeout > 3600000) timeout = 3600000;
            
            _maxFetchTimeoutMs = timeout;
        }
        
        // Utility functions /////////////////////////////////////////////////////
        
        /**
         * @private
         */ 
        protected function getResponseObject(data:Object):Object {
            
            var obj:Object = null;
            
            try {
                obj = ByteArray(data).readObject();
            } catch (e:Object) {
                _logger.fatal("ByteArray.readObject threw {0} on the following data: {1}", e, data);
            }
            
            if(obj) {
                return obj.response;
            } else {
                return null;
            }
        }
                
        public function toString():String {
            return "[Session]";
        }
    }
}