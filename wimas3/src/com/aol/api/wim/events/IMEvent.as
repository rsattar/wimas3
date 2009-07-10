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
    
    import com.aol.api.wim.data.IM;
    import com.aol.api.wim.data.SMSInfo;
    import com.aol.api.wim.transactions.TransactionError;
    
    import flash.events.Event;

    /**
     * The <code>IMEvent</code> represents incoming and outgoing IM events.
     */
    public class IMEvent extends Event {
        
        // Capturable Events
        /**
         * The value for the type property of an IM sending event object. 
         */
        public static const IM_SENDING:String  = "imSending";
        
        // Bubble Events
        
        /**
         * An event to communicate the result of trying to send an IM, whether it 
         * was successful or not. If sending the IM was successful, the statusCode will
         * be 200.
         */
        public static const IM_SEND_RESULT:String = "imSendResult";
        
        /**
         * An event from the host (fetchEvents) that tell us an IM was sent from our identity. Note that
         * this event will fire if _any_ session sends an IM, not just this one.
         */
        public static const IM_SENT:String = "imSent";

        /**
         * The value for the type property of an IM received event object. 
         */
        public static const IM_RECEIVED:String = "imReceived";

        
        // TODO: Consider removing OFFLINE_IM_RECEIVED, as the IM already contains the 'isOffline' flag
        // Currently I am not using this event, for symettry (we don't have an OFFLINE_IM_SENDING flag)
        ///**
        // * The value for the type property of an offline IM received event object. 
        // */
        //public static const OFFLINE_IM_RECEIVED:String = "offlineImReceived";
        
        /**
         * Represents the IM that is being sent or received.
         */
        public var im:IM;
        
        /**
         * Stores the request ID for the event. This allows for matching of IM_SENDING and IM_SENT events to each other. 
         */
        public var requestId:uint;
        
        /**
         * Contains the status code from trying to send an IM. Only valid for 
         * the IM_SEND_RESULT event. 
         */
        public var statusCode:String;
        
        /**
         * Contains the status text from trying to send an IM. Only valid for 
         * the IM_SEND_RESULT event. 
         */
        public var statusText:String;

        /** 
         * Contains the detailed response regarding a failure
         * due to a 603 or 602 error.  Presently we know of "[2] on permit/deny list
         */
        public var subCodeError:String;
        public var subCodeReason:String;
        
        /**
         * Contains even more information on a send IM failure (602), such as if the
         * IM was to a mobile number, and that mobile number's destination country is
         * not supported 
         */        
        public var subCodeSubError:String;
        public var subCodeSubReason:String;

        /**
         * Contains the transactionError if one existed.  This would typically 
         * be fired BEFORE the actual IM request was sent.
         */
        public var transactionError:TransactionError; 
        
        /**
         * Returns information regarding the success or failure of SMS messages.
         */
        public var smsCode:SMSInfo;   
        
        public function IMEvent(type:String, im:IM, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
            this.im = im;
        }
        
        override public function clone():Event {
            var newOne:IMEvent   = new IMEvent(type, im, bubbles, cancelable)
            newOne.smsCode       = this.smsCode;   
            newOne.subCodeError  = this.subCodeError;
            newOne.subCodeReason = this.subCodeReason;
            newOne.subCodeSubError = this.subCodeSubError;
            newOne.subCodeSubReason = this.subCodeSubReason;
            return newOne;            
        }
        
        override public function toString():String {
            var output:String = "[IMEvent." + this.type + 
                                " im=" + im.toString() +
                                " statusCode=" + statusCode +
                                " statusText=" + statusText + 
                                " subCodeError=" + subCodeError + 
								" subCodeReason=" + subCodeReason +
                                " smsCode=" + smsCode +                                                              
                                "]";
            return output;
        }
    }
}