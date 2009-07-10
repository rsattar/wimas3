package com.aol.api {
    
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.data.types.PresenceState;
    import com.aol.api.wim.data.types.UserType;
    
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.Timer;    
    
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
         * This aimId, when added, will not produce a new buddy list result (but is still added) 
         */        
        public var badAddBuddyAimId:String              =   "ghost";
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
        
        protected var pendingSentIMEvents:Array                  =   [];
        
        protected var pendingPresenceEvents:Array                  =   [];
        
        protected var helpText:String = "omg hax! \\o/<br>" +
                                        "'sendim' - have Buddy 0 send you a quote<br>" +
                                        "'go offline' - force buddy offline<br>" + 
                                        "'go away' - force buddy away<br>" + 
                                        "'go mobile' - force buddy mobile<br>" + 
                                        "'go online' - force buddy online<br>" +
                                        "'set status [msg]' - update buddy's status message<br>" +
                                        "'clear status' - clears buddy's status msg<br>" +
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
        /*
        protected var sendIMResponseXML:XML =
            <response xmlns="http://developer.aim.com/xsd/im.xsd">
                <statusCode>200</statusCode>
                <statusText>Ok</statusText>
                <requestId>%1</requestId>
                <data>
                    <pageview_candidate>web_aim_en_us_v1</pageview_candidate>
                </data>
            </response>;     
        */
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
        /**
         * This object represents our buddy attributes, 
         * normally available in Feeddog / Feedbag / whatever it's called
         */        
        protected var _buddyAttributeMap:Array = null;
        /**
         * This object represents a map of whether or not we echo IMs back for IMs
         * sent to the aimId (the key). Default is always true
         */        
        protected var _echoIMsMap:Array    =   null;
        
        protected var _numGroups:uint   =   2;
        protected var _numBuddies:uint  =   18;
        protected var _smsBalance:uint  =   3;
        protected var _includeICQUsers:Boolean  =   false;
        
        protected var _smsInfo:Object   =   {
            smsError : 1,
            smsReason : "OK",
            smsCarrierID : 8,
            smsRemainingCount : _smsBalance,
            smsMaxAsciiLength : 160,
            smsMaxUnicodeLength : 70,
            smsCarrierName : "Pelephone",
            smsCarrierUrl : "http://www.pelephone.co.il",
            smsBalanceGroup : "972" // documentation says this is supposed to be a string
        };
        
        /**
         * This object represents our logged in user's info. It is maintained so that 
         * state/status/profile manipulation functions (like SetState) can be tested correctly
         * 
         */
        protected var _myInfo:Object    =   null;
        protected var _myInfoXML:XML    =   null; 
        protected var _lastStatusMsgSet:String;
        protected var _lastAwayMsgSet:String;   
        protected var _nutsTimer:Timer;  
        
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
                case "aim/addTempBuddy":
                    return requestAddTempBuddy(vars); break;
                case "im/sendIM":
                    return requestSendIM(vars); break;
                case "preference/getPermitDeny":
                    return requestPermitDeny(vars); break;
                case "presence/setState":
                    return requestSetState(vars); break;
                case "presence/setStatus":
                    return requestSetStatus(vars); break;
                case "presence/get":
                    return requestGetPresence(vars); break;
                case "buddylist/addBuddy":
                    return requestAddBuddy(vars); break;
                case "buddylist/removeBuddy":
                    return requestRemoveBuddy(vars); break;
                case "buddylist/removeGroup":
                    return requestRemoveGroup(vars); break;
                case "buddylist/renameGroup":
                    return requestRenameGroup(vars); break;
                case "buddylist/setBuddyAttribute":
                    return requestSetBuddyAttribute(vars); break;
                case "buddylist/getBuddyAttribute":
                    return requestGetBuddyAttribute(vars); break;
                case "memberDir/search":
                    return requestSearchMemberDirectory(vars); break;
                case "memberDir/get":
                    return requestGetMemberDirectory(vars); break;                
                case "im/reportSPIM":
                    return requestReportSPIM(vars); break;
                case "im/setTyping":
                    return requestSetTyping(vars); break;
                case "aim/getSMSInfo":
                    return requestGetSMSInfo(vars); break;
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
        public function requestStartSession(vars:URLVariables):* {
            // TODO: Check to see if one is logged in (authenticatedSN==null), and return auth error otherwise
            _aimsid = aimsidPrefix+":"+this.authenticatedSN;
            sendEndSessionOnNextFetch = false;
            var info:* = getMyInfo(false, "online", vars.f == "xml");
            if(vars.f == "amf3")
            {
                var startSessionSuccess:Object = {
                    data : {
                        aimsid : _aimsid,
                        fetchBaseURL : "http://172.18.252.144:9359/aim/fetchEvents?aimsid="+_aimsid+"&seqNum="+this.fetchEventsSeqNum,
                        myInfo : info
                    },
                    statusCode : 200,
                    statusText : "Ok"
                }
                return startSessionSuccess;
            }
            else if(vars.f == "xml")
            {
                var ns:Namespace = new Namespace("http://developer.aim.com/xsd/aim.xsd");
                //default xml namespace = ns;
                var startSessionSuccessXML:XML =
                    <response xmlns="http://developer.aim.com/xsd/aim.xsd">
                      <statusCode>200</statusCode>
                      <statusText>Ok</statusText>
                      <data>
                        <aimsid>220.0700306309.1344646952:rizwantest01</aimsid>
                        <fetchBaseURL>http://205.188.213.5/aim/fetchEvents?aimsid=220.0700306309.1344646952:rizwantest01&amp;rnd=1221677127.919307</fetchBaseURL>
                      </data>
                    </response>;
                var dataNodes:XMLList = startSessionSuccessXML.ns::data;
                var dataNode:XML = dataNodes[0];
                dataNode.ns::aimsid = _aimsid;
                dataNode.ns::fetchBaseURL = "http://172.18.252.144:9359/aim/fetchEvents?aimsid="+_aimsid+"&seqNum="+this.fetchEventsSeqNum;
                dataNode.ns::myInfo = info;
                return startSessionSuccessXML;
                
            }
            else
            {
                return null;
            }
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
                    case "sentim":
                        // IM was sent
                        if(pendingSentIMEvents.length > 0)
                        {
                            var numSentIMs:Number = pendingSentIMEvents.length;
                            for(var s:int=0; s<numSentIMs; s++) {
                                fetchEventsSuccess.data.events.push(pendingSentIMEvents.shift());
                            }
                        }
                        break;
                    case "offlineim":
                    case "im":
                        // Add any pending im events, or a dummy one if it's empty
                        if(pendingIMEvents.length == 0) {
                            fetchEventsSuccess.data.events.push(createIM(true, null, null, (evtType == "offlineim")));
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
                _buddyAttributeMap = new Array();
                if(!_echoIMsMap) _echoIMsMap = new Array();
                // -------------------------------------------------------------
                var numGroups:int = _numGroups;
                var buddiesPerGroup:int = _numBuddies;
                var i:int;
                var j:int;
                var group:Object;
                for(i=0; i<numGroups-1; i++) {
                    group = {
                        buddies : [],
                        name : "Group "+(i+1)
                    };
                    for(j=0; j<buddiesPerGroup; j++) {
                        group.buddies.push(createBuddyInfo(j+i));
                    }
                    _buddyList.groups.push(group);
                }
                if(_includeICQUsers)
                {
                    // Create a group of ICQ users.
                    group = {
                        buddies : [],
                        name : "ICQ Users"
                    };
                    for(j=0; j<buddiesPerGroup; j++) {
                        group.buddies.push(createICQInfo(j+i));
                    }
                    _buddyList.groups.push(group);
                }
                // -------------------------------------------------------------


                // -------------------------------------------------------------
                /* Test simpler BL with specific buddies
                var group:Object = {
                    buddies : [],
                    name : "Wonky Group"
                };
                var duplicateBuddy:Object = {
                    aimId : "wonky",
                    state : "online"
                }
                var duplicateBuddy2:Object = {
                    aimId : "1buddy@test.com",
                    state : "online"
                }
                var duplicateBuddy3:Object = {
                    aimId : "133276",
                    state : "online"
                }
                var duplicateBuddy4:Object = {
                    aimId : "+2024135712",
                    state : "mobile"
                }
                
                group.buddies.push(duplicateBuddy);
                group.buddies.push(duplicateBuddy2);
                group.buddies.push(duplicateBuddy3);
                group.buddies.push(duplicateBuddy4);
                
                for(var i:Number = 4; i>=0; i--)
                {
                    group.buddies.push( { aimId : "0"+i, userType : "icq", state : "offline" } );
                }
                
                _buddyList.groups.push(group);
                */
                // -------------------------------------------------------------
            }

            if(createEvent) {
                return { eventData : _buddyList, type : "buddylist" };
            } else {
                return _buddyList;
            }
        }
        
        private function createIM(createEvent:Boolean=false, sourceBuddy:Object=null, msg:String=null, isOffline:Boolean=false):Object {
            var buddyInfo:Object = sourceBuddy;
            
            if(sourceBuddy == null)
            {
                buddyInfo = createBuddyInfo(0, false);
            }

            if(!msg) {
                msg = Quotes.quote;
            }
            var im:Object = {
                // if we are an offline message, this will create only an aimId
                message : msg,
                timestamp : int(new Date().getTime()/1000) // Timestamp is in *seconds* since epoch, not milliseconds
            };
            //buddyInfo = createBuddyInfo(sourceBuddyIndex, false);
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
        
        private function createSentIM(createEvent:Boolean=false, destBuddy:Object=null, msg:String=null):Object {
            if(!destBuddy)
            {
                destBuddy = getBuddyFromBuddyList("buddy0");
            }
            if(!msg)
            {
                msg = Quotes.quote;
            }
            var im:Object = {
                // if we are an offline message, this will create only an aimId
                message : msg,
                timestamp : int(new Date().getTime()/1000) // Timestamp is in *seconds* since epoch, not milliseconds
            };
            im.dest = destBuddy;
            if(createEvent) {
                return { eventData : im, type : "sentIM" };
            } else {
                return im;
            }
        }
        
        private function getMyInfo(createEvent:Boolean=false,onlineState:String="online", inXML:Boolean=false):* {
            if(!_myInfo)
            {
                // Create it the first time, default to online
                _myInfo = {
                    aimId : this.authenticatedSN,
                    buddyIcon : "http://api-oscar.tred.aol.com:8000/expressions/getAsset?t="+this.authenticatedSN+"&f=native&id=00052b00002b40&type=buddyIcon",
                    displayId : this.authenticatedSN + " Name",
                    state : onlineState,
                    presenceIcon : "http://o.aolcdn.com/aim/img/online.gif",
                    ipCountry : "us"                        
                };
            }
            var ns:Namespace = new Namespace("http://developer.aim.com/xsd/aim.xsd");
            //default xml namespace = ns;
            if(inXML && !_myInfoXML)
            {
                _myInfoXML = <myInfo />;
                _myInfoXML.ns::aimId = _myInfo.aimId;
                _myInfoXML.ns::buddyIcon = _myInfo.buddyIcon;
                _myInfoXML.ns::displayId = _myInfo.displayId;
                _myInfoXML.ns::state = _myInfo.state;
                _myInfoXML.ns::presenceIcon = _myInfo.presenceIcon;
                _myInfoXML.ns::ipCountry = _myInfo.ipCountry;
            }
            if(createEvent) {
                if(!inXML)
                {
                    return { eventData : _myInfo, type : "myInfo" };   
                }
                else
                {
                    var eventXML:XML = <event/>
                    eventXML.ns::type = "myInfo";
                    eventXML.ns::eventData = _myInfoXML;
                    return eventXML;
                }
            } else {
                return inXML ? _myInfoXML : _myInfo;
            }
        }
        
        private function createICQInfo(optIndex:int=-1, createEvent:Boolean=false):Object {
            
            var num:int = optIndex >= 0 ? optIndex : ++buddyNumber;
            var buddy:Object = {
                aimId : num+"0000000",
                state : "online", 
                statusMsg : "What number am I thinking of? "+num+"!",
                userType : "icq"
            };                      
            
            if((num%2)==0)
            {
                var attribs:Object = new Object();
                if((num%4)==0) attribs.smsNumber = "+17035551234";
                attribs.friendly = attribs.smsNumber ? "Buddy Friendly Name with SMS "+num : "Buddy Friendly Name "+num;
                // Add a friendly name
                buddy.friendly = attribs.friendly;
                
                // Store attributes into map
                _buddyAttributeMap[buddy.aimId] = attribs;
            }
            
            if(createEvent) {
                return { eventData : buddy, type : "presence" };
            } else {
                return buddy;
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
                displayId : "Buddy "+num,
                state : "online", 
                statusMsg : "http://www.google.com/search?&q=buddy+"+num,//"What number am I thinking of? "+num+"!",
                buddyIcon : "http://api.oscar.aol.com/expressions/get?f=redirect&t="+("buddy"+num)+"&type=buddyIcon",
                userType : "aim"
            };
            
            // Default echoes to true
            if(_echoIMsMap[buddy.aimId] == undefined)
            {
                _echoIMsMap[buddy.aimId] = true;
            }
            
            if((num%2)==0)
            {
                var attribs:Object = new Object();
                if((num%4)==0) attribs.smsNumber = "+17035551234";
                attribs.friendly = attribs.smsNumber ? "Buddy Friendly Name with SMS "+num : "Buddy Friendly Name "+num;
                // Add a friendly name
                buddy.friendly = attribs.friendly;
                if(attribs.smsNumber)
                {
                    buddy.smsNumber = attribs.smsNumber;
                }
                // Store attributes into map
                _buddyAttributeMap[buddy.aimId] = attribs;
            }
            
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
            var replyObj:Object = {
                statusCode: 200,
                statusText: "Ok",
                requestId: vars.r
            };
            
            if(vars.t == missingScreenName) {
                replyObj.statusCode = 602;
                replyObj.statusText = "Target not available";
                if(vars.f == "xml")
                {
                    return createXMLFromIMResponseObj(replyObj);
                }
                else
                {
                    return replyObj;
                }
            }
            
            // Parse "special" messages
            var msgWords:Array = (vars.message as String).split(" ");
            // Some special messages require our buddy to be modified, so get a ref to him here
            var buddy:Object = getBuddyFromBuddyList(vars.t);
            if(!buddy) buddy = { aimId : vars.t, state : "online"};
            var fakeUser:User = new User();
            fakeUser.aimId = vars.t;
            // Assume that sending to any mobile number should result in an smsCode block in the response
            if(fakeUser.userType == UserType.SMS)
            {
                buddy.state = "mobile"
                replyObj.smsCode = _smsInfo;
            }
            
            
            // Right now, this function doesn't handle error cases where the IM *wasn't* sent, so in each
            // case, always push a new "sentim" event
            pendingSentIMEvents.push(createSentIM(true, buddy, (vars.message as String)));
            eventsToReturn.push("sentim");
            
            // BEGIN PARSING FOR 'SPECIAL' MESSAGES
            // In some cases we create a presenceEvent, so we declare the var here
            var presenceEvt:Object = null;
            if(msgWords[0] == "help")
            {
                //vars.t = vars.t.replace("buddy", "");
                pendingIMEvents.push(createIM(true, buddy, helpText));
                eventsToReturn.push("im");
            }
            else if(msgWords[0] == "quote")
            {
                //vars.t = vars.t.replace("buddy", "");
                pendingIMEvents.push(createIM(true, buddy));
                eventsToReturn.push("im");
            }
            else if(msgWords[0] == "sendim")
            {
                var buddyToSendFrom:Object = null; // if null, will default to "buddy0"
                if(msgWords.length == 2)
                {
                    buddyToSendFrom = getBuddyFromBuddyList(msgWords[1]);
                    if(buddyToSendFrom == null)
                    {
                        buddyToSendFrom = { aimId : msgWords[1], state : "online"};
                    }
                }
                pendingIMEvents.push(createIM(true, buddyToSendFrom));
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
                if(possState == "online" || possState == "away" || possState == "offline" || possState == "mobile" || possState == "invisible")
                {
                    if(buddy && buddy.state != possState)
                    {
                        
                        // Update our model
                        buddy.state = possState; // buddy is by reference, so it updates our model
                        
                        // Add a pending presence event
                        presenceEvt = 
                        {
                            eventData : buddy,
                            type : "presence"
                        }
                        pendingPresenceEvents.push(presenceEvt);
                        eventsToReturn.push("presence");
                    }
                } 
                else if (possState == "nuts")
                {
                    // Causes all buddies to start signing on and off rapidly.
                    goNuts();
                }      
                else if (possState == "nuts-no-more")
                {
                    // Causes all buddies to start signing on and off rapidly.
                    stopGoingNuts();
                }                          	
            }
            else if(msgWords[0] == "set" && msgWords[1] == "status" && msgWords.length > 2)
            {
                // Pop out "set" and "status" so we're left just with the status msg words to join
                msgWords.shift();
                msgWords.shift();
                var statusMsg:String = msgWords.join(" ");
                if(buddy && statusMsg != buddy.statusMsg)
                {
                    
                    // Update our model
                    buddy.statusMsg = statusMsg; // buddy is by reference, so it updates our model
                    
                    // Add a pending presence event
                    presenceEvt = 
                    {
                        eventData : buddy,
                        type : "presence"
                    }
                    pendingPresenceEvents.push(presenceEvt);
                    eventsToReturn.push("presence");
                }
            }
            else if(msgWords[0] == "clear" && msgWords[1] == "status")
            {
                if(buddy && buddy.statusMsg != null)
                {
                    
                    // Update our model
                    buddy.statusMsg = null; // buddy is by reference, so it updates our model
                    
                    // Add a pending presence event
                    presenceEvt = 
                    {
                        eventData : buddy,
                        type : "presence"
                    }
                    pendingPresenceEvents.push(presenceEvt);
                    eventsToReturn.push("presence");
                }
            }
            else if(msgWords[0] == "gimme" && msgWords[1] == "smscode" && msgWords.length > 2)
            {
                // Pop out "gimme" and "smscode" so we're left just with the smscode
                msgWords.shift();
                msgWords.shift();
                var smsErrorCode:Number = new Number(msgWords[0]);
                if(!isNaN(smsErrorCode))
                {
                    replyObj.statusCode = 602; // Figure out if all smsErrors generate the same statusCode
                    replyObj.statusText = "You gots an IM sending error";
                    if(!replyObj.smsCode) 
                    {
                        replyObj.smsCode = _smsInfo;
                    }
                    replyObj.smsCode.smsError = smsErrorCode;
                    replyObj.smsCode.smsReason = "You gots an SMS error dawg";
                }
            }
            else if(msgWords[0] == "endsession")
            {
                requestEndSession(null);
            }
            else if(msgWords[0] == "echo")
            {
                var echoOn:Boolean = _echoIMsMap[buddy.aimId] == true;
                if(msgWords.length == 2)
                {
                    // on or off
                    if(msgWords[1] == "on")
                    {
                        _echoIMsMap[buddy.aimId] = true;
                        pendingIMEvents.push(createIM(true, buddy, "Echo ON"));
                        eventsToReturn.push("im");
                    }
                    else if(msgWords[1] == "off")
                    {
                        _echoIMsMap[buddy.aimId] = false;
                    }
                }
                else
                {
                    // Get echo status
                    pendingIMEvents.push(createIM(true, buddy, "Echo is "+echoOn));
                    eventsToReturn.push("im");
                }
            }
            else if(_echoIMsMap[buddy.aimId] == true) {
                //vars.t = vars.t.replace("buddy", "");
                pendingIMEvents.push(createIM(true, buddy, "Echo: "+vars.message));
                eventsToReturn.push("im");
            }
            
            if(fakeUser.userType == UserType.SMS)
            {
                if(replyObj.statusCode == 200)
                {
                    if(_smsBalance > 0) _smsBalance--;
                    else _smsBalance = 10; // auto recharge!
                    
                    replyObj.smsCode.smsRemainingCount = _smsBalance;
                }
            }
            
            /*
            if(replyObj.smsCode)
            {
                // put in our balance and balance group here
                if(!replyObj.smsCode.smsRemainingCount) 
                replyObj.smsCode.smsRemainingCount = _smsBalance;
                replyObj.smsCode.smsBalanceGroup = "defaultMockBalanceGroup";
            }
            */
            
            if(vars.f == "xml")
            {
                return createXMLFromIMResponseObj(replyObj);
            }
            else
            {
                return replyObj;
            }
        }
        
        protected function createXMLFromIMResponseObj(replyObj:Object):XML
        {
            //var str:String = sendIMResponseXML.toXMLString();
            
            var ns:Namespace = new Namespace("http://developer.aim.com/xsd/im.xsd");
            //default xml namespace = ns;
            var sendIMResponseXML:XML =
                <response xmlns="http://developer.aim.com/xsd/im.xsd" />;
                /*
                    <statusCode>200</statusCode>
                    <statusText>Ok</statusText>
                    <requestId>%1</requestId>
                    <data>
                        <pageview_candidate>web_aim_en_us_v1</pageview_candidate>
                    </data>
                </response>;
                */
            sendIMResponseXML.ns::statusCode = replyObj.statusCode;
            sendIMResponseXML.ns::statusText = replyObj.statusText;
            sendIMResponseXML.ns::requestId = replyObj.requestId;
            if(replyObj.smsCode)
            {
                var smsCode:XML = <smsCode />;
                if(replyObj.smsCode.smsError) smsCode.ns::smsError = replyObj.smsCode.smsError;
                if(replyObj.smsCode.smsReason) smsCode.ns::smsReason = replyObj.smsCode.smsReason;
                if(replyObj.smsCode.smsCarrierID) smsCode.ns::smsCarrierID = replyObj.smsCode.smsCarrierID;
                if(replyObj.smsCode.smsRemainingCount) smsCode.ns::smsRemainingCount = replyObj.smsCode.smsRemainingCount;
                if(replyObj.smsCode.smsMaxAsciiLength) smsCode.ns::smsMaxAsciiLength = replyObj.smsCode.smsMaxAsciiLength;
                if(replyObj.smsCode.smsMaxUnicodeLength) smsCode.ns::smsMaxUnicodeLength = replyObj.smsCode.smsMaxUnicodeLength;
                if(replyObj.smsCode.smsCarrierName) smsCode.ns::smsCarrierName = replyObj.smsCode.smsCarrierName;
                if(replyObj.smsCode.smsCarrierUrl) smsCode.ns::smsCarrierUrl = replyObj.smsCode.smsCarrierUrl;
                if(replyObj.smsCode.smsBalanceGroup) smsCode.ns::smsBalanceGroup = replyObj.smsCode.smsBalanceGroup;
                
                sendIMResponseXML.ns::smsCode = smsCode;
            }
            sendIMResponseXML.ns::data.pageview_candidate = "web_aim_en_us_v1"; // is this XML response only?
            
            

            return sendIMResponseXML;
        }
        
        protected function requestPermitDeny(vars:URLVariables):Object {
            var result:Object = getOKResponse(vars);
            result.data = {
                   "pdMode":"permitOnList",
                   "allows":"buddy1,buddy3,buddy5,buddy7",
                   "blocks":"buddy6", // buddy0,buddy2,buddy4,
                   "ignores":"buddy12,buddy14,buddy16"
            }
            
            return result;
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
            // Host auto converts < and > into xml escaped values, so do it here
            status = status.replace(/</ig, "&lt;");
            status = status.replace(/>/ig, "&gt;");
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
            eventsToReturn.push("myinfo");
            
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
                // These two call will create a group and create a buddy if it doesn't exist
                var group:Object = getBuddyListGroup(groupName, true);
                var buddy:Object = getBuddyInGroup(buddyAimId, group, true);
                // Always push a new buddy list event (except if the name is "ghost")
                if(buddyAimId != badAddBuddyAimId)
                {
                    eventsToReturn.push("buddylist");
                }
            }
            
            return result;
        }
        
        protected function requestRemoveBuddy(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            var bFound:Boolean = false;
            for each(var group:Object in _buddyList.groups)
            {
                if(group.name == vars.group)
                {
                    for (var i:Number=0; i<group.buddies.length; i++)
                    {
                        if(group.buddies[i].aimId == vars.buddy)
                        {
                            group.buddies.splice(i, 1);
                            bFound = true;
                                        
                            // Always push a new buddy list event
                            eventsToReturn.push("buddylist");
                            
                            break;
                        }
                    }
                }
                if(bFound) break;
            }
            
            // TODO: Handle the response for trying to remove a buddy that doesn't exist
            
            return result;
        }
        
        protected function requestRemoveGroup(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            
            for (var i:Number=0; i<_buddyList.groups.length; i++)
            {
                var group:Object = _buddyList.groups[i];
                
                if(group.name == vars.group)
                {
                    _buddyList.groups.splice(i,1);
                    // Always push a new buddy list event
                    eventsToReturn.push("buddylist");
                    break;
                }
            }
            
            // Currently WIM returns 200-OK even if it didnt find the group to remove!
            // so we emulate that here...
            // "I'm not lazy... honest!" --Riz
            return result;
        }
        
        protected function requestRenameGroup(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            
            for (var i:Number=0; i<_buddyList.groups.length; i++)
            {
                var group:Object = _buddyList.groups[i];
                
                if(group.name == vars.oldGroup)
                {
                    group.name = vars.newGroup;
                    // Always push a new buddy list event
                    eventsToReturn.push("buddylist");
                    break;
                }
            }
            
            // Currently WIM returns 200-OK even if it didnt find the group to remove!
            // so we emulate that here...
            // "I'm not lazy... honest!" --Riz
            return result;
        }
        
        protected function requestAddTempBuddy(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            // we don't do anything else here yet
            return result;
        }
        
        protected function requestSetBuddyAttribute(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            var buddy:Object = getBuddyFromBuddyList(vars.buddy);
            var attribs:Object = _buddyAttributeMap[vars.buddy];
            if(!attribs && buddy)
            {
                attribs = new Object()
                _buddyAttributeMap[vars.buddy] = attribs;
            }
            if(vars.friendly != null)
            {
                if(vars.friendly.length > 0)
                {
                    attribs.friendly = vars.friendly;
                    if(buddy) buddy.friendly = attribs.friendly;
                }
                else
                {
                    delete attribs.friendly;
                    if(buddy) delete buddy.friendly;
                }
            }
            if(vars.smsNumber != null)
            {
                if(vars.smsNumber.length > 0)
                {
                    attribs.smsNumber = vars.smsNumber;
                    if(buddy) buddy.smsNumber = attribs.smsNumber;
                }
                else
                {
                    delete attribs.smsNumber;
                    if(buddy) delete buddy.smsNumber;
                }
            }
            if(vars.workNumber != null)
            {
                if(vars.workNumber.length > 0)
                {
                    attribs.workNumber = vars.workNumber;
                    if(buddy) buddy.workNumber = attribs.workNumber;
                }
                else
                {
                    delete attribs.workNumber;
                    if(buddy) delete buddy.workNumber;
                }
            }
            if(vars.otherNumber != null)
            {
                if(vars.otherNumber.length > 0)
                {
                    attribs.otherNumber = vars.otherNumber;
                    if(buddy) buddy.otherNumber = attribs.otherNumber;
                }
                else
                {
                    delete attribs.otherNumber;
                    if(buddy) delete buddy.otherNumber;
                }
            }
            // Always push a new buddy list event
            eventsToReturn.push("buddylist");
            return result;
        }
        
        protected function requestGetBuddyAttribute(vars:URLVariables):Object
        {
            var result:Object = getOKResponse(vars);
            var buddy:Object = getBuddyFromBuddyList(vars.buddy);
            var attribs:Object = _buddyAttributeMap[vars.buddy];
            result.data = attribs ? attribs : {};
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
        
        protected function requestGetSMSInfo(vars:URLVariables):Object
        {
            var res:Object = getOKResponse(vars);
            var phoneNumber:String = vars.phone;
            if(phoneNumber.indexOf("+1") == 0)
            {
                res.statusText = "Server error."
                res.statusCode = 500;
                res.statusDetailCode = 1140;
                res.data = { };
            }
            else
            {
                res.data = { smsInfo : _smsInfo };
            }
            return res;
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
            var targets:Array = vars.t is Array ? vars.t : new Array([vars.t]);//vars.toString().split('t=');
            result.data = { infoArray : [] };
            for (var i:int=0; i<targets.length; i++)
            {
                result.data.infoArray.push(makeMDirProfile(targets[i]));
            }
            return result;
        }
        
        /**
         * Convenience function to make a full mdir profile, based on just an "id" 
         * @param id
         * @return 
         * 
         */        
        private function makeMDirProfile(uin:String):Object
        {
            var id:String = uin;
            if(id.length == 2)
            {
                id = "0" + (5-Number(id));
            }
            return { 
                profile: { 
                    aimId:uin, 
                    firstName:"Roger", 
                    lastName:"Tired "+id, 
                    gender:"male", 
                    homeAddress:
                    [ 
                        { street:"1024 Burywood Lane", city:"Reston", state:"VA", zip:"20194", country:"US" } 
                    ], 
                    friendlyName:"rogertired "+id, 
                    website1:"www.partlyhuman.com", 
                    relationshipStatus:"single", 
                    lang1:"en", 
                    jobs:
                    [ 
                        { title:"Code Monkey", company:"partlyhuman inc", website:"www.partlyhuman.com", department:"code monkery", industry:"technology", subIndustry:"teh internets", startDate:null, endDate:null, street:"", city:"", state:"", zip:"", country:"" } 
                    ], 
                    aboutMe:"Here's my profile", 
                    birthDate:(new Date(1981,5,12).time) / 1000, 
                    visitorCount:"", 
                    searchHistory:"", 
                    currentAddress:{ 
                        street:"555 Greene Ave.", 
                        city:"Brooklyn", 
                        state:"NY", 
                        zip:"11238", 
                        country:"US" 
                    }, 
                    interestedIn:["college","women","space","80s","music"], 
                    favoriteMusic:"dance", 
                    favoriteMovies:"Brazil", 
                    favoriteTv:"no", 
                    favoriteBooks:"Ender's Game", 
                    activities:"sleeping", 
                    whatILove:"sleeping", 
                    whatIHate:"sleeping", 
                    quote1:"hello", 
                    quote2:"goodbye", 
                    quote3:"um", 
                    quote4:"", 
                    highSchool:"tjhsst", 
                    highSchoolGradYear:"1999", 
                    university:"cmu", 
                    universityGradYear:"2003", 
                    customHtml:"", 
                    themeCode:"", 
                    commentId:"", 
                    codeSnippet:"", 
                    codeSnippetRaw:"", 
                    privateKey:"", 
                    originAddress:
                    [ 
                        { 
                            street:"167 5th ave. #1", 
                            city:"Brooklyn", 
                            state:"NY", 
                            zip:"11217", 
                            country:"US" 
                        } 
                    ], 
                    lang2:"ja", 
                    lang3:"es", 
                    validatedEmail:"rogerimp@gmail.com", 
                    pendingEmail:"", 
                    emails:
                    [ 
                        { addr:"rogerimp@gmail.com", hide:false, primary:true } 
                    ], 
                    phones:
                    [ 
                        { phone:"703-555-5555", type:"Home" }, 
                        { phone: "703-555-5554", type: "Office" } 
                    ], 
                    education:"uneducated", 
                    studies:
                    [ 
                        { instituteType:"", instituteName:"", degree:"", major:"", studiesYear:"" } 
                    ], 
                    interests:
                    [ 
                        { text:"", code:"" } 
                    ], 
                    groups:
                    [ 
                        { text:"", code:"" } 
                    ], 
                    pasts:
                    [ 
                        { text:"", code:"" } 
                    ], 
                    anniversary:"", 
                    children:"none", 
                    religion:"agnostic", 
                    sexualOrientation:"straight", 
                    smoking:"false", 
                    height:"short", 
                    hairColor:"red", 
                    tz:"GMT-0500", 
                    online:"", 
                    partnerIds:"", 
                    photo:true, 
                    localLangCd:"", 
                    lastupdated:null, 
                    userType:"", 
                    allowEmail:true, 
                    hideLevel:"", 
                    betaFlag:"", 
                    statusLine:"", 
                    hideFlag:"", 
                    autoSms:"false", 
                    validatedCellular: ((uin == "00000000") ? "+1 70 32659999 SMS" : null) 
                }, 
                settings: null 
            }; 
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
                var fakeUser:User = new User();
                fakeUser.aimId = buddyAimId;
                fakeUser.state = "online";
                if(fakeUser.userType == UserType.SMS && buddyAimId.charAt(0) == "+")
                {
                    fakeUser.state = "mobile";
                }
                var newBuddy:Object = 
                {
                    aimId : fakeUser.aimId,
                    state : fakeUser.state
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
        
        protected function getRandomBuddy():Object
        {
        	var i:int = Math.floor(Math.random()*(_buddyList.groups.length));
            var group:Object = _buddyList.groups[i];
            i = Math.floor(Math.random()*(group.buddies.length));
            var buddy:Object = group.buddies[i];
            return buddy;
        }
        
        protected function changeRandomState(event:Event):void 
        {       
            var buddy:Object = getRandomBuddy();

            if (buddy.state == "online")
            {
                buddy.state = "offline";
            }
            else 
            {
                buddy.state = "online";
            }   
            
            var presence:Object = 
            {
                eventData : buddy,
                type : "presence"
            }                     
            
            pendingPresenceEvents.push(presence);
            eventsToReturn.push("presence");                                      
        }        
        
        // All buddies start signing on and off rapidly.        
        protected function goNuts():void
        {   		    
		    if (!_nutsTimer)
		    {
		    	_nutsTimer = new Timer(250);
		    	_nutsTimer.addEventListener(TimerEvent.TIMER, changeRandomState);
		    } 
		    _nutsTimer.start();		    
        }
        
        protected function stopGoingNuts():void
        {
        	if (_nutsTimer) 
        	{
        		_nutsTimer.stop();
        	}
        }
               
    }
}

