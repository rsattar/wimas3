package com.aol.api.wim.transactions
{
    import com.aol.api.net.ResultLoader;
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.events.AttributeEvent;
    
    import flash.events.Event;

    public class GetBuddyAttribute extends Transaction
    {
        public function GetBuddyAttribute(session:Session)
        {
            //TODO: implement function
            super(session);
            addEventListener(AttributeEvent.BUDDY_ATTRIBUTE_GETTING, doGetAttribute, false, 0, true);
        }
        
        public function run(buddy:String):void
        {
            var user:User = new User();
            user.aimId = buddy;
            dispatchEvent(new AttributeEvent(AttributeEvent.BUDDY_ATTRIBUTE_GETTING, user, null, true, true));
        }
        
        public function doGetAttribute(evt:AttributeEvent):void
        {
            var method:String = "buddylist/getBuddyAttribute";
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";
            var sig_sha256:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;         
            queryString += "&f=amf3";
            queryString += "&k="+_session.devId;
            queryString += "&aimsid="+_session.aimsid;
            queryString += "&buddy="+encodeURIComponent(evt.user.aimId);
            queryString += "&r="+requestId;
            
            var now:Number = new Date().getTime() / 1000;           
            _logger.debug("Host Time: {0}, Now: {1}", authToken.hostTime, now);
            queryString += "&ts="+ int(authToken.hostTime + Math.floor(now - authToken.clientTime));
            
            var encodedQuery:String = escape(queryString);
            
            
            //_logger.debug("AIMBaseURL     : "+apiBaseURL + method);
            //_logger.debug("QueryParams    : "+queryString);
            //_logger.debug("Session Key    : "+_sessionKey);
        
        
            // Generate OAuth Signature Base
            var sigBase:String = "GET&"+ResultLoader.encodeStrPart(_session.apiBaseURL + method)+"&"+encodedQuery;
            //_logger.debug("Signature Base : "+sigBase);
            // Generate hash signature
            var sigData:String = generateSignature(sigBase, _session.sessionKey);//(new HMAC()).SHA256_S_Base64(_sessionKey, sigBase);
            sig_sha256 = sigData;
            //_logger.debug("Signature Hash : "+encodeURIComponent(sig_sha256));

            // Append the sig_sha256 data
            queryString += "&sig_sha256="+encodeURIComponent(sig_sha256);
            _logger.debug("GetBuddyAttribute: "+queryString);
            sendRequest(_session.apiBaseURL + method + "?"+queryString);
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:AttributeEvent = getRequest(requestId) as AttributeEvent;
            var attributes:Object = null;
            
            if(statusCode == 200) {
                trace("Retrieving attributes");
                attributes = _response.data;
            }     
            
            _logger.debug("buddyList/getBuddyAttribute response:\n {0}",_response);

            var newEvent:AttributeEvent = new AttributeEvent(AttributeEvent.BUDDY_ATTRIBUTE_GET_RESULT, oldEvent.user, attributes, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            dispatchEvent(newEvent);       
        }
    }
}