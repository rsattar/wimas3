package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.ReportSPIMEvent;
    
    import flash.events.Event;

    public class ReportSPIM extends Transaction
    {
        public function ReportSPIM(session:Session)
        {
            super(session);
        }
        
        public function run(aimId:String, type:String="spim", event:String="user", comment:String=null):void
        {
            var evt:ReportSPIMEvent = new ReportSPIMEvent(ReportSPIMEvent.REPORT_SPIM_RESULT, true, false);
            evt.aimId = aimId;
            evt.spimType = type;
            evt.spimEvent = event;
            var requestId:Number = storeRequest(evt);
            var method:String = "im/reportSPIM";
            var query:String =
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId + 
                "&t=" + encodeURIComponent(aimId) +
                "&spimType=" + type + 
                "&spimEvent=" + event;
            if (comment) 
            {
                query += "&comment="+encodeURIComponent(comment);
            }
        
            sendRequest(_session.apiBaseURL + method + query);
        }
        
        override protected function requestComplete(evt:Event):void
        {
            super.requestComplete(evt);
            var eventToFire:ReportSPIMEvent = getRequest(_response.requestId) as ReportSPIMEvent;
            eventToFire.statusCode = _response.statusCode;
            dispatchEvent(eventToFire);
        }
    }
}