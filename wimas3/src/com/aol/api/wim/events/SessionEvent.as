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

package com.aol.api.wim.events {
    
    import com.aol.api.wim.Session;
    
    import flash.events.Event;

    /**
     * The <code>SessionEvent</code> represents any change in the session.
     * 
     * The STATE_CHANGED event represents any change in the online state of the session.
     */
    
    public class SessionEvent extends Event {
        
        // Events which are used as 'pre' request events
        /**
         * The value for the type property of a session state changed event. 
         */        
        public static const SESSION_AUTHENTICATING:String = "sessionAuthenticating";
        /**
         * The value for the type property of a session state changed event. 
         */        
        public static const SESSION_STARTING:String = "sessionStarting";
        /**
         * An endSession is about to be made on the server
         */        
        public static const SESSION_ENDING:String  = "sessionEnding";
        /**
         * A fetchEvents request is about to be made on the server.
         */        
        public static const EVENTS_FETCHING:String  = "eventsFetching";
        
        // Events which are dispatched as a result of a request (past tense)
        /**
         * The value for the type property of a session state changed event. 
         */        
        public static const STATE_CHANGED:String = "stateChanged";
        /**
         * A fetchEvents request has completed on the server.
         */        
        public static const EVENTS_FETCHED:String  = "eventsFetched";
        
        /**
         * The session which is the subject of this event.
         */
        public var session:Session;
        
        public function SessionEvent(type:String, session:Session, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
            this.session = session;
        }
        
        override public function clone():Event {
            return new SessionEvent(type, session, bubbles, cancelable);
        }
        
        override public function toString():String {
            
            var output:String = "[SessionEvent." + this.type +
                                " session=" + session.toString() + 
                                "]";
            return output;
        }
    }
}