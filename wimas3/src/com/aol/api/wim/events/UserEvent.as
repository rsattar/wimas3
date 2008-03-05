package com.aol.api.wim.events {
    
    import com.aol.api.wim.data.User;
    
    import flash.events.Event;

    public class UserEvent extends Event {
        
        /**
         * This event fires when our identity's information is about to be updated. 
         */
        public static const MY_INFO_UPDATING:String          = "myInfoUpdating";
 
         /**
         * This event fires when our identity's information is updated. 
         */
        public static const MY_INFO_UPDATE_RESULT:String          = "myInfoUpdateResult";
               
        /**
         * This event fires when a buddy's information is updated. 
         */
        public static const BUDDY_PRESENCE_UPDATED:String   = "buddyPresenceUpdated";
                
        /**
         * Represents the new <code>User</code> information.
         */        
        public var user:User;
        
        public function UserEvent(type:String, user:User, bubbles:Boolean=false, cancelable:Boolean=false) {
            
            //TODO: implement function
            super(type, bubbles, cancelable);
            this.user = user;
        }
        
    }
}