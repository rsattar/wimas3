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
    import com.aol.api.wim.data.SMSInfo;
    import com.aol.api.wim.data.SMSSegment;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.interfaces.IResponseParser;
    
    public class XMLResponseParser implements IResponseParser {
        
        // Define the XML namespace used by WIM api responses
        private namespace aimNS             = "http://developer.aim.com/xsd/aim.xsd";
        // Ensure namespace is set (for this class) or E4X won't work.
        use namespace aimNS;
        
        /**
         * Converts XML to a <code>User</code> object.
         * @param data
         * @return A <code>User</code> object.
         * 
         */      
        public function parseUser(data:*):User {
            if(!data) { return null; }
            
            var xml:XML = new XML(data);
            var u:User = new User();
            u.aimId             = xml.aimId.text();
            u.displayId         = xml.displayId.text();
            u.state             = xml.state.text();
            u.onlineTime        = Number(xml.onlineTime.text());
            u.awayTime          = Number(xml.awayTime.text()); // in minutes?
            u.statusTime        = Number(xml.statusTime.text()); // TODO: Turn into date
            u.awayMessage       = xml.awayMsg.text();
            u.profileMessage    = xml.profileMsg.text();
            u.statusMessage     = xml.statusMsg.text();;
            u.buddyIconURL      = xml.buddyIcon.text();
            u.presenceIconURL   = xml.presenceIcon.text()
            u.capabilities      = parseCapabilities(xml.capabilities.text());
            //
            u.friendlyName      = xml.friendly.text();
            u.countryCode       = xml.ipCountry.text();
            u.sms               = parseSMSSegment(xml.smsSegment);
            u.smsNumber         = xml.smsNumber.text();
            u.bot               = parseBot(xml);
            u.nonBuddy          = (xml.nonBuddy > 0)?true:false;
            u.invisible         = (xml.invisible && (xml.invisible > 0))?true:false;
            u.userType          = xml.userType.text();
            return u;
        }
        
        public function parseBot(data:*):Boolean {
            if (data.bot && data.bot > 0) {
                return true;
            } 
            return false; 
        }
        
        public function parseSMSSegment(data:*):SMSSegment {
            if(!data || (data as XMLList).length() == 0) { return null; }
            var sms:SMSSegment = new SMSSegment();
            sms.initial     = data.initial.text();
            sms.single      = data.single.text();
            sms.trailing    = data.trailing.text();            
            return sms;           
        }
        
        /**
         * Converts XML to a <code>BuddyList</code> object.
         * @param data
         * @return A <code>BuddyList</code> object.
         * 
         */  
        public function parseBuddyList(data:*, owner:User=null):BuddyList {
            if(!data) { return null; }
            var xml:XML = XML(data);
            // Create group array
            var xmlGroupsList:XMLList = xml.groups.group;
            var groups:Array = new Array();
            
            for each (var xmlGroup:XML in xmlGroupsList) {
                var g:Group = parseGroup(xmlGroup);//new Group(xmlGroup.name.text(), users);
                groups.push(g);
            }
            
            // We leave the owner undefined, because we parse with no context
            var bl:BuddyList = new BuddyList(owner, groups);
            return bl;
        }
        
        /**
         * Converts XML to a <code>Group</code> object.
         * @param data
         * @return A <code>Group</code> object.
         * 
         */  
        public function parseGroup(data:*):Group {
            if(!data) {return null;}
            var gXML:XML = XML(data);

            // Create user array
            var xmlUsersList:XMLList = gXML.buddies.buddy;
            var users:Array = new Array();
            
            for each (var xmlUser:XML in xmlUsersList) {
                users.push(parseUser(xmlUser));
            }
            
            return new Group(gXML.name.text(), users);
        }
        
        /**
         * Converts XML to an <code>IM</code> object.
         * @param data
         * @return An <code>IM</code> object.
         * 
         */  
        public function parseIM(data:*, recipient:User=null, isOffline:Boolean=false):IM {
            if(!data) { return null; }
            
            var xml:XML = XML(data);

            var source:User = null;
            var isAutoResponse:Boolean = false;
            if(!isOffline) {
                source = parseUser(xml.source);
                isAutoResponse = Boolean(xml.autoResponse.text());
            } else {
                // we don't look for isAutoResponse
                // we use a 'aimId' string for a User, not Presence data 
                source = new User();
                source.aimId = xml.aimId.text();
            }            
            var msg:String = xml.message.text();
            var timestamp:uint = uint(xml.timestamp.text());
            return new IM(msg, new Date(timestamp), source, recipient, true, isAutoResponse, isOffline);
        }
        
        
        public function parseSMSInfo(data:*):SMSInfo {
            if(!data) { return null; }
            
            namespace imNS             = "http://developer.aim.com/xsd/im.xsd";
            use namespace imNS;
            var xml:XML = XML(data);
            
            var smsInfo:SMSInfo = new SMSInfo();
            
            smsInfo.errorCode = Number(xml.smsError.text());
            smsInfo.reasonText = String(xml.smsReason.text());
            smsInfo.carrierId = Number(xml.smsCarrierID.text());
            smsInfo.remainingCount = Number(xml.smsRemainingCount.text());
            smsInfo.maxAsciiLength = Number(xml.smsMaxAsciiLength.text());
            smsInfo.maxUnicodeLength = Number(xml.smsMaxUnicodeLength.text());
            smsInfo.carrierName = String(xml.smsCarrierName.text());
            smsInfo.carrierUrl = String(xml.smsCarrierUrl.text());
            smsInfo.balanceGroup = String(xml.smsBalanceGroup.text());
            
            return smsInfo;
        }
        
        /**
         * Converts XML into a <code>DataIM</code> object
         * @param data
         * @return An <code>DataIM</code> object
         * 
         */        
        public function parseDataIM(data:*, recipient:User=null):DataIM {
            
            if(!data) { return null; }
            
            var xml:XML = XML(data);
            var source:User         = parseUser(xml.source);
            var msg:String          = xml.dataIM.text();
            var capability:String   = xml.dataCapability.text();
            var inviteMsg:String    = xml.inviteMsg.text(); // How do we determine if this value is null?
            var dataType:String  = xml.dataType.text();
            return new DataIM(msg, dataType, new Date(), source, recipient, capability, inviteMsg);
        }
        
        private function parseCapabilities(data:XMLList):Array {
            if(!data) { return null; }
            
            var caps:Array = new Array();
            
            for each(var capXML:XML in data) {
                caps.push(capXML.capability.text());
            }
            return caps;
        }
    }
}