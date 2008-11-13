package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.events.UserEvent;
    
    import flash.events.Event;
    import flash.net.URLLoader;

    public class SetStatus extends Transaction
    {
        public function SetStatus(session:Session)
        {
            super(session);
            addEventListener(UserEvent.STATUS_MSG_UPDATING, doSetStatus, false, 0, true);
        }
        
        public function run(user:User):void {
            //TODO: Params checking before dispatching event
            dispatchEvent(new UserEvent(UserEvent.STATUS_MSG_UPDATING, user, true, true));
        }
        
        private function doSetStatus(evt:UserEvent):void {
            //store the event to represent the request data
            var requestId:uint = storeRequest(evt);
            var method:String = "presence/setStatus";
            var query:String = 
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&r=" + requestId +
                "&statusMsg=" + encodeURIComponent((evt.user.statusMessage != null ? evt.user.statusMessage : ""));
            _logger.debug("SetStatus: " + (_session.apiBaseURL + method + query));
            sendRequest(_session.apiBaseURL + method + query);
        }
        
        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            var loader:URLLoader = evt.target as URLLoader;
                        
            var statusCode:uint = _response.statusCode;
            var requestId:uint = _response.requestId;
            //get the old event so we can create the new event
            var oldEvent:UserEvent = getRequest(requestId) as UserEvent;
            _logger.debug("presence/setStatus response:\n {0}",_response);
            if(statusCode == 200) {
                // NOTE: if a state change was also fired preceding this request, the "oldEvent.user" might contain
                // state state. 
                var user:User = oldEvent.user;
                
                // Dispatch a status update result
                //_logger.debug("Dispatching STATUS_MSG_UPDATE_RESULT based on SetStatus server response: {0}", user);
                var newStatusMsgEvent:UserEvent = new UserEvent(UserEvent.STATUS_MSG_UPDATE_RESULT, user, true, true);
                dispatchEvent(newStatusMsgEvent);
                
                // TODO: Dispatch 'myInfo' after setStatus still required? 
                // Now it looks like the host *does* send out "myInfo" events whenever we change status.
                // In the past were not guaranteed that a "myInfo" even would be fired, so we fired an extra one
                /*
                _logger.debug("Dispatching MY_INFO_UPDATED based on SetStatus server response: {0}", user);
                var newMyInfoEvent:UserEvent = new UserEvent(UserEvent.MY_INFO_UPDATED, user, true, true);
                dispatchEvent(newMyInfoEvent);
                */
            }                 
        }
        
    }
}