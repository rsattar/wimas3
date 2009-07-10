package com.aol.api.wim.events
{
    import com.aol.api.wim.data.ResultData;
    
    import flash.events.Event;

    /**
     * Simply extends the Event to add an optionally settable 'resultData' object.
     * This should be used as the base for all of our transaction events.
     *  
     * @author Rizwan
     * 
     */
    public class TransactionEvent extends Event
    {
        
        /**
         * resultData represents the statusCode and statusText information generated as a result of a get/set attribute call 
         */        
        public var resultData:ResultData;
        
        /**
         * Optional context object that can be set by some transactions for better tracking at the client-level 
         */        
        public var context:Object;
        
        public function TransactionEvent(type:String, optionalContext:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            context = optionalContext;
        }
        
        // Convenience getters
        public function get statusCode():Number
        {
            if(resultData)
            {
                return resultData.statusCode;
            }
            return NaN;
        }
        
    }
}