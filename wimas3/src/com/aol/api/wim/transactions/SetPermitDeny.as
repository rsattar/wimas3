package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    
    import flash.events.Event;

    public class SetPermitDeny extends Transaction
    {
        public function SetPermitDeny(session:Session)
        {
            super(session);
        }
        
        /**
         * Takes in an object that represents all the parameters for the call:
         * 
         * pdAllow : Array of aimIds to allow
         * pdBlock : Array of aimIds to block
         * pdIgnore : Array of aimIds to ignore
         * pdAllowRemove : Array of aimIds to remove from the allow list
         * pdBlockRemove : Array of aimIds to remove from the block list
         * pdIgnoreRemove : Array of aimIds to remove from the ignore list
         * pdMode : { permitAll | permitSome | permitOnList | denySome | denyAll } (see <pre>PermitDenyMode</pre>)
         * 
         * @param attributes An object with one or more of the mentioned properties.
         * 
         */
        public function run(attributes:Object):void
        {
            var method:String = "preference/setPermitDeny";
            var query:String =
                "?f=amf3" +
                "&aimsid=" + _session.aimsid +
                createParamString("pdAllow", attributes) + 
                createParamString("pdBlock", attributes) + 
                createParamString("pdIgnore", attributes) + 
                createParamString("pdAllowRemove", attributes) +
                createParamString("pdBlockRemove", attributes) + 
                createParamString("pdIgnoreRemove", attributes);
            if(attributes["pdMode"])
                query += "&pdMode=" + attributes["pdMode"];
            sendRequest(_session.apiBaseURL + method + query);
        }

        protected function createParamString(paramName:String, o:Object):String
        {
            if(o[paramName] && (o[paramName].length > 0))
            {
                return encodeURI("&" + paramName + "=" + o[paramName].join(","));
            }
            else
                return "";
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            var statusCode:uint = _response.statusCode;
            //get the old event so we can create the new event
            if(statusCode == 200) {
                var results:Object = _response.data.results;
            }            
        }
         
    }
}