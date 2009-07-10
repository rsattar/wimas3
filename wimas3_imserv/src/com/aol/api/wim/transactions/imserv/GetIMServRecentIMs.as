package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServIM;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.data.types.IMServQuerySortOrder;
    import com.aol.api.wim.events.IMServQueryEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class GetIMServRecentIMs extends Transaction
    {
        public function GetIMServRecentIMs(session:Session)
        {
            super(session);
            addEventListener(IMServQueryEvent.IMSERV_RECENT_IMS_GETTING, doGetIMServRecentIMs, false, 0, true);
        }
        
        public function run(imServId:String, filters:Array, sortOrderType:String = "none", numberToGet:Number = -1, numberToSkip:Number = 0, optionalContext:Object=null):void
        {
            var event:IMServQueryEvent = new IMServQueryEvent(IMServQueryEvent.IMSERV_RECENT_IMS_GETTING, filters, numberToGet, numberToSkip, optionalContext, true, true);
            event.relatedIMServId = imServId;
            event.sortOrder = sortOrderType;
            dispatchEvent(event);
        }
        
        protected function doGetIMServRecentIMs(evt:IMServQueryEvent):void
        {
            var method:String = "imserv/fetchRecentIMs";
            
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
            
            _logger.debug("GetIMServRecentIMs: "+queryString);
            sendRequest(_session.apiBaseURL + method + "?"+queryString);
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            
            _logger.debug("GetIMServRecentIMs response: {0}", _response);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:IMServQueryEvent = getRequest(requestId) as IMServQueryEvent;
            var newEvent:IMServQueryEvent = new IMServQueryEvent(IMServQueryEvent.IMSERV_RECENT_IMS_GET_RESULT, oldEvent.queryFilters, oldEvent.numberResultsToGet, oldEvent.numberResultsToSkip, oldEvent.context, true, true);
            newEvent.sortOrder = oldEvent.sortOrder;
            newEvent.relatedIMServId = oldEvent.relatedIMServId;
            // TODO: copy over anything else relevant from the oldEvent
            
            var ims:Array = [];
            
            if(statusCode == 200) {
                var rawIMServIMs:Array = _response.data.msgs;
                for each(var rawIM:Object in rawIMServIMs)
                {
                    ims.push(new IMServIM(rawIM.message, new Date(rawIM.date * 1000), rawIM.sender, oldEvent.relatedIMServId));
                }
                newEvent.numResultsMatched = _response.data.numMatch;
                newEvent.numResultsRemaining = _response.data.numRemaining;
            }
            else
            {
                trace("Error "+statusCode+" in GetIMServRecentIMs!");
            }
            
            newEvent.results = ims;
            
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            dispatchEvent(newEvent);
        }
        
    }
}