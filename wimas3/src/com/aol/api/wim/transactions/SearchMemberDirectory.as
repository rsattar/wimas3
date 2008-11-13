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
    import com.aol.api.wim.events.MemberDirectoryEvent;
    
    import flash.events.Event;

    public class SearchMemberDirectory extends Transaction
    {
        protected var language:String;
        
        public function SearchMemberDirectory(session:Session, language:String)
        {
            super(session);
            this.language = language;
            addEventListener(MemberDirectoryEvent.DIRECTORY_SEARCHING, doSearch, false, 0, true);
        }
        
        public function run(searchTerms:Object):void
        {
            var event:MemberDirectoryEvent = new MemberDirectoryEvent(MemberDirectoryEvent.DIRECTORY_SEARCHING, true, true);
            event.searchTerms = searchTerms;
            dispatchEvent(event);
        }
        
        protected function doSearch(event:MemberDirectoryEvent):void
        {
            var requestId:uint = storeRequest(event);
            event.requestId = requestId;
            var method:String = "memberDir/search";
            var query:String =
                "?f=amf3" +
                "&r=" + requestId +
                "&aimsid=" + _session.aimsid +
                "&locale=" + language +
                // TODO:  Should probably make this a parameter in the future.
                "&nToGet=50" +
                "&match=" + buildMatchString(event.searchTerms);
            sendRequest(_session.apiBaseURL + method + query);
        }
        
        protected function buildMatchString(o:Object):String
        {
            var ret:String = "";
            
            for (var key:String in o)
            {
                ret += key + '=' + encodeURIComponent(o[key]) + ',';
            }
            
            return (ret.replace(/,$/, ""));
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            
            var oldEvent:MemberDirectoryEvent = MemberDirectoryEvent(getRequest(requestId));
            var newEvent:MemberDirectoryEvent = new MemberDirectoryEvent(MemberDirectoryEvent.DIRECTORY_SEARCH_RESULT, true, true);
            newEvent.statusCode = statusCode;
            if (statusCode == 200)
            {
                newEvent.searchResults   = (_response.data.results.infoArray) ? _response.data.results.infoArray : new Array();
                newEvent.skippedProfiles = (isNaN(parseInt(_response.data.results.nSkipped)))? 0 : parseInt(_response.data.results.nSkipped);
                newEvent.totalProfiles   = (isNaN(parseInt(_response.data.results.nTotal)))? 0 : parseInt(_response.data.results.nTotal);
                newEvent.numProfiles     = (isNaN(parseInt(_response.data.results.nProfiles)))? 0 : parseInt(_response.data.results.nProfiles);
            }
            else
            {
                _logger.error("MemberDirectorySearch request resulted in non-OK status");
            }
            dispatchEvent(newEvent);
        }
        
    }
}