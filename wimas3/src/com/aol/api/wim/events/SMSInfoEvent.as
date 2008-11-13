package com.aol.api.wim.events
{
    import com.aol.api.wim.data.ResultData;
    import com.aol.api.wim.data.SMSInfo;
    
    import flash.events.Event;

    public class SMSInfoEvent extends Event
    {
        
        // Capturable 
        /**
         * This event fires when we are about to request sms info
         */
        public static const SMSINFO_GETTING:String          = "smsInfoGetting";
        
        // Bubble phase
        /**
         * An event to communicate the result of trying to set typing status, whether it 
         * was successful or not. If setting the typing status was successful, the statusCode will
         * be 200.
         */
        public static const SMSINFO_GET_RESULT:String = "smsInfoGetResult";
        
        // Instance variables
        /**
         * Represents the phone number being looked up 
         */        
        public var phoneNumber:String;
        
        /**
         * The sms info for this phone number, if it was received 
         */        
        public var smsInfo:SMSInfo;
        
        /**
         * This represents the result data from trying to get sms info. Only valid
         * for the SMSINFO_GET_RESULT event.  
         */        
        public var resultData:ResultData;
        
        /**
         * Stores the request ID for the event. This allows for matching of SMSINFO_GETTING and SMSINFO_GET_RESULT events to each other. 
         */
        public var requestId:uint;
        
        public function SMSInfoEvent(type:String, phoneNumber:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.phoneNumber = phoneNumber;
        }
    }
}