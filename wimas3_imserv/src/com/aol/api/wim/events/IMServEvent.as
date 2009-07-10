package com.aol.api.wim.events
{
    import com.aol.api.wim.data.IMServInfo;
    import com.aol.api.wim.data.IMServUserSettings;

    public class IMServEvent extends TransactionEvent
    {
        // Capturable
        /**
         * Used before executing a imserv/create request 
         */        
        public static const IMSERV_CREATING:String      =   "imServCreating";
        
        /**
         * Used before executing a imserv/delete request 
         */        
        public static const IMSERV_DELETING:String      =   "imServDeleting";
        
        /**
         * Used before executing a imserv/getSettings request 
         */        
        public static const IMSERV_SETTINGS_GETTING:String      =   "imServSettingsGetting";
        
        /**
         * Used before executing a imserv/getSettings request 
         */        
        public static const IMSERV_SETTINGS_UPDATING:String      =   "imServSettingsUpdating";
        
        /**
         * Used before executing a imserv/getUserSettings request 
         */        
        public static const IMSERV_USER_SETTINGS_GETTING:String      =   "imServUserSettingsGetting";
        
        /**
         * Used before executing a imserv/setUserSettings request 
         */        
        public static const IMSERV_USER_SETTINGS_UPDATING:String      =   "imServUserSettingsUpdating";
        
        // Resulting
        
        public static const IMSERV_CREATE_RESULT:String      =   "imServCreateResult";
        
        public static const IMSERV_DELETE_RESULT:String      =   "imServDeleteResult";
        
        public static const IMSERV_SETTINGS_GET_RESULT:String      =   "imServSettingsGetResult";
        
        public static const IMSERV_SETTINGS_UPDATE_RESULT:String      =   "imServSettingsUpdateResult";
        
        public static const IMSERV_USER_SETTINGS_GET_RESULT:String      =   "imServUserSettingsGetResult";
        
        public static const IMSERV_USER_SETTINGS_UPDATE_RESULT:String      =   "imServUserSettingsUpdateResult";
        
        public var imServ:IMServInfo;
        
        /**
         * Optional. Used by GetIMServUserSettings/SetIMServUserSettings. 
         */        
        public var userSettings:IMServUserSettings;
        
        public function IMServEvent(type:String, imServInfo:IMServInfo=null, optionalContext:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, optionalContext, bubbles, cancelable);
            imServ = imServInfo;
            if(!imServ) imServ = new IMServInfo();
        }
        
    }
}