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

package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.events.TypingEvent;
    
    import flash.events.Event;
    import flash.net.URLLoader;

    public class SetTyping extends Transaction
    {
        public function SetTyping(session:Session)
        {
            //TODO: implement function
            super(session);
            addEventListener(TypingEvent.TYPING_STATUS_SENDING, doSetTyping, false, 0, true);
        }
        
        public function run(buddyName:String, typingStatus:String):void
        {
            var tEvent:TypingEvent = new TypingEvent(TypingEvent.TYPING_STATUS_SENDING, typingStatus, buddyName, true, true);
            dispatchEvent(tEvent);
        }
        
        private function doSetTyping(evt:TypingEvent):void {
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var method:String = "im/setTyping";
            var query:String = 
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId +
                "&t=" + encodeURIComponent(evt.aimId) + 
                "&typingStatus=" + evt.typingStatus;
            _logger.debug("SetTyping: " + _session.apiBaseURL + method + query);
            sendRequest(_session.apiBaseURL + method + query);
        }
        
        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            var loader:URLLoader = evt.target as URLLoader;
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:TypingEvent = getRequest(requestId) as TypingEvent;
            var newEvent:TypingEvent = new TypingEvent(TypingEvent.TYPING_STATUS_SEND_RESULT, oldEvent.typingStatus, oldEvent.aimId, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            _logger.debug("Set Typing Response: " + statusCode + ": " + statusText);
            dispatchEvent(newEvent);
        }
    }
}