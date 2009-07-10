package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServInfo;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.events.IMServEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class GetIMServSettings extends Transaction
    {
        public function GetIMServSettings(session:Session)
        {
            super(session);
            addEventListener(IMServEvent.IMSERV_SETTINGS_GETTING, doGetIMServSettings, false, 0, true);
        }
        
        public function run(imServId:String, optionalContext:Object=null):void
        {
            var imServ:IMServInfo = new IMServInfo();
            imServ.id = imServId;
            dispatchEvent(new IMServEvent(IMServEvent.IMSERV_SETTINGS_GETTING, imServ, optionalContext, true, true));
        }
        
        public function doGetIMServSettings(evt:IMServEvent):void
        {
            var method:String = "imserv/getSettings";
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var queryString:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            queryString += "&f=amf3";
            queryString += "&imserv="+encodeURIComponent(evt.imServ.id);
            queryString += "&k="+_session.devId;
            queryString += "&r="+requestId;
            
            queryString += "&ts=" + getSigningTimestampValue(authToken);
            
            // Append the sig_sha256 data
            queryString += "&sig_sha256="+createSignatureFromQueryString(method, queryString);
            
            _logger.debug("GetIMServSettings: "+queryString);
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
                var rawData:Object = _response.data;
                /* 
                _response = Object (@13c23ee9)  
                    data = Object (@13c23dd1)   
                        createDate = 1227222386 [0x4925ed72]    
                        description = "foochatroom" 
                        displayType = "withMembers" 
                        enabled = 1 
                        friendly = "imserv1"    
                        imReplyType = "imserv"  
                        membershipPolicy = "open"   
                        sendIMs = Array (@11e20dd1) 
                            [0] = "member"  
                            length = 1  
                    requestId = "1" 
                    statusCode = 200 [0xc8] 
                    statusText = "Ok"   
                 */
                imServInfo.creationDate = new Date(rawData.createDate * 1000);
                imServInfo.description = rawData.description;
                imServInfo.blDisplayType = rawData.displayType;
                imServInfo.enabled = rawData.enabled;
                imServInfo.friendlyName = rawData.friendly;
                imServInfo.imReplyType = rawData.imReplyType;
                imServInfo.membershipPolicy = rawData.membershipPolicy;
                for each(var imSenderType:String in rawData.sendIMs)
                {
                    imServInfo.senderTypesAllowed.push(imSenderType);
                }
            }
            else
            {
                trace("Error "+statusCode+" in GetIMServSettings!");
            }
            
            _logger.debug("imserv/getSettings response:\n {0}",_response);

            var newEvent:IMServEvent = new IMServEvent(IMServEvent.IMSERV_SETTINGS_GET_RESULT, imServInfo, oldEvent.context, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            dispatchEvent(newEvent);       
        }
    }
}