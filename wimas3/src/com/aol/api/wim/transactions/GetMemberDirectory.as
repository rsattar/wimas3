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

package com.aol.api.wim.transactions {
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.MemberDirectoryEvent;
    
    import flash.events.Event;

    public class GetMemberDirectory extends Transaction {
        protected var language:String;
        
        public function GetMemberDirectory(session:Session, language:String) {
            super(session);
            this.language = language;
            addEventListener(MemberDirectoryEvent.DIRECTORY_GETTING, doGet, false, 0, true);
        }
        
        public function run(imId:String, level:String, context:Object):void {
            var event:MemberDirectoryEvent = new MemberDirectoryEvent(MemberDirectoryEvent.DIRECTORY_GETTING, true, true);
            event.searchTerms = {"imId": imId};
            event.level = level;
            event.context = context;
            dispatchEvent(event);
        }
        
        protected function doGet(event:MemberDirectoryEvent):void {
            var requestId:uint = storeRequest(event);
            event.requestId = requestId;
            var method:String = "memberDir/get";
            var query:String =
                "?f=amf3" +
                "&r=" + requestId +
                "&aimsid=" + _session.aimsid +
                "&locale=" + language +
                "&t=" + encodeURIComponent(event.searchTerms["imId"]) +
                "&infoLevel=" + event.level;
            sendRequest(_session.apiBaseURL + method + query, "GET", event.context);
        }
        
        override protected function requestComplete(event:Event):void {
            super.requestComplete(event);
            
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            
            var oldEvent:MemberDirectoryEvent = MemberDirectoryEvent(getRequest(requestId));
            var newEvent:MemberDirectoryEvent = new MemberDirectoryEvent(MemberDirectoryEvent.DIRECTORY_GET_RESULT, true, true);            
            newEvent.context = oldEvent.context;
            newEvent.searchResults = [];
            
            if (statusCode == 200) {
                _logger.debug("GetMemberDirectory data.results {0}", _response.data.results);
                if (_response.data.infoArray != null) {                
                    newEvent.searchResults = _response.data.infoArray;
                }
            } else {
                _logger.error("GetMemberDirectory request resulted in non-OK status");
            }
            
            dispatchEvent(newEvent);            
        }
    }
}