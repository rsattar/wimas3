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
    
    import com.aol.api.Version;
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
    import com.aol.api.wim.data.types.PresenceState;
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
    import com.aol.api.wim.transactions.AddTempBuddy;
    import com.aol.api.wim.transactions.GetMemberDirectory;
    import com.aol.api.wim.transactions.GetPermitDeny;    
    import com.aol.api.wim.transactions.GetPreference;
    import com.aol.api.wim.transactions.GetPresence;
    import com.aol.api.wim.transactions.RemoveBuddy;
    import com.aol.api.wim.transactions.ReportSPIM;
    import com.aol.api.wim.transactions.ResultLoader;
    import com.aol.api.wim.transactions.SearchMemberDirectory;
    import com.aol.api.wim.transactions.SendDataIM;
    import com.aol.api.wim.transactions.SendIM;
    import com.aol.api.wim.transactions.SendIMXML;
    import com.aol.api.wim.transactions.SetBuddyAttribute;
    import com.aol.api.wim.transactions.SetPermitDeny;
    import com.aol.api.wim.transactions.SetState;
    import com.aol.api.wim.transactions.SetStatus;
    import com.aol.api.wim.transactions.SetTyping;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.ObjectEncoding;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    
    // import mx.utils.HexEncoder;   
        
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
        * Directs clientLogin to get a long term token, suitable for storage to start sessions in the future.
        * 
        * @private
        */
        protected var _getLongTermToken:Boolean     = false;
        
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
        public var maxReconnectAttempts:uint        =   10;
        
        /**
         * This is an array of capabilities that the client wishes to receive from other users.
         */
        public var interestedCapabilities:Array     = null;

        /**
         * This is an array of capabilities that the client wishes to display to other users.
         */
        public var assertCapabilities:Array     = null;
        
        /**
         * comScore ID to include on sendIM calls.  This is used to differentitate calls from different clients.
         * If you are building a client with this API feel free to supply your own URL-safe identifier. 
         */ 
        public var comScoreId:String                = "wimas3_"+Version.NUMBER;
        
        /**
        * The IETF language tag to be used in this session, specified by RFC 4646
        */
        protected var _language:String; 
        
        /**
         * The minimum time possible to supply for a fetchEvents timeout request: 0.5 seconds
         */        
        protected static const minimumFetchTimeOutMs:Number =   500;     // 0.5 seconds
        
        /**
         * The maximum time possible to supply for a fetchEvents timeout request: 1 hour
         */     
        protected static const maximumFetchTimeOutMs:Number =   3600000; // 1 hour
        
        // Protected session variables
        /**
         * @private
         */ 
        protected var _fetchDelayTimer:Timer             =   null;

        /**
         * @private
         */
        protected var _fetchEventsTimer:Timer        =   null;        
 
        /**
         * @private
         */
        protected var _fetchEventsBaseUrl:String    =   null;

        /**
         * @private
         */
        protected var _timeToNextFetchMs:uint       =   500;

        /**
         * @private
         */
        protected var _fetchRequestTimeoutMs:uint       =   60000;

        /**
         * @private
         */
        protected var _lastFetchEventsLoader:ResultLoader  =   null;

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
        protected var _secondsToNextReconnect:uint    =   0;

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
        
        // Anonymous Session Variables - these are only set when we signOnAnonymous (like Wimzi)
        /**
         * For anonymous sessions only, this is the name that we use to show to the creator on their buddy list.
         * If it is null, the normal generic "aimguestXXXXXXXX" is shown. 
         */        
        protected var _anonymousDisplayName:String;
        /**
         * For anonymous sessions only, this is the name that represents the target of the anonymous session. 
         */        
        protected var _anonymousCreatorDisplayName:String;
        /**
         * For anonymous sessions only, this is the message the creator chose to show the user when they
         * are available for chatting. 
         */        
        protected var _anonymousWidgetAvailableMsg:String;
        /**
         * For anonymous sessions only, this is the message the creator chose to show the user when they
         * are not available for chatting.
         */        
        protected var _anonymousWidgetUnavailableMsg:String;
        /**
         * For anonymous sessions only, this is the title of the widget chosen by the creator. 
         */        
        protected var _anonymousWidgetTitle:String;
        
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
                                   logger:ILog=null, wimBaseURL:String=null, authBaseURL:String=null,
                                   language:String="en-US") {
                                       
            this._devId = developerKey;
            this._clientName = clientName;
            this._clientVersion = clientVersion;
            this._language = language;
            
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
            _evtDispatch.addEventListener(SessionEvent.SESSION_STARTING, this.doStartSession, false, 0, true);
            _evtDispatch.addEventListener(SessionEvent.EVENTS_FETCHING, this.doFetchEvents, false, 0, true);
            _evtDispatch.addEventListener(SessionEvent.SESSION_ENDING, this.doSignOff, false, 0, true);
            _evtDispatch.addEventListener(UserEvent.MY_INFO_UPDATED, this.doMyInfoUpdateResult, false, 0, true);
            
            // Fetch events retry schedule
            // TODO: Load our retry schedule externally?
            //["0":3,"5":6,"10":15,"12":30,"14":60,"18":120]
            // TODO: Find out how long host keeps a disconnected aimsid "alive" before it dumps it. We don't want to try more than that.
            reconnectSchedule = new Array();
            reconnectSchedule[0] = 3; // the first 5 times will be every 3 seconds
            reconnectSchedule[5] = 6; // the next 5 times will be every 6 seconds
            reconnectSchedule[10] = 15;
            reconnectSchedule[12] = 30;
            reconnectSchedule[14] = 60;
            reconnectSchedule[18] = 120;
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
        public function signOn(user:String, pass:String, challengeAnswer:String=null, forceCaptcha:Boolean=false, getLongTermToken:Boolean=false):void {
            
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
            this._getLongTermToken = getLongTermToken;
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
                _auth = new _authClass(this._devId, this._clientName, this._clientVersion, _logger, _authBaseURL, _language);
                _auth.addEventListener(AuthEvent.LOGIN,    onAuthSignOn, false, 0, true);
                _auth.addEventListener(AuthEvent.LOGOUT,   onAuthSignOut, false, 0, true);
                _auth.addEventListener(AuthEvent.CHALLENGE, onAuthChallenge, false, 0, true);
                _auth.addEventListener(AuthEvent.ERROR,     onAuthError, false, 0, true);
                _auth.addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
            }
            
            _auth.signOn(this._username, this._password, this._challengeAnswer, !this._challengeAnswer ? _forceCaptcha : false, this._getLongTermToken);
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
                var url:String = evt.challengeUrl + "?devId="+_devId+"&context="+context+"&language="+_language;
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
        private function doStartSession(evt:SessionEvent):void {
            
            if(_isAnonymousSession)
            {
                doStartSessionAnonymous(evt);
                return;
            }
            
            var method:String = "aim/startSession";
            var queryString:String = "";
            var sig_sha256:String = "";

            // Set up params in alphabetical order
            queryString += "a="+_token.a;
            if(assertCapabilities)
               queryString += "&assertCaps=" + encodeStrPart(assertCapabilities.join(","));            
            queryString += "&clientName="+encodeStrPart(_clientName);
            queryString += "&clientVersion="+encodeStrPart(_clientVersion);
            queryString += "&events="+encodeStrPart("myInfo,presence,buddylist,typing,im,dataIM,offlineIM,userAddedToBuddyList");
            queryString += "&f=amf3";
            if(interestedCapabilities) 
                queryString += "&interestCaps=" + encodeStrPart(interestedCapabilities.join(","));
            queryString += "&k="+_devId;
            
            var now:Number = new Date().getTime() / 1000;           
            _logger.debug("Host Time: {0}, Now: {1}", _token.hostTime, now);
            queryString += "&ts="+ int(_token.hostTime + Math.floor(now - _token.clientTime));
            
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
                _logger.debug("raw myInfo data: {0}",response.data.myInfo);
                if(_isAnonymousSession)
                {
                    _anonymousCreatorDisplayName = response.data.creatorDisplayName;
                    _anonymousWidgetAvailableMsg = response.data.greetingMsg;
                    _anonymousWidgetUnavailableMsg = response.data.offlineMsg;
                    _anonymousWidgetTitle = response.data.widgetTitle;
                }
                startWithSessionId(response.data.aimsid, response.data.fetchBaseURL, _parser.parseUser(response.data.myInfo));
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
         * Start a session with an existing session ID.  This API allows callers to supply there own session ID.  Normally,
         * Session.signOn generates the session ID using an authentication token from clientLogin.  However, there are
         * other ways to get an authentication token.  In particular, there is an Open Auth call called getToken which
         * returns an auth token if the user is already logged in to an AOL site.  This token can be used in a JavaScript
         * call to startSession.  The results of that startSession call can be passed to this API.  Then wimas3 will 
         * take over the session using the AMF3 format.
         * 
         * @see http://dev.aol.com/authentication_for_browser_based_apps#getToken
         * @see http://dev.aol.com/aim/web/serverapi_reference#startSession
         */
        public function startWithSessionId(sessionId:String, baseUrl:String, myCurrentInfo:User):void {
            _fetchEventsBaseUrl = baseUrl;
            _aimsid = sessionId; 
            _logger.debug("Session Started");
            
            // Set the _myInfo without dispatching a MY_INFO_UPDATED.  It's weird to 
            // to not have this set when the STATE_CHANGED is called because someone might
            // want to inspect the _myInfo when the state changes.  However, it might also be
            // weird for MY_INFO_UPDATED to fire before STATE_CHANGED so we wait to call the 
            // setMyInfo function.
            _myInfo = myCurrentInfo;
            // this will dispatch a STATE_CHANGED event
            this.sessionState = SessionState.ONLINE;
            // this will dipatch a MY_INFO_UPDATED event
            this.setMyInfo(myCurrentInfo);           
            // start the fetchevents loop  
            if(_autoFetchEvents) {
                if (!_fetchEventsTimer) {
                    _fetchEventsTimer = new Timer(0, 1);
                    _fetchEventsTimer.addEventListener(TimerEvent.TIMER_COMPLETE, scheduleNextFetchEvents, false, 0, true);
                }
                fetchEvents();
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
            _anonymousDisplayName = displayName;
            
            // Set our state to STARTING
            this.sessionState = SessionState.STARTING;
            // Dispatch a capturable SESSION_STARTING event
            // TODO: Rename SESSION_STARTING to SESSION_SIGNING_ON to avoid confusion with SessionState.STARTING?
            dispatchEvent(new SessionEvent(SessionEvent.SESSION_STARTING, this, true, true));
        }
        
        protected function doStartSessionAnonymous(evt:SessionEvent):void
        {
            var method:String = "aim/startSession";
            var queryString:String = "anonymous=1&k=" + this.devId + "&f=amf3&events=presence,im";
            if(_anonymousDisplayName)
            {
                queryString += "&friendly="+_anonymousDisplayName;
            }
            _logger.debug("StartAnonymousSessionQuery: "+queryString);
            sendRequest(apiBaseURL + method + "?"+queryString, startSessionResponse);
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
            stopFetchTimers();
            if(_lastFetchEventsLoader)
            {
                clearLoader();
            }
            _numFetchRetries = 0;
            this.sessionState = SessionState.OFFLINE;
            if(_myInfo != null)
            {
                _myInfo.state = PresenceState.OFFLINE;
                this.setMyInfo(_myInfo);
                _myInfo = null;
            }
        }
        
        /**
         * This causes all the timers related to scheduling the next fetch events, or delaying to launch
         * another fetchEvents to stop immediately. 
         * 
         */        
        protected function stopFetchTimers():void
        {
            // Stop our fetch events timer
            if (_fetchEventsTimer && _fetchEventsTimer.running) {
                _fetchEventsTimer.stop();
                //_logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> STOPPED FETCH EVENTS TIMER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
            }
            // Stop our fetch events delay timer
            if(_fetchDelayTimer && _fetchDelayTimer.running) {
                _fetchDelayTimer.stop();
                //_logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> STOPPED FETCH EVENTS DELAY TIMER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
            }
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
                // invokes doFetchEvents
                dispatchEvent(new SessionEvent(SessionEvent.EVENTS_FETCHING, this, true, true));
            }
        }
        
        /**
         * Does the actual <code>fetchEvents</code> request.
         * 
         * @private
         */
        protected function doFetchEvents(evt:SessionEvent):void {
            
            var timeout:uint = _fetchRequestTimeoutMs;
            
            if (this._state == SessionState.RECONNECTING) {
                if((_numFetchRetries < maxReconnectAttempts) || (maxReconnectAttempts == -1))
                {
                    if(reconnectSchedule[_numFetchRetries]) {
                        timeout = (reconnectSchedule[_numFetchRetries]) * 1000;
                    } else {
                        timeout = minimumFetchTimeOutMs;
                    }
                    _numFetchRetries++;
                    _logger.debug("doFetchEvents: Attempting to reconnect with timeout " + timeout);                    
                } else {
                    // We're out of retries.
                    _logger.debug("doFetchEvents: Max number of retries reached ("+maxReconnectAttempts+", retries="+_numFetchRetries+"), abandoning reconnect");
                    this.sessionState = SessionState.DISCONNECTED; 
                }
            }            
            
            if (this.sessionState != SessionState.DISCONNECTED) {
                var query:String = this._fetchEventsBaseUrl + "&f=amf3&timeout=" + timeout + "&cacheDefeat=" + new Date().time;
                    
                _logger.debug("FetchEventsQuery: "+query);
                
                _lastFetchEventsQuery = query;
                // Manual sending of fetch events request
                var theRequest:URLRequest = new URLRequest(query);
                                
                // This makes certain that we don't start a new fetch until after we've gotten a timeout from the loader.                    
                _fetchEventsTimer.delay = timeout + 11000; 
                _fetchEventsTimer.repeatCount = 1;                               
                                
                var loader:ResultLoader = createURLLoader();
                loader.maxTimeoutMs = 0;
                loader.addEventListener(Event.COMPLETE, fetchEventsResponse, false, 0, true);
                loader.addEventListener(IOErrorEvent.IO_ERROR, handleFetchEventsIOError, false, 0, true);
                loader.dataFormat = URLLoaderDataFormat.BINARY;
                
                _lastFetchEventsLoader = loader;
                
                loader.load(theRequest);
                _fetchEventsTimer.start();
                
            }
        }
        
        /**
         * Checks any returned HTTP status code for errors, such as server-side timeouts, etc. 
         * @param evt
         * 
         * @private
         */        
        protected function handleFetchEventsIOError(evt:IOErrorEvent):void {
            _logger.error("Fetch events IOError: "+evt.text);
            
            
             //Respond to event here
             // status code 2032 is stream error - socket could not be opened
             // that should happen when we are
             // 1 - lost connectivity
             // 2 - came back from standby?
            
            clearLoader();

            // If we weren't online or reconnecting, then just switch to OFFLINE (no harm no foul!)
            if(sessionState != SessionState.ONLINE && _state != SessionState.RECONNECTING) {
                // we went from !online|reconnecting --> error, so just go back to offline
                sessionState = SessionState.OFFLINE;
            }
            // If we were online when this happened, then this is the first time we have encountered an error
            else if(sessionState == SessionState.ONLINE)
            {
                // We have encountered an error from our normal mode of operation, start the reconnecting process
                if(maxReconnectAttempts == 0)
                {
                    // we don't allow reconnecting, just switch to disconnected
                    sessionState = SessionState.DISCONNECTED;
                    // Stop our fetch events timer
                    stopFetchTimers();    
                }
                else
                {
                    // switch to RECONNECTING
                    sessionState = SessionState.RECONNECTING;
                    // Now just let our normal fetchEventsTimer run out.  We can't try to connect again to the server any earlier
                    // than that last timeout we gave it.  
                }              
            }
        }
        
        /**
         * Handles the returned data from a fetchEvents request
         * 
         * @private
         */
        protected function fetchEventsResponse(evt:Event):void {
            var loader:ResultLoader = ResultLoader(evt.target);
            
            clearLoader();
                     
            var response:Object = getResponseObject(loader.data);
            
            if(response == null) {
                _logger.error("fetchEvents could not parse response");
                return;
            }
            
            var statusCode:uint = response.statusCode;
            var statusText:String = response.statusText;
            
            if(statusCode != 200) 
            {
                _logger.debug("fetchEvents response: {0} ", response);
            }
            // Since we got a correct response - we should always be stopping any existing fetchTimer
            stopFetchTimers();
            
            //var response:FetchEventsResponse = _parser.parseFetchEventsResponse(loader.data);
            if(statusCode == 200) {
                /* removing fetchEvents debug output because it is just too much :)
                _logger.debug("FetchEvents: ["+response.statusCode+"] "+response.statusDetailCode+
                             " - "+response.statusText);
                */
                // If were previously trying to reconnect, set ourselves online again
                if(_state == SessionState.RECONNECTING) {
                    _logger.debug("SUCCESSFULLY RECONNECTED! Switching back to ONLINE...");
                    _numFetchRetries = 0;
                    sessionState = SessionState.ONLINE;
                }
                
                _fetchEventsBaseUrl= response.data.fetchBaseURL;
                _timeToNextFetchMs = response.data.timeToNextFetch;
                
                dispatchEvent(new SessionEvent(SessionEvent.EVENTS_FETCHED, this, true, true));
                
                try {
                    _logger.debug("events array: {0}", response.data.events);
                    handleAIMEvents(response.data.events as Array);
                } catch (error:Error) {
                    _logger.error("error processing events: " + error.toString());
                }
                
                _logger.debug("fetchEvents request closed with a 200, scheduling next one");
                scheduleNextFetchEvents();
                
            } else if(statusCode == 460) {
                // We have an invalid aimsid (perhaps because we were disconnected for a while and during a success reconnect we
                // get told that our session has expired.
                
                // Attempt start the session again (with the same auth token that we have)
                
                // FIXME: If we get a 460 (invalid aimsid) during reconnecting, should we attempt to restart the session with the cached auth token, or just switch to disconnected?
                
                //_logger.debug("Invalid aimsid during fetchEvents, attempting startSession");
                //startSignedSession(this._token, this._sessionKey);
                
            
                _logger.debug("Received a 460 error (invalid aimsid) during fetch events, switching to DISCONNECTED");
                this.sessionState = SessionState.DISCONNECTED;
                
            } else {
                _logger.error("Error during fetchEvents!!");
            }
        }
        
        protected function clearLoader():void
        {
            if(!_lastFetchEventsLoader) return;
            _lastFetchEventsLoader.removeEventListener(Event.COMPLETE, fetchEventsResponse);
            _lastFetchEventsLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleFetchEventsIOError);
            _lastFetchEventsLoader.currentRequest = null;
            _lastFetchEventsLoader.close();            
            _lastFetchEventsLoader = null;
        }
        
        protected function scheduleNextFetchEvents(event:TimerEvent = null):void
        {         
            stopFetchTimers();

            // We have to check if we are online in case we sent an endSession event
            // and/or got knocked offline.
            if(_state == SessionState.ONLINE || _state == SessionState.RECONNECTING) {
             
                if (event) {
                    _logger.debug("scheduling next fetch in {0}ms as a result of a timeout", _timeToNextFetchMs);
                    if(_state != SessionState.RECONNECTING)
                    {
                        // switch to reconnecting mode. This is reached basically if we got no report of an error, yet we still timed out
                        // this is common in Firefox 2, as it never reports to Flash of an IO Error
                        sessionState = SessionState.RECONNECTING;
                    }
                }               
             
                // We are still online, so go attempt another fetchEvents.
                if(this._autoFetchEvents) {
                    if(!_fetchDelayTimer) {
                        this._fetchDelayTimer = new Timer(_timeToNextFetchMs, 1); 
                        this._fetchDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fetchEvents, false, 0, true);
                    }
                    this._fetchDelayTimer.repeatCount = 1;
                    this._fetchDelayTimer.delay = _timeToNextFetchMs;
                    this._fetchDelayTimer.start(); 
                }
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
            // TODO: Need to complete, once we receive a correctly formatted fetchEvents response
            
            if ((evts != null) && (evts.length > 0)) { 
                var evt:Object; 
                for(var i:int=0; i<evts.length; i++) {
                    evt = evts[i];
                    var type:String = evt.type;
                    var eventData:Object = evt.eventData;

                    switch(type) {
                        
                        case FetchEventType.MY_INFO: 
                            _logger.debug("Dispatching MY_INFO_UPDATED");
                            // TODO: Create a UserEvent to represent MY_INFO and PRESENCE events?
                            var myNewInfo:User = _parser.parseUser(eventData);
                            _logger.debug("raw myInfo data: {0}",eventData);
                            _logger.debug("new myInfo data: {0}", myNewInfo);
                            this.setMyInfo(myNewInfo);
                            //dispatchEvent(new UserEvent(UserEvent.MY_INFO_UPDATED, myNewInfo, true, true));
                            break;
                      
                        case FetchEventType.PRESENCE: 
                            _logger.debug("Dispatching BUDDY_PRESENCE_UPDATED");
                            // TODO: Create a UserEvent to represent MY_INFO and PRESENCE events?
                            var buddy:User = _parser.parseUser(eventData);
                            dispatchEvent(new UserEvent(UserEvent.BUDDY_PRESENCE_UPDATED, buddy, true, true));
                            break;
                        
                        case FetchEventType.BUDDY_LIST: 
                            _logger.debug("Dispatching LIST_RECEIVED");
                            // Dispatch a BuddyListEvent.LIST_RECEIVED
                            var bl:BuddyList = _parser.parseBuddyList(eventData);
                            bl.owner = _myInfo;
                            dispatchEvent(new BuddyListEvent(BuddyListEvent.LIST_RECEIVED,null,null,bl,true,true));
                            break;
                       
                        case FetchEventType.TYPING:
                            _logger.debug("Dispatching TYPING_STATUS_RECEIVED");
                            // Dispatch a new TypingEvent?
                            var typing:String = eventData.typingStatus;
                            var sourceId:String = eventData.aimId;
                            dispatchEvent(new TypingEvent(TypingEvent.TYPING_STATUS_RECEIVED, typing, sourceId, true, true));
                            break;
                        
                        case FetchEventType.IM:
                            _logger.debug("Dispatching IM");
                            var im:IM = _parser.parseIM(eventData);
                            dispatchEvent(new IMEvent(IMEvent.IM_RECEIVED, im, true, true));
                            break;
                        
                        case FetchEventType.DATA_IM:
                            _logger.debug("TODO: Dispatch DATA_IM");
                            var dataIM:DataIM = _parser.parseDataIM(eventData);
                            dispatchEvent(new DataIMEvent(DataIMEvent.DATA_IM_RECEIVED, dataIM, true, true));
                            break;
                        
                        case FetchEventType.END_SESSION:
                            _logger.debug("Received END_SESSION");
                            clearSession();
                            break;
                        
                        case FetchEventType.OFFLINE_IM:
                            // Dispatch a new IMEvent.OFFLINE_IM_RECEIVED ? or just dispatch IM_RECEIVED?
                            // The IM object contains the context for whether it's offline or not
                            var offIM:IM = _parser.parseIM(eventData, _myInfo, true);
                            dispatchEvent(new IMEvent(IMEvent.IM_RECEIVED, offIM, true, true));
                            break;
                        
                        case FetchEventType.ADDED_TO_LIST:
                            var aimId:String = eventData.requester;
                            var message:String = (eventData.msg) ? eventData.msg : "";
                            var authRequested:Boolean = eventData.authRequested;
                                                        
                            if(aimId) {
                                dispatchEvent(new AddedToBuddyListEvent(AddedToBuddyListEvent.ADDED_TO_LIST, aimId, message, authRequested, true, true));
                            } else {
                                _logger.warn("Received '{0}' event, but there is no aimId", type);
                            }
                            break;
                        
                        default:
                            _logger.warn("Received an unknown type of event, type is: "+type);
                            break;
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
            _myInfo.statusMessage = statusMsg;
            
            var transaction:SetStatus;
            if (!_transactions.setStatus)
            {
                transaction = new SetStatus(this);
                _transactions.setStatus = transaction;
            } else {
                transaction = SetStatus(_transactions.setStatus);
            }
            transaction.run(_myInfo);
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
        
        /**
        * Performs a search for buddies using the ICQ directory. You may search by many different kinds
        * of parameters, and in any combination. The search will be performed as an AND of all the criteria.
        * All search values must be strings. In the case of booleans, please send in strings of the form "true" or "false".
        * 
        * Available search keys include:
        * keyword
        * validatedEmail
        * email
        * firstName
        * lastName
        * friendlyName
        * language
        * website1
        * gender (unknown|male|female)
        * relationshipStatus (unknown|single|dating|longTermRelationship|engaged|married|divorced|separated|widowed|openRelationship|askMe|other)
        * online (true|false)
        * authorize (true|false) [does the user require authorization before adding to your buddy list?]
        * photo (true|false) [does the user have a photo?]
        * matchGender (unknown|male|female) [gender of person that the user is interested in]
        * phone
        * interestText [user's interests]
        * interestCode (unknown|50s|60s|70s|80s|adults|art|astronomy|audioAndVisual|business|businessServices|cars|celebrityFans|clothing|collections|computers|culture|ecology|entertainment|financeAndCorporate|fitness|healthAndBeauty|hobbies|homeAutomation|householdProducts|games|government|icqHelp|internet|lifestyle|mailOrderCatalog|media|moviesAndTv|music|mystics|newsAndMedia|outdoors|parenting|parties|petsAndAnimals|politics|romance|publishing|religion|retailStores|science|scienceFiction|skills|socialScience|spiritual|space|sportingAndAthletic|sports|travel|vehicles|webDesign|women|other|elementarySchool|highSchool|college|university|military|pastWorkPlace|pastOrganization|otherPast|alumniOrg|charityOrg|clubSocialOrg|communityOrg|culturalOrg|fanClubs|fraternitySorority|hobbyistsOrg|internationalOrg|natureEnvironmentOrg|professionalOrg|scientificTechnicalOrg|selfImprovementGroup|spiritualReligiousOrg|sportsOrg|supportOrg|tradeAndBusinessOrg|union|voluntaryOrg|otherGroup)
        * Age [can be a range e.g. "20-30"]
        * homeAddress.street
        * homeAddress.city
        * homeAddress.state
        * homeAddress.zip
        * homeAddress.country [2-letter code]
        * originAddress.street
        * originAddress.city
        * originAddress.state
        * originAddress.zip
        * originAddress.country [2-letter code]
        * loginEmailAddr [email address that the user can use to login]
        */
        public function searchMemberDirectory(searchTerms:Object):void
        {
            var transaction:SearchMemberDirectory;
            if (!_transactions.memberDirectorySearch)
            {
                transaction = new SearchMemberDirectory(this, _language);
                _transactions.memberDirectorySearch = transaction;
            } else {
                transaction = SearchMemberDirectory(_transactions.memberDirectorySearch);
            }
            transaction.run(searchTerms);
        }
        
        /**
         * Get profile information for a single user.
         * 
         * @param imId The identifier of the user in question.
         * @param level How munch information to return.  See MemberDirectoryInfoLevelType.
         * @param context Used to pass application data from the caller to a listener.
         * 
         * @see com.aol.api.wim.data.types.MemberDirectoryInfoLevelType
         * @see com.aol.api.wim.events.MemberDirectoryEvent
         */
        public function getMemberDirectory(imId:String, level:String="full", context:Object=null):void
        {
            var transaction:GetMemberDirectory;
            if (!_transactions.getMemberDirectory)
            {
                transaction = new GetMemberDirectory(this, _language);
                _transactions.getMemberDirectory = transaction;
            } else {
                transaction = GetMemberDirectory(_transactions.getMemberDirectory);
            }
            transaction.run(imId, level, context);           
        }
        // IM Methods //////////////////////////////////////////////////////////////
        // *** See design notes above

        /**
         * Deprecated. Use sendIM instead. Sends an IM to a screenname
         * @param buddyScreenName The screenName of the buddy being IMed.
         * @param msg The message to be sent. This message is <code>escape()</code>ed before sending.
         * @param isAutoResponse Whether or not this message should be marked as an auto-response.
         * @param attempOffline If <code>true</code>, the message will be scheduled for offline delivery if needed.
         * 
         * @see com.aol.api.wim.events.IMEvent#IM_SENDING
         * @see com.aol.api.wim.events.IMEvent#IM_SEND_RESULT
         *  
         */
        public function sendIMToBuddy(buddyScreenName:String, msg:String, isAutoResponse:Boolean=false, attemptOffline:Boolean=false):void {
            sendIM(buddyScreenName, msg, isAutoResponse, attemptOffline);
        }        

        /**
         * Deprecated. Please use sendDataIM instead. Sends a data IM.
         *  
         * @param buddyScreenName The buddy to send the data IM to
         * @param type            The type of message. See <pre>DataIMType</pre>
         * @param data            The data to send
         * @param capability      The UUID of the capability for this data
         * @param base64Encoded   Whether or not the data is base64 encoded.
         * @param isAutoResponse  Whether or not this is an autorespnse.
         * @param inviteMsg       For the invite message type, and optional invite message can be included.
         */
        public function sendDataIMToBuddy(buddyScreenName:String, type:String, data:String, capability:String, base64Encoded:Boolean=false, isAutoResponse:Boolean=false, inviteMsg:String=null):void {
            sendDataIM(buddyScreenName, type, data, capability, base64Encoded, isAutoResponse, inviteMsg);
        }

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
        public function sendIM(buddyScreenName:String, msg:String, 
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
         * Sends an IM to a buddy, with an XML response so we can 
         * get counted by ComScore. O_o
         */
        public function sendIMXML(buddyScreenName:String, msg:String, 
                                      isAutoResponse:Boolean=false, attemptOffline:Boolean=false):void {
            var transaction:SendIMXML;
            if(!_transactions.sendIMXML) {
               transaction = new SendIMXML(this);
               _transactions.sendIMXML = transaction;
            } else {
                transaction = _transactions.sendIMXML as SendIMXML;
            }
            transaction.run(buddyScreenName, msg, isAutoResponse, attemptOffline);
        }
        
        /**
         * Sends a data IM.
         *  
         * @param buddyScreenName The buddy to send the data IM to
         * @param type            The type of message. See <pre>DataIMType</pre>
         * @param data            The data to send
         * @param capability      The UUID of the capability for this data
         * @param base64Encoded   Whether or not the data is base64 encoded.
         * @param isAutoResponse  Whether or not this is an autorespnse.
         * @param inviteMsg       For the invite message type, and optional invite message can be included.
         * 
         * @see com.aol.api.wim.events.DataIMEvent
         * @see com.aol.api.wim.data.types.DataIMType
         */
        public function sendDataIM(buddyScreenName:String, type:String, data:String, capability:String, base64Encoded:Boolean=false, 
                                   isAutoResponse:Boolean=false, inviteMsg:String=null):void {
             // sendDataIM
            var transaction:SendDataIM;
            if (!_transactions.sendDataIM) {
               transaction = new SendDataIM(this);
               _transactions.sendDataIM = transaction;
            } else {
               transaction = _transactions.sendDataIM as SendDataIM;
            }
            transaction.run(buddyScreenName, data, type, capability, inviteMsg, isAutoResponse, base64Encoded); 
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
        
        /**
         * Adds a buddy to the buddy list.  
         * 
         * @param buddyName The screenname of the buddy to add.
         * @param groupName The gruop to add the buddy to.
         * @private
         * @param authorizationMsg Only applicable for ICQ users
         * 
         */
        public function addBuddy(buddyName:String, groupName:String, authorizationMsg:String=null, preAuthorized:Boolean=false):void {
            var transaction:AddBuddy;
            if(!_transactions.addBuddy) {
               transaction = new AddBuddy(this);
               _transactions.addBuddy = transaction;
            } else {
                transaction = _transactions.addBuddy as AddBuddy;
            }
            transaction.run(buddyName, groupName, authorizationMsg, preAuthorized);
        }
        
        /**
         * Adds temporary buddies so presence updates can be received for users 
         * not on the buddy list. This call does NOT add users to the buddy list.
         * Temp buddies are removed once the session ends.
         *
         * @param buddyNames Array of aimids to add as temp buddies.
         */
        public function addTempBuddy(buddyNames:Array):void {
            var transaction:AddTempBuddy;
            if(!_transactions.addTempBuddy) {
                transaction = new AddTempBuddy(this);
                _transactions.addTempBuddy = transaction;
            } else {
                transaction = _transactions.addTempBuddy as AddTempBuddy;
            }
            transaction.run(buddyNames);
        }
        
        /**
         * Allows for the setting of various buddy attributes. The attributes are 
         * passed in as an object which properties that represent the attributes which 
         * are to be set. The following properties are allowed:
         *  - friendly: the friendly name to store for the buddy
         * 
         * There will be no event fired after this call is made. However, if it is successful, 
         * a new buddy list event will fire with the updated information.
         *   
         * @param buddyName     The aimid of the buddy whose attributes we are setting.
         * @param attributes    An object with properties representing the attributes and their values.
         * 
         */
        public function setBuddyAttribute(buddyName:String, attributes:Object):void {
            var transaction:SetBuddyAttribute;
            if(!_transactions.setBuddyAttribute) {
                transaction = new SetBuddyAttribute(this);
                _transactions.setBuddyAttribute = transaction;
            } else {
                transaction = _transactions.setBuddyAttribute as SetBuddyAttribute;
            }
            transaction.run(buddyName, attributes);
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
        
        public function reportSPIM(buddyName:String, type:String="spim", event:String="user", comment:String=null):void
        {
            var transaction:ReportSPIM;
            if(!_transactions.reportSPIM) {
                transaction = new ReportSPIM(this);
                _transactions.reportSPIM = transaction;
            } else {
                transaction = _transactions.reportSPIM as ReportSPIM;
            }
            
            // Enforce 900 byte limit.
            while (countBytes(comment) > 900)
            {
                comment = comment.substr(0, comment.length-1);    
            }             
            
            transaction.run(buddyName, type, event, comment);
        }
        
        /**
         * Fetches the user's Permit/Deny lists and settings.
         */
         public function getPermitDeny():void
         {
            var transaction:GetPermitDeny;
            if(!_transactions.getPermitDeny) {
                transaction = new GetPermitDeny(this);
                _transactions.getPermitDeny = transaction;
            } else {
                transaction = _transactions.getPermitDeny as GetPermitDeny;
            }
            transaction.run();             
         }  
        
        /**
         * Takes in an object that represents all the parameters for the call. Allowed properties on the 
         * object are as follows:
         * 
         * pdAllow : Array of aimIds to allow
         * pdBlock : Array of aimIds to block
         * pdIgnore : Array of aimIds to ignore
         * pdAllowRemove : Array of aimIds to remove from the allow list
         * pdBlockRemove : Array of aimIds to remove from the block list
         * pdIgnoreRemove : Array of aimIds to remove from the ignore list
         * pdMode : { permitAll | permitSome | permitOnList | denySome | denyAll } (see <pre>PermitDenyMode</pre>)
         * 
         * @param attributes An object with one or more of the mentioned properties.
         * 
         */

        public function setPermitDeny(attributes:Object):void
        {
            var transaction:SetPermitDeny;
            if(!_transactions.setPermitDeny) {
                transaction = new SetPermitDeny(this);
                _transactions.setPermitDeny = transaction;
            } else {
                transaction = _transactions.setPermitDeny as SetPermitDeny;
            }
            transaction.run(attributes);
        }
        
        /**
         * Sets the state of the logged in user. 
         * 
         * @param state A string representing the state. Must be one of PresenceState constants.
         *              You cannot use PresenceState.OFFLINE or PresenceState.MOBILE
         * @param optionalAwayMessage If state == PresenceState.AWAY, this away message is set as the custom away message
         * 
         * @see com.aol.api.wim.events.UserEvent#PRESENCE_STATE_UPDATING
         * @see com.aol.api.wim.events.UserEvent#MY_INFO_UPDATED  
         */         
        public function setState(state:String, optionalAwayMessage:String=null):void {
            var transaction:SetState;
            if(!_transactions.setState) {
               transaction = new SetState(this);
               _transactions.setState = transaction;
            } else {
                transaction = _transactions.setState as SetState;
            }
            var newMyInfo:User = _myInfo;
            newMyInfo.state = state;
            if(state == PresenceState.AWAY && optionalAwayMessage)
            {
                newMyInfo.awayMessage = optionalAwayMessage;
            }
            transaction.run(newMyInfo);
        }
        
        /**
         * This is used for anonymous sessions only. It makes a special "setState" call which sets a "friendly"
         * parameter name to our desired display name. Like other setState calls, this will trigger a MY_INFO_UPDATED event 
         * @param name
         * 
         */        
        public function setAnonymousDisplayName(name:String):void
        {
            if(_isAnonymousSession && name)
            {
                _anonymousDisplayName = name;
                
                var transaction:SetState;
                if(!_transactions.setState) {
                   transaction = new SetState(this);
                   _transactions.setState = transaction;
                } else {
                    transaction = _transactions.setState as SetState;
                }
                var newMyInfo:User = _myInfo;
                newMyInfo.displayId = name;
                
                transaction.run(newMyInfo);
            }
        }
        
        /**
         * Retreive host based user preferences. If an array of strings is passed in,
         * only those preferences will be retrieved.
         * 
         * @param preferences Optional. An array of strings representing a specific list of preferences to retreive.
         * 
         */
        public function getPreference(preferences:Array=null):void {
            var transaction:GetPreference;
            if(!_transactions.getPreference) {
                transaction = new GetPreference(this);
                _transactions.getPreference = transaction;
            } else {
                transaction = _transactions.getPreference as GetPreference;
            }
            transaction.run(preferences);
        }
 
        /**
         * Listener for server response from setState calls.
         */ 
        private function doMyInfoUpdateResult(event:UserEvent):void {
           _myInfo = event.user; 
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
            
            // If we are here, we got an IO error from either ClientLogin, startSession, or endSession
            // Switch to disconnected
            this.sessionState = SessionState.DISCONNECTED;
            stopFetchTimers();
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
                if(this._state == SessionState.ONLINE)
                {
                    // Always reset our fetch retry count, whether we recovered from reconnecting or had to restart our session
                    _numFetchRetries = 0;
                }
                dispatchEvent(new SessionEvent(SessionEvent.STATE_CHANGED, this, true, true));
            }
        }
        
        /**
         * Retrieves our buddy data object.
         */
        public function get myInfo():User {
            return _myInfo;
        }
        
        /**
         * This sets our myInfo object and sends a MY_INFO_UPDATED event. This is for internal use. 
         * To change aspects of myInfo, refer to functions such as <code>setState</code> and <code>setStatusMsg</code>
         * @param info
         * 
         * @see com.aol.api.wim.events.UserEvent#MY_INFO_UPDATED
         * @see setState
         * @see setStatusMsg 
         */        
        protected function setMyInfo(me:User):void {
            //TODO: add a .equals call on the user to check and see if both user objects are the same
            _myInfo = me;
            // If we are anonymous, keep our _anonymousDisplayName up to date
            if(_isAnonymousSession)
            {
                _anonymousDisplayName = _myInfo.displayId;
            }
            // Even though this is not from the server, we synthesize a "MY_INFO" event which represents the
            // fact that myInfo has been changed
            var event:UserEvent = new UserEvent(UserEvent.MY_INFO_UPDATED, me, true, true);
            _logger.debug("about to dispatch new MY_INFO_UPDATED containing: {0}", event.user);
            dispatchEvent(event);
        }
        
        /**
         * Returns the unique username used for this session. It is retrieved from the 'myInfo' object if available. 
         * @return 
         * 
         */        
        public function get username():String {
            if(_myInfo)
            {
                return _myInfo.aimId;
            }
            else
            {
                return _username;
            }
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
        public function get fetchTimeoutMs():uint {
            return _fetchRequestTimeoutMs;
        }
        
        // Anonymous Session Getter Methods ////////////////////////////////////
        public function get anonymousCreatorDisplayName():String
        {
            return _anonymousCreatorDisplayName;
        }
        
        public function get anonymousWidgetAvailableMessage():String
        {
            return _anonymousWidgetAvailableMsg;
        }
        
        public function get anonymousWidgetUnavailableMessage():String
        {
            return _anonymousWidgetUnavailableMsg;
        }
        
        public function get anonymousWidgetTitle():String
        {
            return _anonymousWidgetTitle;
        }
        
        public function get anonymousDisplayName():String
        {
            // get from myInfo if possible
            if(_myInfo)
            {
                return _myInfo.displayId;
            }
            else
            {
                return _anonymousDisplayName;
            }
        }
        // Setter Methods ////////////////////////////////////////////////////////
        
        /**
         * Sets the maximum timeout, in milliseconds, for the fetch events request. Minimum is 500, maximum is 3600000 (1 hour)
         */
        public function set fetchTimeoutMs(timeout:uint):void {
            if(timeout < minimumFetchTimeOutMs) timeout = minimumFetchTimeOutMs;
            else if(timeout > maximumFetchTimeOutMs) timeout = maximumFetchTimeOutMs;
            
            _fetchRequestTimeoutMs = timeout;
        }
        
        // Utility functions /////////////////////////////////////////////////////
        
        /**
         * @private
         */ 
        public function getResponseObject(data:ByteArray):Object {
            
            var obj:Object = null;
            
            try {
                data.objectEncoding = ObjectEncoding.AMF3;
                data.position = 0;
                /*
                var hex:HexEncoder = new HexEncoder();
                hex.encode(data);
                _logger.debug("raw hex: " + hex.flush()); 
                data.position = 0;
                */
                obj = data.readObject();
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
        
        /**
         * Utility call to count the bytes in a string.
         */
        public static function countBytes(string:String):uint {
            var byteArray:ByteArray = new ByteArray();
            byteArray.writeUTF(string);
            byteArray.position = 0;
            return (byteArray.bytesAvailable-2);
        }
    }
}