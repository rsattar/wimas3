package com.aol.api.wim.events
{
    public class IMServActionEvent extends TransactionEvent
    {
        // Capturable
        
        /**
         * Used before executing a imserv/getMy request 
         */
        public static const IMSERV_JOINING:String      =   "imServJoining";
        
        /**
         * Used before executing a imserv/getRecentActivity request 
         */
        public static const IMSERV_REJECTING:String      =   "imServRejecting";
        
        /**
         * Used before executing a imserv/fetchRecentIMs request 
         */
        public static const IMSERV_MEMBERS_REMOVING:String      =   "imServMembersRemoving";
        
        /**
         * Used before executing a imserv/getMembers request 
         */
        public static const IMSERV_MEMBERS_INVITING:String      =   "imServMembersInviting";
        
        // Resulting
        
        public static const IMSERV_JOIN_RESULT:String      =   "imServJoinResult";
        
        public static const IMSERV_REJECT_RESULT:String      =   "imServRejectResult";
        
        public static const IMSERV_MEMBERS_REMOVE_RESULT:String      =   "imServMembersRemoveResult";
        
        public static const IMSERV_MEMBERS_INVITE_RESULT:String      =   "imServMembersInviteResult";
        
        // Event properties (Query)
        public var imServId:String;
        
        /**
         * Optional array of related member ids, for methods like RemoveIMServMembers
         */        
        public var relatedMemberIds:Array;
        
        /**
         * This is used to store some options for the action request. Notably, the 'ownershipTransfer' being 0 or 1
         */        
        public var options:Object;
        
        // Event properties (results)
        public var results:Array;
        
        // Constructor
        public function IMServActionEvent(type:String, aIMServId:String, aRelatedMemberIds:Array=null, optionalContext:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, optionalContext, bubbles, cancelable);
            imServId = aIMServId;
            relatedMemberIds = aRelatedMemberIds ? aRelatedMemberIds : [];
        }
        
        // Convenience functions
        
        public function get relatedMemberId():String
        {
            if(relatedMemberIds && relatedMemberIds.length == 1)
            {
                return relatedMemberIds[0];
            }
            return null;
        }
        
        public function set relatedMemberId(value:String):void
        {
            // If we have some existing ID's, blow them away, we are replacing with one
            if(relatedMemberIds && relatedMemberIds.length > 0)
            {
                relatedMemberIds = relatedMemberIds.splice(0, relatedMemberIds.length);
            }
            else if(!relatedMemberIds)
            {
                relatedMemberIds = [];
            }
            relatedMemberIds[0] = value;
        }
        
    }
}