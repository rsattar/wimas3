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

package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServInfo;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.data.types.IMServQuerySortOrder;
    import com.aol.api.wim.events.IMServQueryEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class GetMyIMServs extends Transaction
    {
        public function GetMyIMServs(session:Session)
        {
            super(session);
            addEventListener(IMServQueryEvent.IMSERV_LIST_GETTING, doGetIMServList, false, 0, true);
        }
        
        public function run(filters:Array, sortOrderType:String = "none", numberToGet:Number = -1, numberToSkip:Number = 0, optionalContext:Object = null):void
        {
            var event:IMServQueryEvent = new IMServQueryEvent(IMServQueryEvent.IMSERV_LIST_GETTING, filters, numberToGet, numberToSkip, optionalContext, true, true);
            dispatchEvent(event);
        }
        
        protected function doGetIMServList(evt:IMServQueryEvent):void
        {
            var method:String = "imserv/getMy";
            
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            queryString += "&f=amf3";
            if(evt.queryFilters.length > 0)
            {
                queryString += "&filter=";
            }
            queryString += "&k="+_session.devId;
            queryString += "&nToGet=" + evt.numberResultsToGet;
            if(evt.numberResultsToSkip != 0) queryString += "&nToSkip=" + evt.numberResultsToSkip;
            queryString += "&r="+requestId;
            if(evt.sortOrder != IMServQuerySortOrder.NONE)
            {
                queryString += "&sortOrder="+encodeURIComponent(evt.sortOrder);
            }
            
            queryString += "&ts=" + getSigningTimestampValue(authToken);
            
            // Append the sig_sha256 data
            queryString += "&sig_sha256="+createSignatureFromQueryString(method, queryString);
            
            _logger.debug("GetMyIMServs: "+queryString);
            sendRequest(_session.apiBaseURL + method + "?"+queryString);
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            
            _logger.debug("GetMyIMServs response: {0}", _response);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:IMServQueryEvent = getRequest(requestId) as IMServQueryEvent;
            var newEvent:IMServQueryEvent = new IMServQueryEvent(IMServQueryEvent.IMSERV_LIST_GET_RESULT, oldEvent.queryFilters, oldEvent.numberResultsToGet, oldEvent.numberResultsToSkip, oldEvent.context, true, true);
            newEvent.sortOrder = oldEvent.sortOrder;
            // TODO: copy over anything else relevant from the oldEvent
            
            
            var imServsFound:Array = [];
            
            if(statusCode == 200) {
                var rawIMServs:Array = _response.data.imservs;
                for each(var imservObj:Object in rawIMServs)
                {
                    // TODO: Create a "BlastResponseParser"
                    var imServInfo:IMServInfo = new IMServInfo(); // parse(imservObj)
                    imServInfo.friendlyName = imservObj.friendly;
                    imServInfo.id = imservObj.imserv;
                    // Owner-specific fields (MyIMServ)
                     /* 
                    imServInfo.ownerMemberType = imservObj.memberType;
                    imServInfo.ownerDate = imservObj.date;
                    imServInfo.ownerExpirationDate = imservObj.expireTime;
                    imServInfo.ownerInvitee:String = imservObj.invitee;
                    imServInfo.ownerReceivedTransferInvite = imservObj.ownerTransferInvited == 1 ? true : false;
                    imServInfo.ownerInvitationTime = imservObj.when;
                    if(imservObj.rights)
                    {
                        imServInfo.ownerRights = [] // parse imservObj.rights
                    }
                      */
                    
                    imServsFound.push(imServInfo);
                }
                newEvent.numResultsMatched = _response.data.numMatch;
                newEvent.numResultsRemaining = _response.data.numRemaining;
            }
            else
            {
                trace("Error "+statusCode+" in GetMyIMServs!");
            }
            
            newEvent.results = imServsFound;
            
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            dispatchEvent(newEvent);
        }
    }
}