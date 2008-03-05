package com.aol.api {
    
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
        protected var authenticatedSN:String    =   "";
        
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
            var transactionName:String = urlPart.substring(urlPart.lastIndexOf("/")+1); // this gives the very last word in the url.
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
                case "clientLogin":
                    return requestSignOn(vars); break;
                case "startSession":
                    return requestStartSession(vars); break;
                case "fetchEvents":
                    return requestFetchEvents(vars); break;
                case "endSession":
                    return requestEndSession(vars); break;
                case "sendIM":
                    return requestSendIM(vars); break;
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
                    myInfo : createMyInfo()
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
                        fetchEventsSuccess.data.events.push(createBuddyList(true));
                        break;
                    case "im":
                        // Add any pending im events, or a dummy one if it's empty
                        if(pendingIMEvents.length == 0) {
                            fetchEventsSuccess.data.events.push(createIM(true));
                        } else {
                            for(var m:int=0; m<pendingIMEvents.length; m++) {
                                fetchEventsSuccess.data.events.push(pendingIMEvents.shift());
                            }
                        }
                        break;
                    case "myinfo":
                        // Add buddy list
                        fetchEventsSuccess.data.events.push(createMyInfo(true));
                        break;
                    case "presence":
                        // Add buddy list
                        fetchEventsSuccess.data.events.push(createBuddyInfo(0, true)); // always return buddy0 for now
                        break;
                    default :
                        trace("Not handled fetchEvent type: "+evtType+". Make sure it is all lowercase.");
                        
                }
                // Get next evtType, if any
                evtType = eventsToReturn.shift();
            }
            
            return fetchEventsSuccess;
        }
        
        private function createBuddyList(createEvent:Boolean=false):Object {
            var bl:Object = {
                groups : []
            }
            var numGroups:int = 5;
            var buddiesPerGroup:int = 5;
            for(var i:int=0; i<numGroups; i++) {
                var group:Object = {
                    buddies : [],
                    name : "Group "+(i+1)
                };
                for(var j:int=0; j<buddiesPerGroup; j++) {
                    group.buddies.push(createBuddyInfo(j+i));
                }
                bl.groups.push(group);
            }
            if(createEvent) {
                return { eventData : bl, type : "buddylist" };
            } else {
                return bl;
            }
        }
        
        private function createIM(createEvent:Boolean=false, sourceBuddyIndex:int=-1, msg:String=null):Object {
            if(sourceBuddyIndex == -1) {
                sourceBuddyIndex = 0;
            }
            if(!msg) {
                msg = "Hey man yt?";
            }
            var im:Object = {
                source : createBuddyInfo(sourceBuddyIndex, false),
                message : msg,
                autoResponse : false,
                timestamp : int(new Date().getTime()/1000) // Timestamp is in *seconds* since epoch, not milliseconds
            };
            if(createEvent) {
                return { eventData : im, type : "im" };
            } else {
                return im;
            }
        }
        
        private function createMyInfo(createEvent:Boolean=false):Object {
            var myInfo:Object = {
                aimId : this.authenticatedSN,
                buddyIcon : "http://api-oscar.tred.aol.com:8000/expressions/getAsset?t="+this.authenticatedSN+"&f=native&id=00052b00002b40&type=buddyIcon",
                displayId : this.authenticatedSN + " Name",
                state : "online",
                presenceIcon : "http://o.aolcdn.com/aim/img/online.gif"   
            };
            if(createEvent) {
                return { eventData : myInfo, type : "myInfo" };
            } else {
                return myInfo;
            }
        }
        
        private function createBuddyInfo(optIndex:int=-1, createEvent:Boolean=false):Object {
            
            var num:int = optIndex >= 0 ? optIndex : ++buddyNumber;
            var buddy:Object = {
                aimId : "Buddy"+num,
                displayId : "Buddy Name "+num,
                state : "online"
            };
            
            if(createEvent) {
                return { eventData : buddy, type : "presence" };
            } else {
                return buddy;
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
            if(echoIMs) {
                vars.t = vars.t.replace("Buddy", "");
                pendingIMEvents.push(createIM(true, vars.t as int, "Echo: "+vars.message));
                eventsToReturn.push("im");
            }
            return {
                statusCode: 200,
                statusText: "Ok",
                requestId: vars.r
            };
        }
        
        // Canned error responses
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