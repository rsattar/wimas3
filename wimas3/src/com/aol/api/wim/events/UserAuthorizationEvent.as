package com.aol.api.wim.events
{
    import flash.events.Event;

    /**
     * This event fires as a result of the <pre>requestAuthorization</pre> call.
     * 
     */

    public class UserAuthorizationEvent extends Event
    {
        public static const USER_AUTHORIZATION_REQUEST_RESULT:String = "userAuthorizationRequestResult";
        
        public function UserAuthorizationEvent (type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}