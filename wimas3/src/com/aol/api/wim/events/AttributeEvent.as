package com.aol.api.wim.events
{
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.data.User;
    
    import flash.events.Event;

    public class AttributeEvent extends Event
    {
        // Capturable
        /**
         * Used before executing a setBuddyAttribute request 
         */        
        public static const BUDDY_ATTRIBUTE_SETTING:String      =   "buddyAttributeSetting";
        
        /**
         * Used before executing a getBuddyAttribute request 
         */        
        public static const BUDDY_ATTRIBUTE_GETTING:String      =   "buddyAttributeGetting";
        
        // Resulting
        /**
         * Fired after a buddy attribute is set 
         */        
        public static const BUDDY_ATTRIBUTE_SET_RESULT:String   =   "buddyAttributeSetResult";
        
        /**
         * Fired after we get a successful response to getBuddyAttribute 
         */        
        public static const BUDDY_ATTRIBUTE_GET_RESULT:String   =   "buddyAttributeGetResult";
        
        // Properties
        
        /**
         * This represents the attributes being set/retrieved.
         * 
         * This contains the possible fields:
         * <ul>
         *  <li> friendly </li>
         *  <li> smsNumber </li>
         *  <li> workNumber </li>
         *  <li> otherNumber </li>
         * </ul> 
         */        
        public var attributes:Object;
        
        /**
         * The user related to this attributed event 
         */        
        public var user:User;
        
        /**
         * resultData represents the statusCode and statusText information generated as a result of a get/set attribute call 
         */        
        public var resultData:ResultData;
        
        public function AttributeEvent(type:String, user:User, attributes:Object, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            this.user = user;
            this.attributes = attributes;
            super(type, bubbles, cancelable);
        }
        
    }
}