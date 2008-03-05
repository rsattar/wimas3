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
    import com.aol.api.wim.AMFResponseParser;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.events.UserEvent;
    import com.aol.api.wim.interfaces.IResponseParser;
    
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.utils.ByteArray;

    public class GetPresence extends Transaction
    {
        /**
         * This transaction does not fire a "pre" event. The request is made immediately
         * when run() is called. 
         *  
         * @param session
         * 
         */
        public function GetPresence(session:Session)
        {
            super(session);
        }
        
        /**
         * This transaction does not fire a "pre" event. The request is made immediately
         * when run() is called. 
         * 
         * For options, the following params are available. They should be properties 
         * on the options object.
         * 
         * Boolean    awayMsg       [Default 0] - Return away messages
         * Boolean    profileMsg    [Default 0] - Return profile messages
         * Boolean    presenceIcon  [Default 1] - Return presence icon
         * Boolean    location      [Default 1] - Return location information
         * Boolean    capabilities  [Default 0] - Return capability information
         * Boolean    memberSince   [Default 0] - Return member since information
         * Boolean    statusMsg     [Default 0] - Return status message information
         * Boolean    friendly      [Default 0] - Return friendly name
         * 
         * @param usernames An array of usernames to request presence for
         * @param options   [optional] An object with parameters 
         * 
         */
        public function run(usernames:Array, options:Object=null):void
        {
            if(usernames.length > 0)
            {
                var method:String = "presence/get";
                var query:String = 
                    "?f=amf3" +
                    "&aimsid=" + _session.aimsid;
                for(var i:int=0; i<usernames.length; i++)
                {
                    query += "&t=" + usernames[i];
                }
                if(options)
                {
                    if(options.awayMsg && options.awayMsg != false) query += "&awayMsg=1";
                    if(options.profileMsg && options.profileMsg != false) query += "&profileMsg=1";
                    if(options.presenceIcon && options.presenceIcon != true) query += "&presenceIcon=0";
                    if(options.location && options.location != true) query += "&location=0";
                    if(options.capabilities && options.capabilities != false) query += "&capabilities=1";
                    if(options.memberSince && options.memberSince != false) query += "&memberSince=1";
                    if(options.statusMsg && options.statusMsg != false) query += "&statusMsg=1";
                    if(options.friendly && options.friendly != false) query += "&friendly=1";
                }
                _logger.debug("GetPresenceQuery: " + _session.apiBaseURL + method + query);
                sendRequest(_session.apiBaseURL + method + query);            
            }
        }

        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            var loader:URLLoader = evt.target as URLLoader;
            //_logger.debug("AddBuddy Response XML: "+String(loader.data));
            
            var statusCode:uint = _response.statusCode;
            //get the old event so we can create the new event
            if(statusCode == 200) {
                if(_response.data && _response.data.users)
                {
                    var users:Array = _response.data.users as Array;
                    if(users)
                    {
                        var parser:IResponseParser = new AMFResponseParser();
                        for(var i:int=0; i<users.length; i++)
                        {
                            var user:User = parser.parseUser(users[i]);
                            dispatchEvent(new UserEvent(UserEvent.BUDDY_PRESENCE_UPDATED, user, true, true));
                        }
                    }
                }
            }                 
        }
    }
}