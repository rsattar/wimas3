package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.net.ResultLoader;
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServInfo;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.events.IMServEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class CreateIMServ extends Transaction
    {
        public function CreateIMServ(session:Session)
        {
            super(session);
            addEventListener(IMServEvent.IMSERV_CREATING, doIMServCreate, false, 0, true);
        }
        
        
        public function run(imServInfo:IMServInfo, optionalContext:Object=null):void
        {
            dispatchEvent(new IMServEvent(IMServEvent.IMSERV_CREATING, imServInfo, optionalContext, true, true));
        }
        
        public function doIMServCreate(evt:IMServEvent):void
        {
            var method:String = "imserv/create";
            var info:IMServInfo = evt.imServ;
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            if(info.buddyIconId)
            {
                queryString += "&buddyIcon="+encodeURIComponent(info.buddyIconId);
            }
            if(info.description) // this also makes sure we don't pass ""
            {
                queryString += "&description="+encodeURIComponent(info.description);
            }
            queryString += "&displayType="+encodeURIComponent(info.blDisplayType);
            queryString += "&domain="+encodeURIComponent(info.domainName);
            queryString += "&enabled="+(info.enabled ? 1 : 0);
            queryString += "&f=amf3";
            queryString += "&friendly="+encodeURIComponent(info.friendlyName);
            queryString += "&imReplyType="+encodeURIComponent(info.imReplyType);
            if(info.imSoundId)
            {
                queryString += "&imSound="+encodeURIComponent(info.imSoundId);
            }
            queryString += "&k="+_session.devId;
            queryString += "&membershipPolicy="+encodeURIComponent(info.membershipPolicy);
            if(info.miniIconId)
            {
                queryString += "&miniIcon="+encodeURIComponent(info.miniIconId);
            }
            queryString += "&r="+requestId;
            for(var i:Number = 0; i<info.senderTypesAllowed.length; i++)
            {
                queryString += "&sendIMs="+ResultLoader.encodeStrPart(info.senderTypesAllowed[i]);
            }
            if(info.smallBuddyIconId)
            {
                queryString += "&smallBuddyIconId="+encodeURIComponent(info.smallBuddyIconId);
            }
            
            queryString += "&ts=" + getSigningTimestampValue(authToken);
            
            // Append the sig_sha256 data
            queryString += "&sig_sha256="+createSignatureFromQueryString(method, queryString);
            
            _logger.debug("CreateIMServ: "+queryString);
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
                // TODO: WIM API is kind of ambiguous, is the 'friendly' name request always the 'group' value? Do we need a separate 'groupName' property?
                imServInfo.friendlyName = _response.data.group;
                imServInfo.groupName = _response.data.group;
                imServInfo.id = _response.data.imserv;
            }
            else
            {
                trace("Error "+statusCode+" in createIMServ!");
            }
            
            _logger.debug("imserv/create response:\n {0}",_response);

            var newEvent:IMServEvent = new IMServEvent(IMServEvent.IMSERV_CREATE_RESULT, imServInfo, oldEvent.context, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            dispatchEvent(newEvent);       
        }
    }
}