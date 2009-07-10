package com.aol.api.wim.transactions.imserv
{
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.IMServInfo;
    import com.aol.api.wim.data.IMServUserSettings;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.events.IMServEvent;
    import com.aol.api.wim.transactions.Transaction;
    
    import flash.events.Event;

    public class GetIMServUserSettings extends Transaction
    {
        public function GetIMServUserSettings(session:Session)
        {
            super(session);
            addEventListener(IMServEvent.IMSERV_USER_SETTINGS_GETTING, doGetIMServUserSettings, false, 0, true);
        }
        
        public function run(imServId:String, optionalContext:Object=null):void
        {
            var imServ:IMServInfo = new IMServInfo();
            imServ.id = imServId;
            dispatchEvent(new IMServEvent(IMServEvent.IMSERV_USER_SETTINGS_GETTING, imServ, optionalContext, true, true));
        }
        
        public function doGetIMServUserSettings(evt:IMServEvent):void
        {
            var method:String = "imserv/getUserSettings";
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
            
            _logger.debug("GetIMServUserSettings: "+queryString);
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

            var newEvent:IMServEvent = new IMServEvent(IMServEvent.IMSERV_USER_SETTINGS_GET_RESULT, imServInfo, oldEvent.context, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            if(statusCode == 200) {
                var rawData:Object = _response.data;
                /* 
                rawData Object (@13ad6dd1)  
                    displayType "withMembers"   
                    friendly    "newserv"   
                    imfEnabled  "false" 
                    memberType  "owner" 
                    pendingOwner    "false" 
                    receivedMessage "true"  

                 */
                var settings:IMServUserSettings = new IMServUserSettings();
                settings.blDisplayType = rawData.displayType;
                settings.imServFriendlyName = rawData.friendly;
                settings.imfEnabled = rawData.imfEnabled == "true";
                settings.memberType = rawData.memberType;
                settings.pendingOwner = rawData.pendingOwner == "true";
                settings.receivedMessage = rawData.receivedMessage == "true";
                
                // Add some of our own convenience data
                settings.relatedAimId = _session.myInfo.aimId; // GetIMServUserSettings seems to be only valid for our own session
                settings.relatedIMServId = imServInfo.id;
                
                newEvent.userSettings = settings;
            }
            else
            {
                trace("Error "+statusCode+" in GetIMServUserSettings!");
            }
            
            _logger.debug("imserv/getUserSettings response:\n {0}",_response);
            
            dispatchEvent(newEvent);       
        }
    }
}