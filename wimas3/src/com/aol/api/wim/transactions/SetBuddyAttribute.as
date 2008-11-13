package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.events.AttributeEvent;
    
    import flash.events.Event;

    public class SetBuddyAttribute extends Transaction
    {
        public function SetBuddyAttribute(session:Session)
        {
            super(session);
            addEventListener(AttributeEvent.BUDDY_ATTRIBUTE_SETTING, doSetAttribute, false, 0, true);
        }
        
        public function run(buddy:String, attributes:Object):void
        {
            var user:User = new User();
            user.aimId = buddy;
            dispatchEvent(new AttributeEvent(AttributeEvent.BUDDY_ATTRIBUTE_SETTING, user, attributes, true, true));
        }
        
        public function doSetAttribute(evt:AttributeEvent):void
        {
            var method:String = "buddylist/setBuddyAttribute";
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var query:String =
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId +
                "&buddy=" + encodeURIComponent(evt.user.aimId) +
                buildAttributes(evt.attributes);
                trace("calling with query: " + query);
            sendRequest(_session.apiBaseURL + method + query);
        }

        protected function buildAttributes(o:Object):String
        {
            var ret:String = "";
            var value:String = null;
            for (var key:String in o)
            {
                value = o[key] ? encodeURIComponent(o[key]) : "";
                ret += "&" + key + '=' + value;
            }
            return ret;
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
                        
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:AttributeEvent = getRequest(requestId) as AttributeEvent;
            
            _logger.debug("buddyList/setBuddyAttribute response:\n {0}",_response);

            var newEvent:AttributeEvent = new AttributeEvent(AttributeEvent.BUDDY_ATTRIBUTE_SET_RESULT, oldEvent.user, oldEvent.attributes, true, true);
            newEvent.resultData = new ResultData(statusCode, statusText);
            dispatchEvent(newEvent);
            
            if(statusCode == 200) {
                
            }            
        }
    }
}