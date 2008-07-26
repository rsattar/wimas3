package com.aol.api {
    
    import com.aol.api.wim.data.types.PresenceState;
    
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    
    
    /**
     * This class provides a way to retrieve canned responses, pretending
     * to be from a WIM server. It produces responses for both fetchEvents and other
     * WIM transactions.
     * 
     * <p>It will be built out gradually as we test 
     * @author rizwan
     * 
     */    
    public class MockServer {
        // Define the XML namespace used by open auth XML responses
        private namespace openauthNS             = "https://api.login.aol.com";
        // Ensure namespace is set (for this class) or E4X won't work.
        use namespace openauthNS;
        
        // Singleton instance
        protected static var _instance:MockServer       =   null;
        
        // Configurable Properties /////////////////////////////////////////////
        /**
         * This screenname, when used with sendIM/addBuddy/getPresence should return a buddy missing error
         */        
        public var missingScreenName:String             =   "missing";
        /**
         * This serves as the aimsid prefix. The eventual format is <aimsid>:<screenname>
         */        
        public var aimsidPrefix:String                  =   "016.0192367373.0812718315:";
        /**
         * This requireSecuridScreenName, when passed in, will cause clientLogin to return a securid challenge
         */        
        public var requireSecuridScreenName:String        =   "securidme";
        /**
         * This incorrectAuthAnswer, when passed in, will cause an 'incorrect' captcha or whatever other challenge error in clientLogin
         */        
        public var badAuthChallengeAnswer:String        =   "bad";
        /**
         * eventsToReturn can be set by the calling application to deterministically set what event(s) the next fetchEvents
         * call should return. After each fetchEvents call, this Array is cleared out.
         * 
         * <p>Supported items: "buddylist", "myinfo", "presence"</p>
         */        
        public var eventsToReturn:Array                 = [];
        /**
         * If this is true, all sendIMs are automatically returned with the message 'echoed'
         */        
        public var echoIMs:Boolean                      =   true;
        /**
         * If this is true, the next request to handleRequest returns null. It is set to false at the end of every handleRequest 
         */        
        public var forceNextRequestTimeout:Boolean      =   false;
        /**
         * If this is true, all calls (except ones that don't send aimsid) will return *********
         */        
        public var simulateInvalidAimSid:Boolean        =   false;
        /**
         * If this is true, all calls requiring authentication (or aimsid) will return *********
         */        
        public var simulateInvalidAuthToken:Boolean     =   false;
        
        protected var sendEndSessionOnNextFetch:Boolean =   false;   
        
        protected var pendingIMEvents:Array                  =   [];
        
        protected var pendingPresenceEvents:Array                  =   [];
        
        protected var helpText:String = "omg hax! \\o/<br>" +
                                        "'sendim' - have Buddy 0 send you a quote<br>" +
                                        "'go offline' - force buddy offline<br>" + 
                                        "'go away' - force buddy away<br>" + 
                                        "'go mobile' - force buddy mobile<br>" + 
                                        "'go online' - force buddy online<br>" +
                                        "'atl' - trigger added to buddy list event<br>" +
                                        "'quote' - have me send you a quote<br>" + 
                                        "'endsession' - have me sign you off remotely<br>" + 
                                        "have a nice day! ^_^  ~((()\">";
        
        // Canned Auth Objects /////////////////////////////////////////////////
        protected var authSignOnXML:XML = 
            <response xmlns="https://api.login.aol.com">
              <statusCode>200</statusCode>
              <statusText>OK</statusText>
              <data>
                <token>
                  <expiresIn>86400</expiresIn>
                  <a>%2FwEAAAAAhEhafzNhE%2F%2BGEcoPbu9k3R6KZQGQmkXT%2FVdcEFb0%2BG8V5gtx8Oz4u9GuQ2B%2BUMik19JF2oYx07KyBjHK29lPSwjYLTkEC0acploUq4k0vU3MBwgN46IjGEpc8IeaeKZ4ULxPVUGC6xNrWgm3I8e7UIvdwWoiiv6XD%2BSf%2BZ6sabXKkVqOY9X%2BvWZhHgcaW9NQQysEYobegBHALuJH</a>
                </token>
                <sessionSecret>SB4d9k2FoCWU15e3</sessionSecret>
              </data>
            </response>;
        protected var authSignOnBadPwXML:XML =
            <response xmlns="https://api.login.aol.com">
              <statusCode>
                330
              </statusCode>
              <statusText>
                Password/LoginId Required/Invalid
              </statusText>
              <statusDetailCode>
                3011
              </statusDetailCode>
              <data>
                <challenge>
                  <info>
                    Enter your password again
                  </info>
                  <context>
                    R4ZlcgD78GYAAEZf
                  </context>
                </challenge>
              </data>
            </response>;
        protected var authSignOnCaptchaXML:XML =
            <response xmlns="https://api.login.aol.com">
              <statusCode>330</statusCode>
              <statusText>Captcha Required/Invalid</statusText>
              <statusDetailCode>3015</statusDetailCode>
              <data>
                <challenge>
                  <info>Please enter word in the image</info>
                  <context>R4V5jwAAk+gAAAAA</context>
                  <url>https://api-login.tred.aol.com/auth/getCaptcha</url>
                </challenge>
              </data>
            </response>;
        protected var authSignOnSecuridXML:XML =
            <response xmlns="https://api.login.aol.com">
              <statusCode>
                330
              </statusCode>
              <statusText>
                SecurId Required/Invalid
              </statusText>
              <statusDetailCode>
                3012
              </statusDetailCode>
              <data>
                <challenge>
                  <info>
                    Please enter your Security Code
                  </info>
                  <context>
                    SH9vvwAAr1YAEsj1
                  </context>
                </challenge>
              </data>
            </response>;
        protected var authenticatedSN:String    =   "";
        
        protected var sendIMResponseXML:XML =
            <response xmlns="http://developer.aim.com/xsd/im.xsd">
                <statusCode>200</statusCode>
                <statusText>Ok</statusText>
                <requestId>%1</requestId>
                <data>
                    <pageview_candidate>web_aim_en_us_v1</pageview_candidate>
                </data>
            </response>;     
        
        // Canned Session Objects /////////////////////////////////////////
        protected var _aimsid:String;
        
        protected var fetchEventsSeqNum:int     =   0;
//        response    Object (@6c4fd09)   
//            data    Object (@6c4f971)   
//                aimsid  "017.0262305120.1367709541:redriz"  
//                fetchBaseURL    "http://172.18.252.144:9359/aim/fetchEvents?aimsid=017.0262305120.1367709541:redriz&seqNum=4"   
//                myInfo  Object (@6c4f741)   
//                    aimId   "redriz"    
//                    buddyIcon   "http://api-oscar.tred.aol.com:8000/expressions/getAsset?t=redriz&f=native&id=00052b00002b40&type=buddyIcon"    
//                    displayId   "redriz"    
//                    onlineTime  317 [0x13d] 
//                    presenceIcon    "http://o.aolcdn.com/aim/img/online.gif"    
//                    state   "online"    
//            statusCode  200 [0xc8]  
//            statusText  "Ok"   
        
        protected var buddyNumber:uint  =   0;
        
        /**
         * This object represents our session's view of the buddy. It is maintained so that
         * buddy list manipulation functions (like AddBuddY) can be tested correctly. 
         */        
        protected var _buddyList:Object =   null;
        
        protected var _numGroups:uint   =   5;
        protected var _numBuddies:uint  =   5;
        
        /**
         * This object represents our logged in user's info. It is maintained so that 
         * state/status/profile manipulation functions (like SetState) can be tested correctly
         * 
         */
        protected var _myInfo:Object    =   null;   
        protected var _lastStatusMsgSet:String;
        protected var _lastAwayMsgSet:String;     
        
        public function MockServer() {
            super();
            if(MockServer._instance) {
                trace("Cannot create an instance of MockServer! Use MockServer.getInstance() instead");
            }
        }
        
        /**
         * Used to return the singleton instance of MockServer. 
         * @return 
         * 
         */        
        public static function getInstance():MockServer {
            if(!MockServer._instance) {
                _instance = new MockServer();
            }
            return _instance;
        }
        
        /**
         * This is called for every requests from <code>MockURLLoader.load()</code> 
         * @param request
         * @return 
         * 
         */        
        public function handleRequest(request:URLRequest):* {
            if(forceNextRequestTimeout) { 
                // Pretend the server doesn't return anything
                forceNextRequestTimeout = false;
                return null; 
            }
            var paramsIndex:int = request.url.indexOf("?");
            var urlPart:String = paramsIndex >= 0 ? request.url.substring(0, paramsIndex) : request.url;
            var paramsStr:String = paramsIndex > -1 ? request.url.substring(paramsIndex+1) : null;
            // Get or parse out url variables to make it easy to inspect the query
            var vars:URLVariables = paramsStr ? new URLVariables(paramsStr) : (request.data as URLVariables);
            var transactionName:String = urlPart.substring(urlPart.indexOf("/", 10)+1); // this gives the very last word in the url.
            //if(paramsIndex > -1) {
            //    // strip out the params from the transactionName substring
            //    transactionName = transactionName.substring(0, transactionName.indexOf("?"));
            //}
            //transactionName = transactionName.toLowerCase();
            // Check for valid/invalid aimsid's etc.
            if(vars.a) {
                var authTokenValue:String = decodeURIComponent(authSignOnXML.data.token.a.text());
                if(simulateInvalidAuthToken || (vars.a != authTokenValue)) {
                    return getAuthenticationRequiredResponse();
                }
            }
            
            if(vars.aimsid) {
                if(simulateInvalidAimSid || (vars.aimsid != _aimsid)) {
                    return getInvalidAimsidResponse();
                }
            }
            
            // Go to transaction specific responses
            switch(transactionName) {
                case "auth/clientLogin":
                    return requestSignOn(vars); break;
                case "aim/startSession":
                    return requestStartSession(vars); break;
                case "aim/fetchEvents":
                    return requestFetchEvents(vars); break;
                case "aim/endSession":
                    return requestEndSession(vars); break;
                case "im/sendIM":
                    return requestSendIM(vars); break;
                case "presence/setState":
                    return requestSetState(vars); break;
                case "presence/setStatus":
                    return requestSetStatus(vars); break;
                case "presence/get":
                    return requestGetPresence(vars); break;
                case "buddylist/addBuddy":
                    return requestAddBuddy(vars); break;
                case "memberDir/search":
                    return requestSearchMemberDirectory(vars); break;
                case "memberDir/get":
                    return requestGetMemberDirectory(vars); break;                
                case "im/reportSPIM":
                    return requestReportSPIM(vars); break;
                case "im/setTyping":
                    return requestSetTyping(vars); break;
                default : 
                    trace("unhandled transaction in mock server: "+transactionName);
                    return new Object();
            }
        }
        
        // Auth-Related stuff ////////////////////////////////////////
        public function requestSignOn(vars:URLVariables):XML {
            if(vars.forceRateLimit == "yes") {
                return authSignOnCaptchaXML;
            } else if (vars.captchaWord) {
                if(vars.captchaWord == badAuthChallengeAnswer) {
                    
                }
            } else if (vars.s == requireSecuridScreenName && !vars.securid) {
                return authSignOnSecuridXML;
            
            } else if(vars.pwd == badAuthChallengeAnswer) {
                return authSignOnBadPwXML;    
            } else {
                // No challenges, just check pwd
                authenticatedSN = vars.s;
                return authSignOnXML;
            }
            return null;
        }
        
        
        // Session-Related requests //////////////////////////////////
        public function requestStartSession(vars:URLVariables):Object {
            // TODO: Check to see if one is logged in (authenticatedSN==null), and return auth error otherwise
            _aimsid = aimsidPrefix+":"+this.authenticatedSN;
            
            var startSessionSuccess:Object = {
                data : {
                    aimsid : _aimsid,
                    fetchBaseURL : "http://172.18.252.144:9359/aim/fetchEvents?aimsid="+_aimsid+"&seqNum="+this.fetchEventsSeqNum,
                    myInfo : getMyInfo()
                },
                statusCode : 200,
                statusText : "Ok"
            }
            return startSessionSuccess;
        }
        
        /**
         * Returns an eclectic bunch of events, including a buddy list, myInfo 
         * @param vars
         * @return 
         * 
         */        
        public function requestFetchEvents(vars:URLVariables):Object {
            
            if(sendEndSessionOnNextFetch) {
                sendEndSessionOnNextFetch = false;
                var endSessionAlreadyExists:Boolean = false;
                for(var i:int=0; i<eventsToReturn.length; i++) {
                    if(eventsToReturn[i] == "endSession") {
                        endSessionAlreadyExists = true;
                    }
                }
                if(!endSessionAlreadyExists) {
                    eventsToReturn.push("endSession");
                }
            }
            // TODO: Figure out how to determine which events to send back, or just send the same thing back everytime?
            // TODO: Determine how to handle long network timeout (i.e. up to 25 secs); can/should we ignore that?
            
            this.fetchEventsSeqNum++;
            var fetchEventsSuccess:Object = {
                data : {
                  events : [],
                  fetchBaseURL : "http://172.18.252.144:9359/aim/fetchEvents?aimsid="+_aimsid+"&seqNum="+this.fetchEventsSeqNum,
                  timeToNextFetch : 500  
                },
                statusCode : 200,
                statusText : "Ok"
            }
            // Inspect our eventsToReturn to determine which event(s) to return
            var evtType:String = eventsToReturn.shift();
            while(evtType != null) {
                evtType = evtType.toLowerCase();
                switch(evtType) {
                    case "buddylist":
                        // Add buddy list
                        fetchEventsSuccess.data.events.push(getBuddyList(true));
                        break;
                    case "offlineim":
                    case "im":
                        // Add any pending im events, or a dummy one if it's empty
                        if(pendingIMEvents.length == 0) {
                            fetchEventsSuccess.data.events.push(createIM(true, -1, null, (evtType == "offlineim")));
                        } else {
                            var numIMs:Number = pendingIMEvents.length;
                            for(var m:int=0; m<numIMs; m++) {
                                fetchEventsSuccess.data.events.push(pendingIMEvents.shift());
                            }
                        }
                        break;
                    case "myinfo":
                        // Add buddy list
                        fetchEventsSuccess.data.events.push(getMyInfo(true));
                        break;
                    case "presence":
                        if(pendingPresenceEvents.length == 0) 
                        {
                            // we need to show a presence request (requested by client, probably), so make one up
                            fetchEventsSuccess.data.events.push(createBuddyInfo(0, true)); // always return buddy0 for now
                        } 
                        else 
                        {
                            // As a result of some other stuff, we have some real presence events to push down
                            var numPresenceUpdates:Number = pendingPresenceEvents.length;
                            for(var n:int=0; n<numPresenceUpdates; n++)
                            {
                                fetchEventsSuccess.data.events.push(pendingPresenceEvents.shift());
                            }
                        }
                        break;
                    case "addedtolist":
                        fetchEventsSuccess.data.events.push(createAddedToList(true));// always return buddy0 for now
                        break;
                    case "endsession":
                        fetchEventsSuccess.data.events.push({ type : "sessionEnded" });
                        break;
                    default :
                        trace("Not handled fetchEvent type: "+evtType+". Make sure it is all lowercase.");
                        
                }
                // Get next evtType, if any
                evtType = eventsToReturn.shift();
            }
            
            return fetchEventsSuccess;
        }
        
        private function getBuddyList(createEvent:Boolean=false):Object {
            if(!_buddyList)
            {
                _buddyList = {
                    groups : []
                }
                var numGroups:int = _numGroups;
                var buddiesPerGroup:int = _numBuddies;
                for(var i:int=0; i<numGroups; i++) {
                    var group:Object = {
                        buddies : [],
                        name : "Group "+(i+1)
                    };
                    for(var j:int=0; j<buddiesPerGroup; j++) {
                        group.buddies.push(createBuddyInfo(j+i));
                    }
                    _buddyList.groups.push(group);
                }
            }

            if(createEvent) {
                return { eventData : _buddyList, type : "buddylist" };
            } else {
                return _buddyList;
            }
        }
        
        private function createIM(createEvent:Boolean=false, sourceBuddyIndex:int=-1, msg:String=null, isOffline:Boolean=false):Object {
            if(isNaN(sourceBuddyIndex) || sourceBuddyIndex == -1) {
                sourceBuddyIndex = 0;
            }
            if(!msg) {
                msg = Quotes.quote;
            }
            var im:Object = {
                // if we are an offline message, this will create only an aimId
                message : msg,
                timestamp : int(new Date().getTime()/1000) // Timestamp is in *seconds* since epoch, not milliseconds
            };
            var buddyInfo:Object = createBuddyInfo(sourceBuddyIndex, false);
            if(!isOffline)
            {
                // This is a normal IM, so include other info
                im.source = buddyInfo,
                im.autoResponse = false;
            }
            else
            {
                // Offline IMs do not have a 'source' property, just the aimId
                im.aimId = buddyInfo.aimId;
            }
            if(createEvent) {
                return { eventData : im, type : isOffline ? "offlineIM" : "im" };
            } else {
                return im;
            }
        }
        
        private function getMyInfo(createEvent:Boolean=false):Object {
            if(!_myInfo)
            {
                // Create it the first time, default to online
                _myInfo = {
                    aimId : this.authenticatedSN,
                    buddyIcon : "http://api-oscar.tred.aol.com:8000/expressions/getAsset?t="+this.authenticatedSN+"&f=native&id=00052b00002b40&type=buddyIcon",
                    displayId : this.authenticatedSN + " Name",
                    state : "online",
                    presenceIcon : "http://o.aolcdn.com/aim/img/online.gif",
                    ipCountry : "us"                        
                };
            }
            if(createEvent) {
                return { eventData : _myInfo, type : "myInfo" };
            } else {
                return _myInfo;
            }
        }
        
        
        /**
         * Used when we are creating a buddy based on an index 
         * @param optIndex
         * @param createEvent
         * @return 
         * 
         */        
        private function createBuddyInfo(optIndex:int=-1, createEvent:Boolean=false):Object {
            
            var num:int = optIndex >= 0 ? optIndex : ++buddyNumber;
            var buddy:Object = {
                aimId : "buddy"+num,
                displayId : "Buddy Name "+num,
                state : "online",
                statusMsg : "What number am I thinking of? "+num+"!"
            };
            
            if(createEvent) {
                return { eventData : buddy, type : "presence" };
            } else {
                return buddy;
            }
        }
        
        private function createAddedToList(createEvent:Boolean=false, sourceBuddyIndex:int=-1, msg:String=null):Object {
            if(sourceBuddyIndex < 0)
                sourceBuddyIndex = 0;
            if(!msg) msg = "What's going on?";
            var request:Object = { 
                requester: "buddy"+sourceBuddyIndex,
                msg: msg,
                authRequested: true
            };
            if(createEvent){
                return { eventData : request, type : "userAddedToBuddyList" };
            } else {
                return request;
            }
        }
        
        public function requestEndSession(vars:URLVariables):Object {
            /*
            response    Object (@2b883ba1)  
                data    Object (@2b883b51)  
                statusCode  200 [0xc8]  
                statusText  "Ok"    
            
            */
            sendEndSessionOnNextFetch = true;
            
            return { 
                data : new Object(), 
                statusCode : 200, 
                statusText : "Ok"
            };
        }
        
        public function requestSendIM(vars:URLVariables):Object {
            /*
                aimsid  "016.0192367373.0812718315::asfd"   
                autoResponse    "false" 
                f   "amf3"  
                message "test"  
                offlineIM   "false" 
                r   "1" 
                t   "Buddy0"    
            */
            if(vars.t == missingScreenName) {
                return {
                    statusCode: 602,
                    statusText: "Target not available",
                    requestId: vars.r
                };
            }
            // Parse "special" messages
            var msgWords:Array = (vars.message as String).split(" ");
            if(msgWords[0] == "help")
            {
                vars.t = vars.t.replace("buddy", "");
                pendingIMEvents.push(createIM(true, parseInt(vars.t), helpText));
                eventsToReturn.push("im");
            }
            else if(msgWords[0] == "quote")
            {
                vars.t = vars.t.replace("buddy", "");
                pendingIMEvents.push(createIM(true, parseInt(vars.t)));
                eventsToReturn.push("im");
            }
            else if(msgWords[0] == "sendim")
            {
                pendingIMEvents.push(createIM(true, 0));
                eventsToReturn.push("im");
            }
            else if(msgWords[0] == "atl")
            {
                eventsToReturn.push("addedtolist");
            }
            else if(msgWords[0] == "go" && msgWords.length == 2)
            {
                // we may potentially have a "go away"
                var possState:String = msgWords[1].toLowerCase();
                if(possState == "online" || possState == "away" || possState == "offline" || possState == "mobile")
                {
                    var buddy:Object = getBuddyFromBuddyList(vars.t);
                    if(buddy && buddy.state != possState)
                    {
                        
                        // Update our model
                        buddy.state = possState; // buddy is by reference, so it updates our model
                        //setBuddyInfoInBuddyList(buddy);
                        
                        // Add a pending presence event
                        var presenceEvt:Object = 
                        {
                            eventData : buddy,
                            type : "presence"
                        }
                        pendingPresenceEvents.push(presenceEvt);
                        eventsToReturn.push("presence");
                    }
                }
            }
            else if(msgWords[0] == "endsession")
            {
                requestEndSession(null);
            }
            else if(echoIMs) {
                vars.t = vars.t.replace("buddy", "");
                pendingIMEvents.push(createIM(true, parseInt(vars.t), "Echo: "+vars.message));
                eventsToReturn.push("im");
            }
            if(vars.f == "xml")
            {
                var str:String = sendIMResponseXML.toXMLString();
                return new XML(str.replace(/%1/g,vars.r));
            }
            else
            {
                return {
                    statusCode: 200,
                    statusText: "Ok",
                    requestId: vars.r
                };
            }
        }
        
        protected function requestSetState(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            // TODO: check for invalid setState request variables in mock server
            if(!_myInfo) getMyInfo(false);
            var state:String = vars.view;
            //if(state != _myInfo.state)
            {
               
                _myInfo.presenceIcon = "http://o.aolcdn.com/aim/img/"+state+".gif";
                if(state == PresenceState.AWAY)
                {
                    // Also set the away message
                    _lastAwayMsgSet = vars.away ? "<div>"+vars.away+"</div>" : null;
                    if(vars.away)
                    {
                        _myInfo.awayMsg = _lastAwayMsgSet;
                        // Our status message gets temporarily overridden by the away message
                        _myInfo.statusMsg = vars.away;
                    }
                    else
                    {
                        // we have no away msg, so we set our status message to "Away"
                        _myInfo.awayMsg = "<div>Away</div>";
                        _myInfo.statusMsg = "Away";
                    }
                }
                else if(_myInfo.awayMsg)
                {
                    // remove the awayMsg property from our object
                    delete _myInfo.awayMsg;
                    // reset the status msg, if any
                    if(_myInfo.state == PresenceState.AWAY && _myInfo.statusMsg)
                    {
                        // We are now online and were previously away, reset our statusMessage
                        if(_lastStatusMsgSet)
                        {
                            _myInfo.statusMsg = _lastStatusMsgSet;
                        }
                        else
                        {
                            delete _myInfo.statusMsg;
                        }
                    }
                }
                // Finally update our state
                _myInfo.state = state;
                
                // Add the new myinfo objec to our response
                result.data = 
                {
                    myInfo : _myInfo
                };
                // Also line up a 'myInfo' for fetchEvents
                eventsToReturn.push("myinfo");
                // Check to see if we exist in our own buddy list
                var blBuddy:Object = getBuddyFromBuddyList(_myInfo.aimId);
                if(blBuddy)
                {
                    // Update our buddy state
                    blBuddy.state = _myInfo.state;
                    if(_myInfo.awayMsg)
                    {
                        blBuddy.awayMsg = _myInfo.awayMsg;
                    }
                    else
                    {
                        delete blBuddy.awayMsg;
                    }
                    if(_myInfo.statusMsg)
                    {
                        blBuddy.statusMsg = _myInfo.statusMsg;
                    }
                    else
                    {
                        delete blBuddy.statusMsg;
                    }
                    // Add a pending presence event
                    var presenceEvt:Object = 
                    {
                        eventData : blBuddy,
                        type : "presence"
                    }
                    pendingPresenceEvents.push(presenceEvt);
                    eventsToReturn.push("presence");
                }
            }
            return result;
        }
        
        protected function requestSetStatus(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            // TODO: check for invalid setState request variables in mock server
            if(!_myInfo) getMyInfo(false);
            var status:String = vars.statusMsg;
            //if(state != _myInfo.state)
            if(status && status != "")
            {
                // valid status
                _lastStatusMsgSet = status;
                if(_myInfo.state != PresenceState.AWAY)
                {
                    _myInfo.statusMsg = status;
                }
            }
            else if(_myInfo.statusMsg)
            {
                // we need to clear the status
                _lastStatusMsgSet = null;
                if(_myInfo.state != PresenceState.AWAY)
                {
                    // we are not away (because away forces our status to be "Away"), so we can
                    // delete our current status
                    delete _myInfo.statusMsg;
                }
            }
            
            // Add the new myinfo objec to our response
            //result.data = 
            //{
            //    myInfo : _myInfo
            //};
            // Also line up a 'myInfo' for fetchEvents
            //eventsToReturn.push("myinfo");
            
            // Check to see if we exist in our own buddy list
            var blBuddy:Object = getBuddyFromBuddyList(_myInfo.aimId);
            if(blBuddy)
            {
                // update its statusMsg to match our myInfo
                if(_myInfo.statusMsg)
                {
                    blBuddy.statusMsg = _myInfo.statusMsg;
                }
                else
                {
                    delete blBuddy.statusMsg;
                }
                // Add a pending presence event
                var presenceEvt:Object = 
                {
                    eventData : blBuddy,
                    type : "presence"
                }
                pendingPresenceEvents.push(presenceEvt);
                eventsToReturn.push("presence");
            }
            return result;
        }
        
        protected function requestGetPresence(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            
            if(vars.bl == true || vars.bl == 1)
            {
                // Return buddy list
                result.data = new Object();
                result.data = _buddyList;
            }
            
            if(vars.t)
            {
                // T is the aimid, fetch from the buddylist
                var buddy:Object = getBuddyFromBuddyList(vars.t);
                
                if(buddy)
                {
                    /*
                    return {
                        statusCode: 200,
                        statusText: "Ok",
                        requestId: vars.r,
                        data : {
                            users : [ buddy ]
                        }
                    };
                    */
                    result.data = new Object();
                    result.data.users = [ buddy ];
                }
            }
            return result;
        }
        
        protected function requestAddBuddy(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            // AddBuddy always seems to return a blank 'data' object (non-null)
            result.data = {};
            // Do the add
            var buddyAimId:String = vars.buddy;
            var groupName:String = vars.group;
            if(buddyAimId && groupName)
            {
                var group:Object = getBuddyListGroup(groupName, true);
                var buddy:Object = getBuddyInGroup(buddyAimId, group, true);
                // Always push a new buddy list event
                eventsToReturn.push("buddylist");
            }
            
            return result;
        }
        
        protected function requestReportSPIM(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            return result;
        }
        
        protected function requestSetTyping(vars:URLVariables):Object
        {
            return getOKResponse(vars);
        }
        
        protected function requestSearchMemberDirectory(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            var makeRandomResult:Function = function():Object { return { profile: { aimId:"00000000", firstName:"Roger", lastName:"Tired", gender:"male", homeAddress:[ { street:"1024 Burywood Lane", city:"Reston", state:"VA", zip:"20194", country:"US" } ], friendlyName:"rogertired", website1:"www.partlyhuman.com", relationshipStatus:"single", lang1:"en", jobs:[ { title:"Code Monkey", company:"partlyhuman inc", website:"www.partlyhuman.com", department:"code monkery", industry:"technology", subIndustry:"teh internets", startDate:null, endDate:null, street:"", city:"", state:"", zip:"", country:"" } ], aboutMe:"Here's my profile", birthDate:new Date(1981,5,12).time / 1000, visitorCount:"", searchHistory:"", currentAddress:{ street:"555 Greene Ave.", city:"Brooklyn", state:"NY", zip:"11238", country:"US" }, interestedIn:["college","women","space","80s","music"], favoriteMusic:"dance", favoriteMovies:"Brazil", favoriteTv:"no", favoriteBooks:"Ender's Game", activities:"sleeping", whatILove:"sleeping", whatIHate:"sleeping", quote1:"hello", quote2:"goodbye", quote3:"um", quote4:"", highSchool:"tjhsst", highSchoolGradYear:"1999", university:"cmu", universityGradYear:"2003", customHtml:"", themeCode:"", commentId:"", codeSnippet:"", codeSnippetRaw:"", privateKey:"", originAddress:[ { street:"167 5th ave. #1", city:"Brooklyn", state:"NY", zip:"11217", country:"US" } ], lang2:"ja", lang3:"es", validatedEmail:"rogerimp@gmail.com", pendingEmail:"", emails:[ { addr:"rogerimp@gmail.com", hide:false, primary:true } ], phones:[ { phone:"703-555-5555", type:"Home" }, { phone: "703-555-5554", type: "Office" } ], education:"uneducated", studies:[ { instituteType:"", instituteName:"", degree:"", major:"", studiesYear:"" } ], interests:[ { text:"", code:"" } ], groups:[ { text:"", code:"" } ], pasts:[ { text:"", code:"" } ], anniversary:"", children:"none", religion:"agnostic", sexualOrientation:"straight", smoking:"false", height:"short", hairColor:"red", tz:"GMT-0500", online:"", partnerIds:"", photo:true, localLangCd:"", lastupdated:null, userType:"", allowEmail:true, hideLevel:"", betaFlag:"", statusLine:"", hideFlag:"", autoSms:"", validatedCellular:"" }, settings: null } }
            //dumb logic here to try to get a number from the keywords param
            var keyword:String = vars.match.replace(/keyword=/g, "");
            var nResults:int = parseInt(keyword);
            if(isNaN(nResults) || nResults==0) nResults = int(Math.random() * 10);
            if(keyword == "none") nResults=0;
            result.data = new Object();
            result.data.results = {nTotal: nResults, nSkipped: 0, nProfiles: nResults, infoArray: []};
            for (var i:int = 0; i < nResults; i++)
            {
                result.data.results.infoArray.push(makeRandomResult());
            }
            return result;
        }
        
        protected function requestGetMemberDirectory(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            var makeRandomResult:Function = function():Object { return { profile: { aimId:"00000000", firstName:"Roger", lastName:"Tired", gender:"male", homeAddress:[ { street:"1024 Burywood Lane", city:"Reston", state:"VA", zip:"20194", country:"US" } ], friendlyName:"rogertired", website1:"www.partlyhuman.com", relationshipStatus:"single", lang1:"en", jobs:[ { title:"Code Monkey", company:"partlyhuman inc", website:"www.partlyhuman.com", department:"code monkery", industry:"technology", subIndustry:"teh internets", startDate:null, endDate:null, street:"", city:"", state:"", zip:"", country:"" } ], aboutMe:"Here's my profile", birthDate:(new Date(1981,5,12).time) / 1000, visitorCount:"", searchHistory:"", currentAddress:{ street:"555 Greene Ave.", city:"Brooklyn", state:"NY", zip:"11238", country:"US" }, interestedIn:["college","women","space","80s","music"], favoriteMusic:"dance", favoriteMovies:"Brazil", favoriteTv:"no", favoriteBooks:"Ender's Game", activities:"sleeping", whatILove:"sleeping", whatIHate:"sleeping", quote1:"hello", quote2:"goodbye", quote3:"um", quote4:"", highSchool:"tjhsst", highSchoolGradYear:"1999", university:"cmu", universityGradYear:"2003", customHtml:"", themeCode:"", commentId:"", codeSnippet:"", codeSnippetRaw:"", privateKey:"", originAddress:[ { street:"167 5th ave. #1", city:"Brooklyn", state:"NY", zip:"11217", country:"US" } ], lang2:"ja", lang3:"es", validatedEmail:"rogerimp@gmail.com", pendingEmail:"", emails:[ { addr:"rogerimp@gmail.com", hide:false, primary:true } ], phones:[ { phone:"703-555-5555", type:"Home" }, { phone: "703-555-5554", type: "Office" } ], education:"uneducated", studies:[ { instituteType:"", instituteName:"", degree:"", major:"", studiesYear:"" } ], interests:[ { text:"", code:"" } ], groups:[ { text:"", code:"" } ], pasts:[ { text:"", code:"" } ], anniversary:"", children:"none", religion:"agnostic", sexualOrientation:"straight", smoking:"false", height:"short", hairColor:"red", tz:"GMT-0500", online:"", partnerIds:"", photo:true, localLangCd:"", lastupdated:null, userType:"", allowEmail:true, hideLevel:"", betaFlag:"", statusLine:"", hideFlag:"", autoSms:"", validatedCellular:"" }, settings: null } } 
            result.data = { infoArray : [] };
            result.data.infoArray.push(makeRandomResult());
            return result;
        }        
        
        protected function getBuddyFromBuddyList(buddyAimId:String):Object
        {
            for(var i:Number=0; i<_buddyList.groups.length; i++)
            {
                var group:Object = _buddyList.groups[i];
                for(var j:Number=0; j<group.buddies.length; j++)
                {
                    var tempBuddy:Object = group.buddies[j];
                    if(tempBuddy.aimId == buddyAimId)
                    {
                        return tempBuddy;
                    }
                }
            }
            return null;
        }
        
        protected function getBuddyListGroup(groupName:String, createIfNecessary:Boolean=false):Object
        {
            for(var i:Number=0; i<_buddyList.groups.length; i++)
            {
                var group:Object = _buddyList.groups[i];
                if(groupName == group.name)
                {
                    return group;
                }
            }
            // If we are here that means we didn't find a group, so let's add one
            if(createIfNecessary)
            {
                var newGroup:Object =
                {
                    buddies : [],
                    name : groupName
                }
                _buddyList.groups.push(newGroup);
                return newGroup;
            }
            return null;
        }
        
        protected function getBuddyInGroup(buddyAimId:String, group:Object, createIfNecessary:Boolean = false):Object
        {
            for(var i:Number=0; i<group.buddies.length; i++)
            {
                var tempBuddy:Object = group.buddies[i];
                if(tempBuddy.aimId == buddyAimId)
                {
                    return tempBuddy;
                }
            }
            if(createIfNecessary)
            {
                var newBuddy:Object = 
                {
                    aimId : buddyAimId,
                    state : "online"
                }
                group.buddies.push(newBuddy);
                return newBuddy;
            }
            return null;
        }
        
        // Convenience functions
        
        
        // Canned error responses
        protected function getOKResponse(vars:URLVariables = null):Object {
            var response:Object = {
                statusCode: 200,
                statusText: "Ok"
            }
            if(vars && vars.r) response.requestId = vars.r;
            return response;
        }
        
        protected function getInvalidAimsidResponse():Object {
            return { 
                statusCode : 460,
                statusText : "Invalid or missing aimsid"
            };
        }
        protected function getAuthenticationRequiredResponse():Object {
            // Currently the clientLogin server just returns 401, not even a status text
            return { 
                statusCode : 401
            };
            //statusText : "Authentication Required"
        }

    }
}

