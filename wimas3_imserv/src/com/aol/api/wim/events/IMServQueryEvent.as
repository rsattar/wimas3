package com.aol.api.wim.events
{
    import com.aol.api.wim.data.types.IMServQuerySortOrder;
    
    public class IMServQueryEvent extends TransactionEvent
    {
        // Capturable
        
        /**
         * Used before executing a imserv/getMy request 
         */
        public static const IMSERV_LIST_GETTING:String      =   "imServListGetting";
        
        /**
         * Used before executing a imserv/getRecentActivity request 
         */
        public static const IMSERV_RECENT_ACTIVITY_GETTING:String      =   "imServRecentActivityGetting";
        
        /**
         * Used before executing a imserv/fetchRecentIMs request 
         */
        public static const IMSERV_RECENT_IMS_GETTING:String      =   "imServRecentIMsGetting";
        
        /**
         * Used before executing a imserv/getMembers request 
         */
        public static const IMSERV_MEMBERS_GETTING:String      =   "imServMembersGetting";
        
        // Resulting
        
        public static const IMSERV_LIST_GET_RESULT:String      =   "imServListGetResult";
        
        public static const IMSERV_RECENT_ACTIVITY_GET_RESULT:String      =   "imServRecentActivityGetResult";
        
        public static const IMSERV_RECENT_IMS_GET_RESULT:String      =   "imServRecentIMsGetResult";
        
        public static const IMSERV_MEMBERS_GET_RESULT:String      =   "imServMembersGetResult";
        
        // Event properties (Query)
        
        /**
         * Array of <code>IMServQueryFilter</code> objects. Usually one or none. 
         */        
        public var queryFilters:Array;
        
        /**
         * The number of results requested 
         */        
        public var numberResultsToGet:Number;
        
        /**
         * The number of results to skip, if doing a paginated query, for example 
         */        
        public var numberResultsToSkip:Number = 0;
        
        /**
         * For some queries, an optional "imserv" id (or multiple) can be included
         */        
        public var relatedIMServIds:Array;
        
        
        /**
         * For some queries, a global sort order is needed. 
         * Type is <code>IMServQuerySortOrder</code>.
         * Default is <code>IMServQuerySortOrder.NONE</code> 
         */
        public var sortOrder:String = IMServQuerySortOrder.NONE;
        
        // Event properties (results)
        
        /**
         * Results of the query. The data type is homogenous, but will depend on the type of query that was done. Some examples are
         * <code>IMServInfo</code> objects and <code>IMServMemberInfo</code> objects.
         * 
         * This value is only set on a resulting, bubbling event; capturable events typically will not have results yet.
         */        
        public var results:Array;
        
        /**
         * The number of results that matched the query 
         */        
        public var numResultsMatched:Number;
        
        /**
         * The number of entries remaining 
         */        
        public var numResultsRemaining:Number;
        
        
        // The following two properties should probably be included in a IMServMemberQueryEvent, or something
        
        /**
         * The number of total results, ignoring Filter. Otherwise it is <code>NaN</code>
         * 
         * This seems to be only set by "imserv/getMembers". 
         */        
        public var numTotalResults:Number;
        
        /**
         * The creation time of the relatedIMServId.
         * 
         * This is sort of a strange place for it, as it is only set as a result of "imserv/getMembers". Perhaps this should be part of a child class which inherits IMServQueryEvent (riz) 
         */        
        public var imServCreateTime:Date;
        
        // Constructor
        
        /**
         *  
         * @param type The type of event
         * @param filters Array of <code>IMServQueryFilter</code> objects
         * @param numberToGet Number of results to get
         * @param numberToSkip Number of results to skip (default is 0)
         * @param bubbles
         * @param cancelable
         * 
         */        
        public function IMServQueryEvent(type:String, filters:Array, numberToGet:Number, numberToSkip:Number=0, optionalContext:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, optionalContext, bubbles, cancelable);
            queryFilters = filters ? filters : []; // create an empty array if filters is null
            numberResultsToGet = numberToGet;
            numberResultsToSkip = numberToSkip;
        }
        
        // Convenience functions
        
        public function get relatedIMServId():String
        {
            if(relatedIMServIds && relatedIMServIds.length == 1)
            {
                return relatedIMServIds[0];
            }
            return null;
        }
        
        public function set relatedIMServId(value:String):void
        {
            // If we have some existing ID's, blow them away, we are replacing with one
            if(relatedIMServIds && relatedIMServIds.length > 0)
            {
                relatedIMServIds = relatedIMServIds.splice(0, relatedIMServIds.length);
            }
            else if(!relatedIMServIds)
            {
                relatedIMServIds = [];
            }
            relatedIMServIds[0] = value;
        }
    }
}