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

package com.aol.api.wim.events
{
    import com.aol.api.wim.data.DataIM;
    
    import flash.events.Event;

    /**
     * The <code>DataIMEvent</code> represents incoming and outgoing Data IM events.
     */
    public class DataIMEvent extends Event {
        
        // Capturable Events
        /**
         * The value for the type property of an data IM sending event object. 
         */
        public static const DATA_IM_SENDING:String  = "dataImSending";
        
        // Bubbled Events
        /**
         * The value for the type property of an data IM received event object. 
         */
        public static const DATA_IM_RECEIVED:String = "dataImReceived";
        /**
         * The value for the type property of an data IM sent event object. 
         */
        public static const DATA_IM_SEND_RESULT:String     = "dataImSendResult";

        public var dataIM:DataIM;
        
        /**
         * Stores the request ID for the event. This allows for matching of DATA_IM_SENDING and DATA_IM_SENT events to each other. 
         */
        public var requestId:uint;
        
        /**
         * Contains the status code from trying to send an IM. Only valid for 
         * the DATA_IM_SEND_RESULT event. 
         */
        public var statusCode:String;
        
        /**
         * Contains the status text from trying to send an IM. Only valid for 
         * the DATA_IM_SEND_RESULT event. 
         */
        public var statusText:String;        
        
        public function DataIMEvent(type:String, dataIM:DataIM, bubbles:Boolean=false, cancelable:Boolean=false) {
            //TODO: implement function
            super(type, bubbles, cancelable);
            this.dataIM = dataIM;
        }
        
        override public function clone():Event {
            return new DataIMEvent(type, dataIM, bubbles, cancelable);
        }
        
        override public function toString():String {
            
            var output:String = "[DataIMEvent." + this.type + 
                                " dataIM=" + dataIM.toString() +
                                "]";
            return output;
        }
        
    }
}
