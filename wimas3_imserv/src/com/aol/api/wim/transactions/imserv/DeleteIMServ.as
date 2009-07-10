package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServInfo;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.events.IMServEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class DeleteIMServ extends Transaction
    {
        public function DeleteIMServ(session:Session)
        {
            super(session);
            addEventListener(IMServEvent.IMSERV_DELETING, doIMServDelete, false, 0, true);
        }
        
        public function run(imServId:String, optionalContext:Object=null):void
        {
            var imServ:IMServInfo = new IMServInfo();
            imServ.id = imServId;
            dispatchEvent(new IMServEvent(IMServEvent.IMSERV_DELETING, imServ, optionalContext, true, true));
        }
        
        public function doIMServDelete(evt:IMServEvent):void
        {
            var method:String = "imserv/delete";
            var info:IMServInfo = evt.imServ;
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";
            var sig_sha256:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            queryString += "&f=amf3";
            queryString += "&imserv="+encodeURIComponent(info.id);
            queryString += "&k="+_session.devId;
            queryString += "&r="+requestId;
            
            queryString += "&ts=" + getSigningTimestampValue(authToken);
            
            // Append the sig_sha256 data
            queryString += "&sig_sha256="+createSignatureFromQueryString(method, queryString);
            
            _logger.debug("DeleteIMServ: "+queryString);
            sendRequest(_session.apiBaseURL + method + "?"+queryString);
            
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:IMServEvent = getRequest(requestId) as IMServEvent;
            var imServInfo:IMServInfo = oldEvent.imServ;
            
            if(statusCode == 200) {
                
            }
            else
            {
                trace("Error "+statusCode+" in deleteIMServ!");
            }
            
            _logger.debug("imserv/delete response:\n {0}",_response);

            var newEvent:IMServEvent = new IMServEvent(IMServEvent.IMSERV_DELETE_RESULT, imServInfo, oldEvent.context, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            dispatchEvent(newEvent);       
        }
    }
}