package com.aol.api.wim.events
{
    import flash.events.Event;

    /**
     * This fires as the result of a setPermitDentyRequest.
     *  
     * @author OsmanUllah1
     * 
     */
    public class PermitDenyEvent extends Event
    {
        public static const SET_PD_RESULT:String = "setPermitDenyResult";
        /**
         * The result of the request.  For now, see the WIM documentation 
         * for the format of the results. Only valid when the statusCode is 200.
         */
        public var results:Object;
        
        /**
         * The status code of the setPermitDeny request.
         */
        public var statusCode:String;
        
        public function PermitDenyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}