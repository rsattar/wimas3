package com.aol.api.wim.transactions
{
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.PreferenceEvent;
    
    import flash.events.Event;

    public class GetPreference extends Transaction
    {
        public function GetPreference(session:Session)
        {
            super(session);
        }
        
        public function run(preferences:Array):void
        {
            var method:String = "preference/get";
            var query:String = 
                "?f=amf3" +
                "&aimsid=" + _session.aimsid;
            if(preferences)
            {
                for(var i:int=0; i<preferences.length; i++)
                {
                    query += "&" + preferences[i] + "=1";
                }
            }
            _logger.debug("getPreferenceQuery: " + _session.apiBaseURL + method + query);
            sendRequest(_session.apiBaseURL + method + query);            
        }

        override protected function requestComplete(evt:Event):void {
            super.requestComplete(evt);
            var statusCode:uint = _response.statusCode;
            if(statusCode == 200) {
                var newEvent:PreferenceEvent = new PreferenceEvent(PreferenceEvent.PREFERENCES_RECEIVED, true, true);
                newEvent.preferences = _response.data;
                dispatchEvent(newEvent);
            }                 
        }        
    }
}