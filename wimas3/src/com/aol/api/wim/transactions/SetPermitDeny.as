package com.aol.api.wim.transactions
{
    import com.aol.api.net.ResultLoader;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.PermitDenyEvent;
    
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
            var result:String = "";
            if(o[paramName] && (o[paramName].length > 0))
            {
                var numItems:Number = o[paramName].length;
                // o[oaramName] might be an array of id's, so go through each id to url-safe them
                // This is important for ids like phone numbers (+94945551234) and emails
                for(var i:Number = 0; i<numItems; i++)
                {
                    o[paramName][i] = ResultLoader.encodeStrPart(o[paramName][i]);
                }
                
                result = "&" + ResultLoader.encodeStrPart(paramName) + "=" + o[paramName].join(",");
            }
            return result;
        }
        
        override protected function requestComplete(event:Event):void
        {
            super.requestComplete(event);
            var statusCode:String = _response.statusCode;
            //get the old event so we can create the new event
            var e:PermitDenyEvent = new PermitDenyEvent(PermitDenyEvent.SET_PD_RESULT, true, false);
            e.statusCode = statusCode;
            if(statusCode == "200") {
                e.results = _response.data.results;
            }
            dispatchEvent(e);
        }
         
    }
}