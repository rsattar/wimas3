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
    import com.aol.api.wim.data.IM;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.events.IMEvent;
    
    import flash.events.Event;

    public class SendIM extends Transaction
    {
        protected function get format():String{ return "amf3"; }
        
        public function SendIM(session:Session)
        {
            super(session);
            addEventListener(IMEvent.IM_SENDING, doIMSend, false, 0, true);
        }
        
        public function run(buddyName:String, message:String, autoResponse:Boolean=false, offlineIM:Boolean=false):void {
            //TODO: normalize name in some way?
            var buddy:User = new User();
            buddy.aimId = buddyName;
            var im:IM = new IM(message, new Date(), _session.myInfo, buddy, false, autoResponse, offlineIM);
            dispatchEvent(new IMEvent(IMEvent.IM_SENDING, im, true, true));
        }
        
        protected function doIMSend(evt:IMEvent):void {
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            evt.requestId = requestId;
            var method:String = "im/sendIM";
            var query:String = 
                "?f=" + format +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId +
                "&t=" + encodeURIComponent(evt.im.recipient.aimId) +
                "&message=" + encodeURIComponent(evt.im.message) + 
                "&autoResponse=" + evt.im.isAutoResponse + 
                "&offlineIM=" + evt.im.isOfflineMessage +
                "&comscoreChannel=" + _session.comScoreId;
            _logger.debug("SendIMQuery: " + _session.apiBaseURL + method + query);
            sendRequest(_session.apiBaseURL + method + query);            
        }
        
        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            handleResponse();
        }
        
        protected function handleResponse():void {
            var statusCode:String = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            
            //get the old event so we can create the new event
            var oldEvent:IMEvent = getRequest(requestId) as IMEvent;
            var newEvent:IMEvent = new IMEvent(IMEvent.IM_SEND_RESULT, oldEvent.im, true, true);
            newEvent.statusCode = statusCode;
            newEvent.statusText = statusText;
            _logger.debug("SendIM Response: " + statusCode + ": " + statusText);
            dispatchEvent(newEvent);
        }
        
    }
}