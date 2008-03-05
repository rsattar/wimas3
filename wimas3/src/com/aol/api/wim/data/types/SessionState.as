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

package com.aol.api.wim.data.types {
    
    /**
     * Represents the online state of a session. '
     * This not only represents "online" state, but also our "authentication" state
     */     
    final public class SessionState {
        
        /**
         * Default state. The session is offline.
         */
        public static const OFFLINE:String                      =   "offline";
        
        /**
         * In the process of authentication using clientLogin
         */
        public static const AUTHENTICATING:String               =   "authenticating";
        
        /**
         * An authentication challenge must be handled by the client app
         */
        public static const AUTHENTICATION_CHALLENGED:String    =   "authenticationChallenged";
        
        /**
         * The authentication request failed.
         * TODO: Flesh this out to be more descriptive.
         */
        public static const AUTHENTICATION_FAILED:String        =   "authenticationFailed";
        
        /**
         * A startSession call was requested
         */
        public static const STARTING:String                     =   "starting";
        
        /**
         * A reconnect attempt was requested
         */
        public static const RECONNECTING:String                 =   "reconnecting";
        
        /**
         * The session is connected.
         */
        public static const ONLINE:String                       =   "online";
        
        /**
         * The session unintentionally changed from <code>ONLINE</code> to <code>OFFLINE</code>. The auth token may still be valid though.
         */
        public static const DISCONNECTED:String                 =   "disconnected";
        
        /**
         * Rate Limited
         */
        public static const RATE_LIMITED:String                 =   "rateLimited";
        
        /**
         * Authentication Lost (perhaps due to loss of network connectivity or long machine standby, etc)
         */
        public static const UNAUTHENTICATED:String              =   "unauthenticated";
    }
}