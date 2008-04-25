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
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.events.BuddyListEvent;
    
    import flash.events.Event;
    import flash.net.URLLoader;

    public class AddBuddy extends Transaction {
        // Ensure namespace is set (for this class) or E4X won't work.
        // TODO: where is the best place to declar this so it can be changed?
        public function AddBuddy(session:Session) {
            super(session);
            addEventListener(BuddyListEvent.BUDDY_ADDING, doAddBuddy, false, 0, true);
        }
        
        public function run(buddyName:String, groupName:String, authorizationMsg:String=null, preAuthorized:Boolean=false):void {
            //TODO: Params checking before dispatching event
            var user:User = new User();
            user.aimId = buddyName;
            var group:Group = new Group(groupName);
            var evt:BuddyListEvent = new BuddyListEvent(BuddyListEvent.BUDDY_ADDING, user, group, null, true, true);
            if(authorizationMsg)
                evt.authorizationMsg = authorizationMsg;
            evt.preAuthorized = preAuthorized;
            dispatchEvent(evt);
        }
        
        private function doAddBuddy(evt:BuddyListEvent):void {
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var method:String = "buddylist/addBuddy";
            var query:String = 
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId +
                "&buddy=" + encodeURIComponent(evt.buddy.aimId) +
                "&group=" + encodeURIComponent(evt.group.label);
            if(evt.authorizationMsg) 
                query += "&authorizationMsg=" + encodeURIComponent(evt.authorizationMsg);
            if(evt.preAuthorized)
                query += "&preAuthorized=true";
            _logger.debug("AddBuddyQuery: " + _session.apiBaseURL + method + query);
            sendRequest(_session.apiBaseURL + method + query);
        }
        
        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            var loader:URLLoader = evt.target as URLLoader;
            //_logger.debug("AddBuddy Response XML: "+String(loader.data));
            
            var statusCode:uint = _response.statusCode;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:BuddyListEvent = getRequest(requestId) as BuddyListEvent;
            if(statusCode == 200) {
                var newEvent:BuddyListEvent = new BuddyListEvent(BuddyListEvent.BUDDY_ADD_RESULT, oldEvent.buddy, oldEvent.group, null, true, true);
                dispatchEvent(newEvent);
            }                 
        }
    }
}