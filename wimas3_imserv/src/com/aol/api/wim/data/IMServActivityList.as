package com.aol.api.wim.data
{
    public class IMServActivityList
    {
        
        /**
         * The imServ id whose activities are listed here 
         */        
        public var imServId:String;
        
        /**
         * The activities for this imServ 
         */        
        public var activities:Array;
        
        // The following 3 properties seem to be undocumented
        /**
         * The number of results that matched the query 
         */        
        public var numResultsMatched:Number;
        
        /**
         * The number of entries remaining 
         */        
        public var numResultsRemaining:Number;
        
        /**
         * The code for this activity list lookup
         */        
        public var code:Number;
        
        public function IMServActivityList(imServ:String, imServActivities:Array)
        {
            imServId = imServ;
            activities = imServActivities ? imServActivities : [];
        }

    }
}