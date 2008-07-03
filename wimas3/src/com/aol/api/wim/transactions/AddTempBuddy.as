package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.TempBuddyEvent;
    
    import flash.events.Event;

    public class AddTempBuddy extends Transaction
    {
        public function AddTempBuddy(session:Session)
        {
            super(session);
        }
        
        public function run(buddyNames:Array):void
        {
            var names:String = "";
            for(var i:int=0; i<buddyNames.length; i++)
                names += "&t=" + encodeURIComponent(buddyNames[i]);
            if(!names) throw new Error("AddTempBuddy requires at least one screenname");
            
            //store the event to represent the request data
            var evt:TempBuddyEvent = new TempBuddyEvent(TempBuddyEvent.TEMP_ADD_RESULT, true, true);
            evt.buddyNames = buddyNames;
            
            var requestId:uint = storeRequest(evt);
            var method:String = "aim/addTempBuddy";
            var query:String = 
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId +
                names;
            _logger.debug("AddTempBuddyQuery: " + _session.apiBaseURL + method + query);
            sendRequest(_session.apiBaseURL + method + query);
        }

        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            
            var requestId:uint = _response.requestId;
            var oldEvent:TempBuddyEvent = getRequest(requestId) as TempBuddyEvent;
            oldEvent.statusCode = _response.statusCode;
            oldEvent.statusText = _response.statusText;
            dispatchEvent(oldEvent);
        }
    }
}