package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServMemberInfo;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.data.types.IMServQuerySortOrder;
    import com.aol.api.wim.events.IMServQueryEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class GetIMServMembers extends Transaction
    {
        public function GetIMServMembers(session:Session)
        {
            super(session);
            addEventListener(IMServQueryEvent.IMSERV_MEMBERS_GETTING, doGetIMServMembers, false, 0, true);
        }
        
        public function run(imServId:String, filters:Array, sortOrderType:String = "none", numberToGet:Number = -1, numberToSkip:Number = 0, optionalContext:Object=null):void
        {
            var event:IMServQueryEvent = new IMServQueryEvent(IMServQueryEvent.IMSERV_MEMBERS_GETTING, filters, numberToGet, numberToSkip, optionalContext, true, true);
            event.relatedIMServId = imServId;
            dispatchEvent(event);
        }
        
        protected function doGetIMServMembers(evt:IMServQueryEvent):void
        {
            var method:String = "imserv/getMembers";
            
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";
            var sig_sha256:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            queryString += "&f=amf3";
            if(evt.queryFilters.length > 0)
            {
                // TODO: Filter
                queryString += "&filter=";
            }
            queryString += "&imserv="+encodeURIComponent(evt.relatedIMServId);
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
            
            _logger.debug("GetIMServMembers: "+queryString);
            sendRequest(_session.apiBaseURL + method + "?"+queryString);
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            
            _logger.debug("GetIMServMembers response: {0}", _response);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:IMServQueryEvent = getRequest(requestId) as IMServQueryEvent;
            var newEvent:IMServQueryEvent = new IMServQueryEvent(IMServQueryEvent.IMSERV_MEMBERS_GET_RESULT, oldEvent.queryFilters, oldEvent.numberResultsToGet, oldEvent.numberResultsToSkip, oldEvent.context, true, true);
            newEvent.sortOrder = oldEvent.sortOrder;
            // TODO: copy over anything else relevant from the oldEvent
            newEvent.relatedIMServId = oldEvent.relatedIMServId;
            
            var members:Array = [];
            
            if(statusCode == 200) {
                // _response
                /*                 
                _response = Object (@13878769)  
                    data = Object (@138787e1)   
                        createTime = 1226952581 [0x4921cf85]    
                        members = Array (@13991b69) 
                            [0] = Object (@137f8381)    
                                member = "redriz"   
                                memberType = "owner"    
                            length = 1  
                        numMatch = 1    
                        numRemaining = 0    
                        totalCount = 1  
                    requestId = "1" 
                    statusCode = 200 [0xc8] 
                    statusText = "Ok"   
                 */
                if(_response.data.members)
                {
                    for each (var memberObj:Object in _response.data.members)
                    {
                        members.push(new IMServMemberInfo(memberObj.member, memberObj.memberType, memberObj.inviter, memberObj.ownerTransferInvited));
                    }   
                }
                
                newEvent.numResultsMatched = _response.data.numMatch;
                newEvent.numResultsRemaining = _response.data.numRemaining;
                // These two values are specific just for imserv/getMembers
                newEvent.imServCreateTime = new Date(_response.data.createTime * 1000);
                newEvent.numTotalResults = _response.data.totalCount;
            }
            else
            {
                trace("Error "+statusCode+" in GetIMServMembers!");
            }
            
            newEvent.results = members;
            
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            dispatchEvent(newEvent);
        }
        
    }
}