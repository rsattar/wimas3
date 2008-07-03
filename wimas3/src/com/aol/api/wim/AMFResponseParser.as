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

package com.aol.api.wim {
    
    import com.aol.api.wim.data.BuddyList;
    import com.aol.api.wim.data.DataIM;
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.data.IM;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.interfaces.IResponseParser;

    public class AMFResponseParser implements IResponseParser {
        
        public function AMFResponseParser() {
            super();
        }

        public function parseUser(data:*):User {
            var u:User = new User();
            u.aimId             = data.aimId;
            u.displayId         = data.displayId;
            u.friendlyName      = data.friendly;
            u.state             = data.state;
            u.onlineTime        = data.onlineTime;
            u.awayTime          = data.awayTime; // in minutes?
            u.statusTime        = data.statusTime; // TODO: Turn statusTime into date
            u.awayMessage       = data.awayMsg;
            u.profileMessage    = data.profileMsg;
            u.statusMessage     = data.statusMsg;;
            u.buddyIconURL      = data.buddyIcon;
            u.presenceIconURL   = data.presenceIcon
            u.capabilities      = parseCapabilities(data.capabilities);
            u.countryCode       = data.ipCountry;
            return u;
        }
        
        public function parseBuddyList(data:*, owner:User=null):BuddyList {
            if(!data) { return null; }
            
            // Create group array
            var groups:Array = new Array();
            
            for each (var groupObj:Object in data.groups) {
                var g:Group = parseGroup(groupObj);//new Group(xmlGroup.name.text(), users);
                groups.push(g);
            }
            
            // We leave the owner undefined, because we parse with no context
            var bl:BuddyList = new BuddyList(owner, groups);
            return bl;
        }
        
        public function parseGroup(data:*):Group {
            // buddies array
            // 'name' string
            if(!data) {return null;}
            var buddies:Array = data.buddies;

            // Create user array
            var users:Array = new Array();
            
            for each (var buddyObj:Object in buddies) {
                users.push(parseUser(buddyObj));
            }
            
            var g:Group = new Group(data.name, users);
            if(data.recent == 1) g.recent = true;
            return g;
        }
        
        // TODO: Verify that parseIM works once we get IM send/recv working
        public function parseIM(data:*, recipient:User=null, isOffline:Boolean=false):IM {
            if(!data) { return null; }

            var source:User = null;
            var isAutoResponse:Boolean = false;
            if(!isOffline) {
                source = parseUser(data.source);
                isAutoResponse = data.autoresponse;
            } else {
                // we don't look for isAutoResponse
                // we use a 'aimId' string for a User, not Presence data 
                source = new User();
                source.aimId = data.aimId;
            }            
            var msg:String = data.message;
            var timestamp:uint = data.timestamp;
            return new IM(msg, new Date(timestamp*1000), source, recipient, true, isAutoResponse, isOffline);
        }
        
        // TODO: Verify that parseDataIM works once we get IM send/recv working
        public function parseDataIM(data:*, recipient:User=null):DataIM {
            if(!data) { return null; }
            var source:User         = parseUser(data.source);
            var msg:String          = data.dataIM;
            var capability:String   = data.dataCapability;
            var inviteMsg:String    = data.inviteMsg; // How do we determine if this value is null?
            var dataType:String  = data.dataType;
            return new DataIM(msg, dataType, new Date(), source, recipient, capability, inviteMsg);
        }
        
        private function parseCapabilities(data:Array):Array {
            
            var caps:Array = new Array();
            
            if(data) {
                for each(var cap:String in data) {
                    //caps.push(capXML.capability.text());
                    caps.push(cap);
                }
            }
            return caps;
        }
        
    }
}