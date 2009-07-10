package com.aol.api.wim.data
{
    public class IMRawMessageData
    {
        /**
         * Country code of the member sending this message 
         */        
        public var memberCountryCode:String;
        
        /**
         * Client code, determined by IP Address of the sender 
         */        
        public var ipCountryCode:String;
        
        /**
         * Country code registered by the sending application 
         */        
        public var clientCountryCode:String;
        
        /**
         * Base64-encoded raw message data 
         */        
        public var base64Message:String;
        
        public function IMRawMessageData(b64Msg:String, memberCountry:String=null, clientCountry:String=null, ipCountry:String=null)
        {
            super();
            base64Message = b64Msg;
            memberCountryCode = memberCountry;
            clientCountryCode = clientCountry;
            ipCountryCode = ipCountry;
        }

    }
}