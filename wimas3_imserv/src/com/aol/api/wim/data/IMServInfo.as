package com.aol.api.wim.data
{
    public class IMServInfo
    {
        public var id:String;
        public var domainName:String;
        public var description:String;
        public var friendlyName:String;
        public var senderTypesAllowed:Array = [];
        public var membershipPolicy:String;
        public var imReplyType:String;
        public var blDisplayType:String;
        public var enabled:Boolean  =   true;
        public var buddyIconId:String;
        public var miniIconId:String;
        public var smallBuddyIconId:String;
        public var imSoundId:String;
        public var creationDate:Date;
        
        public var groupName:String // Set by the create result, what is it?
        
        public function clone():IMServInfo
        {
            var info:IMServInfo = new IMServInfo();
            info.id = id;
            info.domainName = domainName;
            info.description = description;
            info.friendlyName = friendlyName;
            info.senderTypesAllowed = senderTypesAllowed;
            info.membershipPolicy = membershipPolicy;
            info.imReplyType = imReplyType;
            info.blDisplayType = blDisplayType;
            info.enabled = enabled;
            info.buddyIconId = buddyIconId;
            info.miniIconId = miniIconId;
            info.smallBuddyIconId = smallBuddyIconId;
            info.imSoundId = imSoundId;
            info.creationDate = creationDate;
            return info;
        }
    }
}