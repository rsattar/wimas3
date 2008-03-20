package com.aol.api.wim.events
{
    import flash.events.Event;

    /**
     * This event is fired to notify an ICQ user they have been added to someone
     * else's contact list.
     * 
     */
    public class AddedToBuddyListEvent extends Event
    {
        public static const ADDED_TO_LIST:String = "addedToList";
        
        public var aimId:String;
        public var message:String;
        public var authorizationRequested:Boolean;
        public function AddedToBuddyListEvent(type:String, aimId:String, message:String, authRequested:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.aimId = aimId;
            this.message = message;
            this.authorizationRequested = authRequested;
        }
        
    }
}