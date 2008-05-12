package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.DataIM;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.events.DataIMEvent;
    
    import flash.events.Event;

	public class SendDataIM extends Transaction
	{
		public function SendDataIM(session:Session)
		{
			super(session);
			addEventListener(DataIMEvent.DATA_IM_SENDING, doDataIMSend, false, 0, true);
		}
		
        public function run(buddyName:String, dataMsg:String, dataType:String, capability:String, inviteMessage:String, autoResponse:Boolean=false, base64Encoded:Boolean=false):void 
        {
            //TODO: normalize name in some way?
            var buddy:User = new User();
            buddy.aimId = buddyName;
            var dataIM:DataIM = new DataIM(dataMsg, dataType, new Date(), _session.myInfo, buddy, capability, inviteMessage, base64Encoded);
            dispatchEvent(new DataIMEvent(DataIMEvent.DATA_IM_SENDING, dataIM, true, true));
        }
        
        protected function doDataIMSend(evt:DataIMEvent):void {
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            evt.requestId = requestId;
            var method:String = "im/sendDataIM";
            var query:String = 
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId +
                "&t=" + encodeURIComponent(evt.dataIM.recipient.aimId) +
                "&cap=" + evt.dataIM.capabilityUUID +
                "&type=" + evt.dataIM.dataType +
                "&data=" + encodeURIComponent(evt.dataIM.message) +
                "&autoResponse=" + evt.dataIM.isAutoResponse;

            if (evt.dataIM.base64Encoded)
            	query += "&dataIsBase64=1";

            _logger.debug("SendDataIMQuery: " + _session.apiBaseURL + method + query);
            sendRequest(_session.apiBaseURL + method + query);            
        }
        
        override protected function requestComplete(evt:Event):void 
        {
            super.requestComplete(evt);
            
            var statusCode:String = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            
            //get the old event so we can create the new event
            var oldEvent:DataIMEvent = getRequest(requestId) as DataIMEvent;
            var newEvent:DataIMEvent = new DataIMEvent(DataIMEvent.DATA_IM_SEND_RESULT, oldEvent.dataIM, true, true);
            newEvent.requestId = requestId;
            newEvent.statusCode = statusCode;
            newEvent.statusText = statusText;
            _logger.debug("SendDataIM Response: " + statusCode + ": " + statusText);
            dispatchEvent(newEvent);
        }
		
	}
}
