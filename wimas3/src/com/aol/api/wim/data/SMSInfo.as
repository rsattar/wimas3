package com.aol.api.wim.data
{
    /**
     * ICQ Only. Represents an ICQ user's SMS Balance and other information, usually in context with a
     * particular mobile number. That phone number's carrier information, user's balance with that carrier, text message size
     * is represented in this data structure.
     * 
     * This object is generally created as a result of <code>getSmsInfo</code> or sending an SMS message from SendIM.
     *  
     * @author Rizwan
     * 
     */    
    public class SMSInfo
    {
        /**
         * Represents an error code. 
         */        
        public var errorCode:int  =   0;
        
        /**
         * Text of error reason 
         */        
        public var reasonText:String;
        
        /**
         * Numeric identifier for SMS Carrier 
         */        
        public var carrierId:int    =   -1;
        
        /**
         * Number of SMS messages user is allowed to send for this balance group (should be a uint, but apparently you can receive negative values)
         */        
        public var remainingCount:int   =   0;
        
        /**
         * Max size of an SMS message containing only ASCII characters 
         */        
        public var maxAsciiLength:int  =   0;
        
        /**
         * Max size of an SMS message containing any non-ASCII characters 
         */        
        public var maxUnicodeLength:int    =   0;
        
        /**
         * Name of the carrier for the destination number 
         */        
        public var carrierName:String;
        
        /**
         * URL for the carrier's website 
         */        
        public var carrierUrl:String;
        
        /**
         * Name identifying a group. SMS Destinations with the same balance group share the remaining count. 
         */        
        public var balanceGroup:String;

    }
}