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
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.events.BuddyListEvent;
    
    import flash.events.Event;
    import flash.net.URLLoader;

    public class RenameGroup extends Transaction
    {
        public function RenameGroup(session:Session)
        {
            super(session);
            addEventListener(BuddyListEvent.GROUP_REMOVING, doGroupRename, false, 0, true);
        }
        
        public function run(oldName:String, newName:String):void {
            //TODO: Params checking before dispatching event
            var oldGroup:Group = new Group(oldName);
            var newGroup:Group = new Group(newName);
            var evt:BuddyListEvent = new BuddyListEvent(BuddyListEvent.GROUP_REMOVING, null, newGroup, null, null, true, true);
            evt.oldGroup = oldGroup;
            dispatchEvent(evt);
        }
        
        private function doGroupRename(evt:BuddyListEvent):void {
            var method:String = "buddylist/renameGroup";
            
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            queryString += "&f=amf3";
            queryString += "&k="+_session.devId;
            queryString += "&newGroup=" + encodeURIComponent(evt.group.label);
            queryString += "&oldGroup=" + encodeURIComponent(evt.oldGroup.label);
            queryString += "&r="+requestId;
            queryString += "&ts=" + getSigningTimestampValue(authToken);
            // Append the sig_sha256 data
            queryString += "&sig_sha256="+createSignatureFromQueryString(method, queryString);
            _logger.debug("RenameGroup: "+queryString);
            sendRequest(_session.apiBaseURL + method + "?"+queryString);
        }
        
        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            var loader:URLLoader = evt.target as URLLoader;
                        
            var statusCode:uint = _response.statusCode;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:BuddyListEvent = getRequest(requestId) as BuddyListEvent;
            if(statusCode == 200) {
            }
            var newEvent:BuddyListEvent = new BuddyListEvent(BuddyListEvent.GROUP_RENAME_RESULT, null, oldEvent.group, null, null, true, true);
            newEvent.oldGroup = oldEvent.oldGroup;
            dispatchEvent(newEvent);
        }
        
    }
}