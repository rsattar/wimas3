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

package com.aol.api.openauth.events
{
    import com.aol.api.openauth.AuthToken;
    
    import flash.events.Event;

    public class AuthEvent extends Event
    {
        public static const LOGIN:String    = "login";
        public static const LOGOUT:String   = "logout";
        public static const CHALLENGE:String= "challenge";
        // make more specific errors? LoginError, LogoutError...?
        public static const ERROR:String    = "error";
        
        private var _statusCode:Number      =   0;
        private var _statusText:String      =   null;
        private var _statusDetailCode:Number=   0;
        private var _token:AuthToken        =   null;
        private var _sessionKey:String   =   null;
        // These are sort of use *only* by 'challenge' type events. Make a subclass?
        private var _challengeContext:String=   null;
        private var _challengeUrl:String    =   null;
        private var _info:String            =   null;
        
        public function AuthEvent(type:String, statusCode:Number, statusText:String, statusDetailCode:Number=0, 
                                  token:AuthToken=null, authSessionKey:String=null, context:String=null, url:String=null, info:String=null,
                                  bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
            _statusCode = statusCode;
            _statusText = statusText;
            _statusDetailCode = statusDetailCode;
            _token = token;
            _sessionKey = authSessionKey;
            _challengeContext = context;
            _challengeUrl = url;
            _info = info;
        }
        
        /**
         * Retreives the event status code.
         */
        public function get statusCode():Number {
            return _statusCode;
        }
        
        /**
         * Retreives the event status text.
         */
        public function get statusText():String {
            return _statusText;
        }
        
        /**
         * Retreives the event status detail code. This is optionally set, usually for <code>AuthEvent.CHALLENGE</code> events.
         */
        public function get statusDetailCode():Number {
            return _statusDetailCode;
        }
        
        /**
         * Retreives the authentication token.
         */
        public function get token():AuthToken {
            return _token;
        }
        
        /**
         * Retreives the sessionKey which is the generated sha256 of user's password (key) and sessionSecret (msg).
         */
        public function get sessionKey():String {
            return _sessionKey;
        }
        
        /**
         * Retreives the context string. This is usually set by <code>AuthEvent.CHALLENGE</code> events.
         */
        public function get challengeContext():String {
            return _challengeContext;
        }
        
        /**
         * Retreives the challenge url. This is usually set by <code>AuthEvent.CHALLENGE</code> events, particular a captcha challenge
         */
        public function get challengeUrl():String {
            return _challengeUrl;
        }
        
        /**
         * Retreives additional information for an event. This is usually set by <code>AuthEvent.CHALLENGE</code> events.
         */
        public function get info():String {
            return _info;
        }
        
    }
}