package com.aol.api.wim.data
{
    public class IMServUserSettings
    {
        public var memberType:String;
        public var blDisplayType:String;
        // Documentation Says "Whether messages will be received" - so i guess you can turn receive messages off?
        public var receivedMessage:Boolean = true;
        // Documentation says "Pending transfer of imserv ownership" - so this means we are a pending owner?
        public var pendingOwner:Boolean = false;
        
        public var imServFriendlyName:String;
        public var imfEnabled:Boolean = true;
        
        public var userFriendlyName:String;
        
        /**
         * Used to associated an aimId with these settings 
         */        
        public var relatedAimId:String;
        
        /**
         * Used to associated an imServId with these settings 
         */        
        public var relatedIMServId:String;
        
        /**
         * Makes a copy of this object for editing 
         * @return 
         * 
         */        
        public function clone():IMServUserSettings
        {
            var settings:IMServUserSettings = new IMServUserSettings();
            settings.memberType = memberType;
            settings.blDisplayType = blDisplayType;
            settings.receivedMessage = receivedMessage;
            settings.pendingOwner = pendingOwner;
            settings.imServFriendlyName = imServFriendlyName;
            settings.imfEnabled = imfEnabled;
            settings.userFriendlyName = userFriendlyName;
            settings.relatedAimId = relatedAimId;
            settings.relatedIMServId = relatedIMServId;
            
            return settings;
        }
    }
}