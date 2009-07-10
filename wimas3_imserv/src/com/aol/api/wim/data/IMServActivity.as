package com.aol.api.wim.data
{
    public class IMServActivity
    {
        /**
         * Instance of <code>IMServActivityType</code> 
         */        
        public var action:String;
        
        /**
         * UTC Timestamp of when activity occurred 
         */        
        public var timestamp:Date;
        
        /**
         * Optional member name, to provide context for the action 
         */        
        public var member1:String;
        
        /**
         * Optional 2nd member name, to provide context for the action 
         */        
        public var member2:String;
        
        /**
         * Constructor. See individual properties 
         * @param aAction
         * @param aTimestamp
         * @param aMember1
         * @param aMember2
         * 
         */        
        public function IMServActivity(aAction:String, aTimestamp:Date, aMember1:String=null, aMember2:String=null):void
        {
            action = aAction;
            timestamp = aTimestamp;
            member1 = aMember1;
            member2 = aMember2;
        }
    }
}