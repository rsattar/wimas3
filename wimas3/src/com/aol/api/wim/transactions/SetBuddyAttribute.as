package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    
    import flash.events.Event;

    public class SetBuddyAttribute extends Transaction
    {
        public function SetBuddyAttribute(session:Session)
        {
            super(session);
        }
        
        public function run(buddy:String, attributes:Object):void
        {
            var method:String = "buddylist/setBuddyAttribute";
            var query:String =
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                "&buddy=" + buddy +
                buildAttributes(attributes);
            sendRequest(_session.apiBaseURL + method + query);
        }

        protected function buildAttributes(o:Object):String
        {
            var ret:String = "";
            for (var key:String in o)
            {
                ret += "&" + key + '=' + escape(o[key]) + ',';
            }
            return (ret.replace(/,$/, ""));
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            var statusCode:uint = _response.statusCode;
            //get the old event so we can create the new event
            if(statusCode == 200) {

            }            
        }
    }
}