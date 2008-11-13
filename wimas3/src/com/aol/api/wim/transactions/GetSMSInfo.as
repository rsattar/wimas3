package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.events.SMSInfoEvent;
    
    import flash.events.Event;

    /**
     * ICQ Only. Given a phone number, this will return an
     * <code>SMSInfo</code> object. This provides information about the
     * carrier of that sms number, as well as balance information related
     * to sending to that phone number. 
     * @author Rizwan
     * 
     */
    public class GetSMSInfo extends Transaction
    {
        public function GetSMSInfo(session:Session)
        {
            super(session);
            addEventListener(SMSInfoEvent.SMSINFO_GETTING, doGetSMSInfo, false, 0, true);
        }
        
        public function run(phoneNumber:String):void {
            //TODO: normalize name in some way?
            dispatchEvent(new SMSInfoEvent(SMSInfoEvent.SMSINFO_GETTING, phoneNumber, true, true));
        }
        
        protected function doGetSMSInfo(evt:SMSInfoEvent):void
        {
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            evt.requestId = requestId;
            var method:String = "aim/getSMSInfo";
            var query:String = 
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId +
                "&k=" + _session.devId +
                "&phone=" + encodeURIComponent(evt.phoneNumber);
            _logger.debug("GetSMSInfo Query: " + _session.apiBaseURL + method + query);
            
            var destUrl:String = _session.apiBaseURL + method + query;
            
            sendRequest(_session.apiBaseURL + method + query);
        }
        
        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            
            _logger.debug("aim/getSMSInfo response:\n {0}",_response);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:SMSInfoEvent = getRequest(requestId) as SMSInfoEvent;
            
            var newEvent:SMSInfoEvent = new SMSInfoEvent(SMSInfoEvent.SMSINFO_GET_RESULT, oldEvent.phoneNumber, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            if(_response.statusDetailCode)
            {
                newEvent.resultData.statusDetailCode = Number(_response.statusDetailCode);
            }
            newEvent.requestId = requestId;
            if(statusCode == 200) {
                newEvent.smsInfo = _session.parser.parseSMSInfo(_response.data.smsInfo);
            }     

            dispatchEvent(newEvent);    
        }
    }
}