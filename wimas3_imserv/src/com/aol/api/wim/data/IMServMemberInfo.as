package com.aol.api.wim.data
{
    public class IMServMemberInfo
    {
        public var member:String; // should this be 'id'
        
        /**
         * Type of <code>ChatMemberType</code>
         */
        public var memberType:String;
        public var inviter:String;
        public var ownerTransferInvited:Boolean;
        
        public function IMServMemberInfo(aMember:String, aMemberType:String, aInviter:String=null, aOwnerTransferInvited:Boolean=false):void
        {
            member = aMember;
            memberType = aMemberType;
            inviter = aInviter;
            ownerTransferInvited = aOwnerTransferInvited;
        }
    }
}