package com.aol.api.wim.events
{
    import flash.events.Event;

    /**
     * This event is fired for actions related to adding temp buddies. Temp buddies
     * allow presence updates for users not on the buddy list. They do not show up 
     * in the buddy list at all. 
     * 
     */
    public class TempBuddyEvent extends Event
    {
        public static var TEMP_ADD_RESULT:String = "tempBuddyAdded";
        
        /**
         * An array of aimid's for buddies who were added. 
         */
        public var buddyNames:Array;
        
        public var statusCode:String;
        
        public var statusText:String;
        
        public function TempBuddyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
        
        override public function clone():Event
        {
            var e:TempBuddyEvent = new TempBuddyEvent(type, bubbles, cancelable);
            e.buddyNames = buddyNames;
            e.statusCode = statusCode;
            e.statusText = statusText;
            return e;
        }
    }
}