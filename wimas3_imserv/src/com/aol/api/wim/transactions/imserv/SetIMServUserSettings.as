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

    public class SetIMServUserSettings extends Transaction
    {
        public function SetIMServUserSettings(session:Session)
        {
            super(session);
            addEventListener(IMServEvent.IMSERV_USER_SETTINGS_UPDATING, doSetIMServUserSettings, false, 0, true);
        }
        
        public function run(imServId:String, aimId:String, userSettings:IMServUserSettings, optionalContext:Object = null):void
        {
            var imServ:IMServInfo = new IMServInfo();
            imServ.id = imServId;
            var event:IMServEvent = new IMServEvent(IMServEvent.IMSERV_USER_SETTINGS_UPDATING, imServ, optionalContext, true, true);
            // override whatever was in the relatedAimId
            userSettings.relatedAimId = aimId;
            event.userSettings = userSettings;
            dispatchEvent(event);
        }
        
        public function doSetIMServUserSettings(evt:IMServEvent):void
        {
            var method:String = "imserv/setUserSettings";
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var settings:IMServUserSettings = evt.userSettings;
            var queryString:String = "";

            var authToken:AuthToken = _session.authToken;
            // Set up params in alphabetical order
            queryString += "a="+authToken.a;
            queryString += "&aimsid="+_session.aimsid;
            if(settings.blDisplayType != null)
            {
                queryString += "&displayType="+encodeURIComponent(settings.blDisplayType);
            }
            queryString += "&f=amf3";
            if(settings.imServFriendlyName != null)
            {
                queryString += "&friendly="+encodeURIComponent(settings.imServFriendlyName);
            }
            queryString += "&imfEnabled="+(settings.imfEnabled ? "1" : "0");
            queryString += "&imserv="+encodeURIComponent(evt.imServ.id);
            queryString += "&k="+_session.devId;
            if(settings.memberType != null)
            {
                queryString += "&memberType="+encodeURIComponent(settings.memberType);
            }
            queryString += "&r="+requestId;
            queryString += "&receivedMessage="+(settings.receivedMessage ? "1" : "0");
            queryString += "&t="+encodeURIComponent(settings.relatedAimId);
            queryString += "&ts=" + getSigningTimestampValue(authToken);
            if(settings.userFriendlyName != null)
            {
                queryString += "&userFriendly="+encodeURIComponent(settings.userFriendlyName);
            }
            // Append the sig_sha256 data
            queryString += "&sig_sha256="+createSignatureFromQueryString(method, queryString);
            
            _logger.debug("SetIMServUserSettings: "+queryString);
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

            var newEvent:IMServEvent = new IMServEvent(IMServEvent.IMSERV_USER_SETTINGS_UPDATE_RESULT, imServInfo, oldEvent.context, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            
            newEvent.userSettings = oldEvent.userSettings;
            
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
            }
            else
            {
                trace("Error "+statusCode+" in SetIMServUserSettings!");
            }
            
            _logger.debug("imserv/setUserSettings response:\n {0}",_response);
            
            dispatchEvent(newEvent);       
        }
    }
}