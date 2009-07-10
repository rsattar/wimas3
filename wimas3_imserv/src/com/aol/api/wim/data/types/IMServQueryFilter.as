package com.aol.api.wim.data.types
{
    public class IMServQueryFilter
    {
        /**
         * Member names or IMServ ids
         */        
        public var names:Array;
        
        /**
         * Search pattern 
         */        
        public var regex:String;
        
        /**
         * Filter start time in Unix epoch time 
         */        
        public var startTime:Number;
        
        /**
         * Filter end time in Unix epoch time 
         */        
        public var endTime:Number;
        
        /**
         * Determine who can send IMs 
         */        
        public var memberTypes:Array;
        
        /**
         * Sort order for the query. Type is <code>IMServQuerySortOrder</code>.
         * Default is <code>IMServQuerySortOrder.NONE</code> 
         */        
        public var sortOrder:String = IMServQuerySortOrder.NONE;
    }
}