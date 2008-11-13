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
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.events.UserAuthorizationEvent;
    
    import flash.events.Event;
    import flash.net.URLLoader;

    public class RequestAuthorization extends Transaction 
    {

        public function RequestAuthorization(session:Session) 
        {
            super(session);
        }
        
        public function run(contact:String, authorizationMsg:String=null):void 
        {
            var method:String = "buddylist/requestAuthorization";
            var query:String = 
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&t=" + encodeURIComponent(contact);
            if(authorizationMsg) 
            {
                query += "&authorizationMsg=" + encodeURIComponent(authorizationMsg);
            }
           
            _logger.debug("RequestAuthorization: " + _session.apiBaseURL + method + query);
            sendRequest(_session.apiBaseURL + method + query);
        }
        
        override protected function requestComplete(evt:Event):void 
        {
            super.requestComplete(evt);
            var loader:URLLoader = evt.target as URLLoader;
            
            var statusCode:uint = _response.statusCode;
            if(statusCode == 200) 
            {
                var newEvent:UserAuthorizationEvent = new UserAuthorizationEvent(UserAuthorizationEvent.USER_AUTHORIZATION_REQUEST_RESULT, true, true);
                dispatchEvent(newEvent);
            }                 
        }
    }
}