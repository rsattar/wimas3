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

package com.aol.api.openauth
{
    import com.aol.api.logging.ILog;
    import com.aol.api.logging.Log;
    import com.aol.api.openauth.events.AuthEvent;
    import com.aol.api.wim.transactions.ResultLoader;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    
    public class ClientLogin extends EventDispatcher
    {
        protected static const API_BASE:String   = "https://api.screenname.aol.com/";
        protected static const ON_METHOD:String  = "auth/clientLogin";
        protected static const OFF_METHOD:String = "auth/logout";
        
        internal var apiBaseURL:String           = API_BASE;
        
        private var tokenStr:String              = null;
        private var expiresIn:String             = null;
        private var sessionSecret:String         = null;
        
        private var statusCode:String            = null;
        private var statusDetailCode:String      = null;
        private var statusText:String            = null;
        private var challengeContext:String      = null; 
        private var challengeUrl:String          = null;
        private var info:String                  = null;
        
        private var screenName:String            = null; 
        private var password:String              = null; 
        
        private var devId:String                 = null;
        private var clientName:String            = null;
        private var clientVersion:String         = null;   
        private var language:String              = null;
        
        // Time according to host.
        private var _hostTime:Number             = 0;
        // Time according to client.
        private var _clientTime:Number           = 0;   
        
        private var _icqEmailRetry:Boolean       = false;
        
        
        /**
         * Our protected 'Class' instance of the ResultLoader class.
         * We set this object a subclass of ResultLoader designed to facilitate offline testing
         * of our network access code. It is protected so that we may override it during testing.
         */
        protected var _loaderClass:Class =   ResultLoader;
        
        // Logging object
        private var _logger:ILog                          =   null;
        
        // Define the XML namespace used by open auth XML responses
        private namespace openauthNS             = "https://api.login.aol.com";
        // Ensure namespace is set (for this class) or E4X won't work.
        use namespace openauthNS;
        
        /**
         * Initializes ClientLogin with the devId, clientName and clientVersion, which are required parameters
         * in using the clientLogin call. 
         * 
         * @param dev The developer key for the session
         * @param clientName The name of this client. Currently this is not verified at the server end.
         * @param clientVersion The version of this client. Currently this is not verified at the server end.
         * @param logger Optional. A <code>ILog</code> interface which can be passed in for tracing debug statements.
         *                         If none is provided, a new <code>Log</code> is created with just traces to the console.
         * 
         */        
        public function ClientLogin(dev:String, clientName:String, clientVersion:String, logger:ILog=null, authBaseURL:String=null, language:String="en-us"):void {
            this.devId = dev;
            this.clientName = clientName;
            this.clientVersion = clientVersion;
            this.language = language;
            _logger = logger ? logger : new Log("ClientLogin");
            
            if(authBaseURL && authBaseURL != "") {
                this.apiBaseURL = authBaseURL;
            }
        }
        
        /**
         * This performs the "auth/clientLogin" request. It correctly orders the parameters in order.
         *  
         * If there are challenges to be answered, this class maintains state for the challenge. This makes it easier
         * for the next <code>signOn</code> call to just pass in the challengeAnswer, rather than also the context.
         * 
         * @param s The username
         * @param p The password
         * @param challengeAnswer Optional challenge answer. Provide this if presented with an <code>AuthEvent.CHALLENGE</code>.
         * @param forceCaptcha Optional. If true, will send a "forceRateLimit=yes" param, forcing a captcha challenge. Default is false.
         * @param getLongTermToken Optional. Uses the screenname and password to requests a long-term token, which can be saved to start another session in the future without u/p.
         * 
         */        
        public function signOn(s:String, p:String, challengeAnswer:String=null, forceCaptcha:Boolean=false, getLongTermToken:Boolean = false):void {
            _logger.info("ClientLogin baseURL: "+this.apiBaseURL);
            var loader:ResultLoader = createURLLoader();
            //_logger.debug("AuthBaseURL: " + apiBaseURL + ON_METHOD);
            
            var url:String = apiBaseURL + ON_METHOD;

            // Package up all params in query format and SHA256 sign resulting buffer.
            screenName         = s;
            
            if (isUIN(screenName)) {
                password = truncateICQPassword(p);
            } else {
                password = p;
            }
                                                
            var theRequest:URLRequest = new URLRequest(url);
            theRequest.method = URLRequestMethod.POST;
            
            if(!challengeAnswer) {
                // reset statusDetailCode and context values from before
                reset();
            }
            
            var vars:URLVariables = new URLVariables();

            // This parameter asks KDC to treat the loginId as an ICQ email address, not an SNS address.
            // At some point, probably by June of 2008, this will no longer be necessary because they are going
            // to do this re-check within KDC so that clients don't have to. 
            if(_icqEmailRetry && (s.search('@') > 0)) {
                vars.idType = "ICQ";
                password = truncateICQPassword(p);
            }
            
            // Set up params in alphabetical order
            // Captcha word
            if(statusDetailCode == "3015") {
                vars.word = challengeAnswer;
            }
            if(challengeContext != null) {
                vars.context = challengeContext;
            }
            if(statusDetailCode != "3012" && statusDetailCode != "3015") {
                
                vars.clientName = clientName;
                vars.clientVersion = clientVersion;
            }
            
            vars.devId = devId;
            vars.f = "xml";
            vars.language = language;
            
            if(forceCaptcha) {
                vars.forceRateLimit = "yes";
            }
            
            if(statusDetailCode == null || statusDetailCode == "3011" || statusDetailCode == "3015" || statusDetailCode == "3012") {
                vars.pwd = password;
            }
            
            vars.s = screenName;

            if(statusDetailCode == "3012" || statusDetailCode == "3013") {
                vars.securid = challengeAnswer;
            }
            // Token type
            //+ "&tokenType=shortterm";
            if (getLongTermToken)
            {
                vars.tokenType = "longterm";
            }
            
            // "We hates the IE!  Hates it, we do!"
            // This flag tells the auth host to use special headers to prevent IE/Flash from 
            // barfing an IOERROR #2032 upon receipt of the response.  Thanks, Praveen.
            vars.cacheflag = 3;
            
            // Package up POST data
            _logger.debug("ClientLogin: " + vars.toString());
            
            statusCode           = null;
            statusDetailCode     = null;
            
            theRequest.data = vars; //variables
            loader.addEventListener(Event.COMPLETE, signOnComplete);
            loader.addEventListener( IOErrorEvent.IO_ERROR, handleIOError );
            loader.load(theRequest);
        }
        
        /**
         * Initiate signoff request with context of current session.
         * @param token The <code>AuthToken</code> object we want to unauthenticate
         */
        public function signOff(token:AuthToken, sessionKey:String):void {
            var loader:ResultLoader = createURLLoader();
            
            var queryString:String = "a="+token.a;
            queryString += "&devId="+encodeStrPart(devId);
            queryString += "&f=xml";
                        
            var encodedQuery:String = encodeURIComponent(queryString);
            
            _logger.debug("SignOff QueryParams    : "+queryString);
            _logger.debug("Session Key    : "+sessionKey);
        
        
            // Generate OAuth Signature Base
            var sigBase:String = "GET&"+encodeStrPart(apiBaseURL + OFF_METHOD)+"&"+encodedQuery;
            _logger.debug("Signature Base : "+sigBase);
            // Generate hash signature
            var sig_sha256:String = (new HMAC()).SHA256_S_Base64(sessionKey, sigBase);
            _logger.debug("Signature Hash : "+encodeURIComponent(sig_sha256));

            // Append the sig_sha256 data
            queryString += "&sig_sha256="+encodeURIComponent(sig_sha256);
            _logger.debug("FinalQuery     : "+queryString);
            
            
            var theRequest:URLRequest = new URLRequest(apiBaseURL + OFF_METHOD + "?" + queryString);
            
            
            loader.addEventListener( Event.COMPLETE, signOffComplete);
            loader.addEventListener( IOErrorEvent.IO_ERROR, handleIOError );
            loader.load(theRequest);
        }
                
        private function encodeString(s:String):String {
            var r:String = encodeURI(s);
            r = r.replace(/\+/, "%2B");
            return r;
        }
                
        private function encodeStrPart(s:String):String {
            var r:String = encodeURIComponent(s);
            r = r.replace(/\+/, "%2B");
            r = r.replace(/_/, "%5F");
            return r;
        }

        private function isUIN(login:String):Boolean {
            return !isNaN(Number(login));
        }
        
        /**
         * ICQ passwords cannot be longer than 8 characters but some ICQ users
         * don't know that.  They type longer passwords which need to be
         * truncated.  Would be nice if the host handled this...
         */ 
        private function truncateICQPassword(password:String):String {
            return password.substr(0, 8);
        }
        
        /**
         * Generic i/o handler for any host requests.
         */
        private function handleIOError(event:IOErrorEvent):void {
            var loader:ResultLoader = ResultLoader(event.target);
            var xml:XML = new XML(String(loader.data));
            var data:String = loader.data;
            
            _logger.debug("IOERROR, type="+event.type+", text="+event.text);
        }
         
        /**
         * Sign on request has completed.
         */
        private function signOnComplete(event:Event):void {
            var loader:ResultLoader = ResultLoader(event.target);
            var xml:XML = new XML(String(loader.data));
            var data:String = loader.data;
            _logger.debug("signOnResponse:\n"+data);
            
            /*
            <response xmlns="https://api.login.aol.com">
              <statusCode>200</statusCode>
              <statusText>OK</statusText>
              <data>
                <token>
                  <expiresIn>86400</expiresIn>
                  <a>%2FwEAAAAAXS6xpePqZPlWO1ThFdFArikQbE2UlzWGeie%2FU2tC0G2Ib2UD9id%2BG6oIugH8wtKl2gkALT9F%2FT9BEBg8XSU7zl9NGkjjLzJEeuoje9c%2BYx4SM8SAMSVpTSyyb6AmUaA79lpQizOLSAPPVf03o%2F6zue2YLvPkPCB6Muiafe7lZPCv24jMCDx952h3pfa0AOP%2BLZyyI1WXqhODCB99</a>
                </token>
                <sessionSecret>7dk4E65PvLSalhge</sessionSecret>
              </data>
            </response>
            */
            
            // Parse returned data
            statusCode       = xml.statusCode.text();
            statusDetailCode = xml.statusDetailCode.text();
            statusText       = xml.statusText;
            tokenStr         = xml.data.token.a.text();
            expiresIn        = xml.data.token.expiresIn.text();
            challengeContext = xml.data.challenge.context.text();
            challengeUrl     = xml.data.challenge.url.text();
            info             = xml.data.challenge.info.text();
            sessionSecret    = xml.data.sessionSecret.text();
            _hostTime        = Number(xml.data.hostTime.text());
            _clientTime      = Number(new Date().getTime()/1000); 
            
            // Issue appropriate event.  If we're online notify as such, otherwise dispatch challenge
            // request or error condition.
            //_logger.debug("login status is " + statusCode);
            // Send a challenge event, if needed
            
            
            // If we get a 3011 on an ONS email address, try again as an ICQ email address.
            // At some point, probably by June of 2008, this will no longer be necessary because they are going
            // to do this re-check within KDC so that clients don't have to.             
            if ((statusDetailCode == "3011") && (screenName.search('@') > 0) && !_icqEmailRetry) {
                _icqEmailRetry = true;
                _logger.info("ONS signin failed.  Retrying as ICQ email address.");
                signOn(screenName, password);
            } else if (statusDetailCode == "3011" || statusDetailCode == "3012" || statusDetailCode == "3015") {
                _icqEmailRetry = false;
                dispatchEvent(new AuthEvent(AuthEvent.CHALLENGE, Number(statusCode), statusText, Number(statusDetailCode), null, null, challengeContext, challengeUrl, info));
            } else if (statusCode == "200") {
                // Create authDigest of password and sessionSecret. This is used as a key for signing future requests.
                var sessionKey:String = new HMAC().SHA256_S_Base64(password, sessionSecret);
                //_logger.debug("Digest of SHA256(password, sessionSecret) is: "+sessionKey);
                dispatchEvent(new AuthEvent(AuthEvent.LOGIN, Number(statusCode), statusText, Number(statusDetailCode), new AuthToken(tokenStr, Number(expiresIn), hostTime, clientTime), sessionKey, challengeContext, info));
            }
            else {
                dispatchEvent(new AuthEvent(AuthEvent.ERROR, Number(statusCode), statusText, Number(statusDetailCode), null, null, challengeContext, info));
            }
        }
        
        /**
         * Sign off request has completed.
         */
        private function signOffComplete(event:Event):void {
            var loader:ResultLoader = ResultLoader(event.target);
            var xml:XML = new XML(String(loader.data));
            var data:String  = loader.data;
            _logger.debug("signOffResponse:\n"+data);
            // Parse returned data
            statusCode       = xml.statusCode.text();
            statusText       = xml.statusText;
            statusDetailCode = xml.statusDetailCode.text();
            dispatchEvent(new AuthEvent(AuthEvent.LOGOUT, Number(statusCode), statusText, Number(statusDetailCode)));
        }
        
        /**
         *
         */
        public function reset():void {
            statusCode       = null;
            statusDetailCode = null;
            statusText       = null;
            tokenStr         = null;
            challengeContext = null;
            sessionSecret    = null;
        } 

        public function createURLLoader():ResultLoader {
            return new _loaderClass();
        }
        
        public function get hostTime():Number {
            return _hostTime;
        }
        
        public function get clientTime():Number {
            return _clientTime;
        }        
    }
}