package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServActivity;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.data.types.IMServQuerySortOrder;
    import com.aol.api.wim.events.IMServQueryEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class GetRecentIMServActivity extends Transaction
    {
        public function GetRecentIMServActivity(session:Session)
        {
            super(session);
            addEventListener(IMServQueryEvent.IMSERV_RECENT_ACTIVITY_GETTING, doGetIMServRecentActivity, false, 0, true);
        }
        
        public function run(imServIds:Array, filters:Array, sortOrderType:String = "none", numberToGet:Number = -1, numberToSkip:Number = 0, optionalContext:Object = null):void
        {
            var event:IMServQueryEvent = new IMServQueryEvent(IMServQueryEvent.IMSERV_RECENT_ACTIVITY_GETTING, filters, numberToGet, numberToSkip, optionalContext, true, true);
            event.relatedIMServIds = imServIds;
            dispatchEvent(event);
        }
        
        protected function doGetIMServRecentActivity(evt:IMServQueryEvent):void
        {
            var method:String = "imserv/getRecentActivity";
            
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
            //for each(var imServId:String in evt.relatedIMServIds)
            for (var i:Number=0; i<evt.relatedIMServIds.length; i++)
            {
                queryString += "&imserv="+encodeURIComponent(evt.relatedIMServIds[i]);
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
            
            _logger.debug("GetIMServRecentActivity: "+queryString);
            sendRequest(_session.apiBaseURL + method + "?"+queryString);
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            
            _logger.debug("GetIMServRecentActivity response: {0}", _response);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:IMServQueryEvent = getRequest(requestId) as IMServQueryEvent;
            
            // This is a special case where we dispatch multiple GET_RESULT events, one for each imserv in the response
            // This is because host decided to be "convenient" by providing multiple responses per request, but that basically means
            // they just concatenate the individual responses from each imserv. That is, the top-level statusCode/statusText don't mean anything *sigh*
            
            // The overall request succeeded
            if(statusCode == 200) {
                var rawIMServActivities:Array = _response.data.imservActivities;
                for each(var activityByIMServ:Object in rawIMServActivities)
                {
                    var imServ:String = activityByIMServ.imserv;
                            
                    var newEvent:IMServQueryEvent = new IMServQueryEvent(IMServQueryEvent.IMSERV_RECENT_ACTIVITY_GET_RESULT, oldEvent.queryFilters, oldEvent.numberResultsToGet, oldEvent.numberResultsToSkip, oldEvent.context, true, true);
                    newEvent.sortOrder = oldEvent.sortOrder;
                    // TODO: copy over anything else relevant from the oldEvent
                    
                    // Check if this imserv response succeeded
                    if(activityByIMServ.code == 200)
                    {
                        var imServActivities:Array = [];
                        if(activityByIMServ.activities != null)
                        {
                            // TODO verify that this is the format
                            for each(var activity:Object in activityByIMServ.activities)
                            {
                                imServActivities.push(new IMServActivity(activity.action, new Date(activity.timestamp * 1000), activity.member1, activity.member2));
                            }
                            
                            newEvent.results = imServActivities;
                        }
                    }
                    else
                    {
                        trace("Error "+activityByIMServ.code+" in GetIMServRecentActivity for imServ: '"+imServ+"'");
                    }
                    newEvent.relatedIMServId = imServ;
                    newEvent.numResultsMatched = activityByIMServ.numMatch;
                    newEvent.numResultsRemaining = activityByIMServ.numRemaining;
                    newEvent.resultData = new ResultData(activityByIMServ.code); // this "convienient" information also doesn't include statusText
                    
                    // Dispatch one event per imserv whose activity was returned
                    _logger.debug("Dispatching IMServQueryEvent.IMSERV_RECENT_ACTIVITY_GET_RESULT for "+imServ);
                    dispatchEvent(newEvent);
                }
            
            }
            else
            {
                trace("Error "+statusCode+" in GetIMServRecentActivity!");
            }
        }
        
    }
}