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

    /**
     * This transaction lets us manage an existing imserv that we are an owner/editor of.
     * 
     * TODO: Figure out how best to support "removing" or "clearing" some params. Is an
     * empty string ("") enough?
     *  
     * @author Rizwan
     * 
     */
    public class SetIMServSettings extends Transaction
    {
        public function SetIMServSettings(session:Session)
        {
            super(session);
            addEventListener(IMServEvent.IMSERV_SETTINGS_UPDATING, doSetIMServSettings, false, 0, true);
        }
        
        public function run(imServ:IMServInfo, optionalContext:Object = null):void
        {
            dispatchEvent(new IMServEvent(IMServEvent.IMSERV_SETTINGS_UPDATING, imServ, optionalContext, true, true));
        }
        
        public function doSetIMServSettings(evt:IMServEvent):void
        {
            var method:String = "imserv/setSettings";
            var info:IMServInfo = evt.imServ;
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            if(info.buddyIconId != null)
            {
                queryString += "&buddyIcon="+encodeURIComponent(info.buddyIconId);
            }
            if(info.creationDate != null)
            {
                queryString += "&createDate=" + info.creationDate.dateUTC; // is this the right format? --riz
            }
            if(info.description != null)
            {
                queryString += "&description="+encodeURIComponent(info.description);
            }
            if(info.blDisplayType != null)
            {
                queryString += "&displayType="+encodeURIComponent(info.blDisplayType);
            }
            /* queryString += "&domain="+encodeURIComponent(info.domainName); */
            queryString += "&enabled="+(info.enabled ? 1 : 0);
            
            queryString += "&f=amf3";
            if(info.friendlyName != null)
            {
                queryString += "&friendly="+encodeURIComponent(info.friendlyName);
            }
            if(info.imReplyType != null)
            {
                queryString += "&imReplyType="+encodeURIComponent(info.imReplyType); 
            }
            // Required property
            queryString += "&imserv="+encodeURIComponent(evt.imServ.id);
            if(info.imSoundId != null)
            {
                queryString += "&imSound="+encodeURIComponent(info.imSoundId);
            }
            queryString += "&k="+_session.devId;
            if(info.membershipPolicy != null)
            {
                queryString += "&membershipPolicy="+encodeURIComponent(info.membershipPolicy);  
            }
            if(info.miniIconId != null)
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
            
            _logger.debug("SetIMServSettings: "+queryString);
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
                trace("Error "+statusCode+" in SetIMServSettings!");
            }
            
            _logger.debug("imserv/setSettings response:\n {0}",_response);

            var newEvent:IMServEvent = new IMServEvent(IMServEvent.IMSERV_SETTINGS_UPDATE_RESULT, imServInfo, oldEvent.context, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            dispatchEvent(newEvent);       
        }
    }
}