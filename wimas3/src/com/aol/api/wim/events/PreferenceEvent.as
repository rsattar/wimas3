package com.aol.api.wim.events
{
    import flash.events.Event;

    /**
     * This event fires when preferences are received as the result of a <pre>GetPreference</pre> call.
     *  
     * @param type
     * @param bubbles
     * @param cancelable
     * 
     */

    public class PreferenceEvent extends Event
    {
        public static const PREFERENCES_RECEIVED:String = "preferencesReceived";
        
        /**
         * The preferences that were received. This may not be all the user's preferences if the call
         * to GetPreference specified a list of preferences to retreive. 
         */
        public var preferences:Object;
        
        public function PreferenceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}