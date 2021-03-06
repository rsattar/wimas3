package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServMemberResultCode;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.events.IMServActionEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class RejectIMServ extends Transaction
    {
        public function RejectIMServ(session:Session)
        {
            super(session);
            addEventListener(IMServActionEvent.IMSERV_REJECTING, doInviteMembersToIMServ, false, 0, true);
        }
        
        public function run(imServId:String, memberIds:Array, optionalContext:Object = null):void
        {
            var event:IMServActionEvent = new IMServActionEvent(IMServActionEvent.IMSERV_REJECTING, imServId, memberIds, optionalContext, true, true);
            dispatchEvent(event);
        }
        
        protected function doInviteMembersToIMServ(evt:IMServActionEvent):void
        {
            var method:String = "imserv/reject";
            
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            queryString += "&f=amf3";
            queryString += "&imserv="+encodeURIComponent(evt.imServId);
            queryString += "&k="+_session.devId;
            queryString += "&r="+requestId;
            for each (var memberId:String in evt.relatedMemberIds) // if the sig param is being listened for, we probably need to alphabetize the values
            {
                queryString += "&t=" + encodeURIComponent(memberId);
            }
            queryString += "&ts=" + getSigningTimestampValue(authToken);
            
            // Append the sig_sha256 data
            queryString += "&sig_sha256="+createSignatureFromQueryString(method, queryString);
            
            _logger.debug("RejectIMServ: "+queryString);
            sendRequest(_session.apiBaseURL + method + "?"+queryString);
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            
            _logger.debug("RejectIMServ response: {0}", _response);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:IMServActionEvent = getRequest(requestId) as IMServActionEvent;
            var newEvent:IMServActionEvent = new IMServActionEvent(IMServActionEvent.IMSERV_REJECT_RESULT, oldEvent.imServId, oldEvent.relatedMemberIds, oldEvent.context, true, true);
            // TODO: copy over anything else relevant from the oldEvent
            newEvent.options = oldEvent.options;
            
            var results:Array = [];
            
            if(statusCode == 200) {
                var rawResultCodes:Array = _response.data.results;
                for each(var rawResultCode:Object in rawResultCodes)
                {
                    results.push(new IMServMemberResultCode(rawResultCode.member, rawResultCode.resultCode));
                }
            }
            else
            {
                trace("Error "+statusCode+" in RejectIMServ!");
            }
            
            newEvent.results = results;
            
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            dispatchEvent(newEvent);
        }
    }
}