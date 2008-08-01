package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.PermitDenyEvent;
    
    import flash.events.Event;

    public class GetPermitDeny extends Transaction
    {
        public function GetPermitDeny(session:Session)
        {
            super(session);
        }
        
        public function run():void
        {
            var method:String = "preference/getPermitDeny";
            var query:String =
                "?f=amf3" +
                "&aimsid=" + _session.aimsid;
            sendRequest(_session.apiBaseURL + method + query);
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            var statusCode:String = _response.statusCode;
            var e:PermitDenyEvent = new PermitDenyEvent(PermitDenyEvent.GET_PD_RESULT, true, false);
            e.statusCode = statusCode;
            if(statusCode == "200") {
                e.results = _response.data;
            }
            dispatchEvent(e);
        }
         
    }
}