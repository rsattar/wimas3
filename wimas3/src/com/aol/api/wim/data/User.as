package com.aol.api.wim.data {
    import com.aol.api.wim.data.types.UserType;
    
    
    /**
    * Represents a user. Could either be a buddy, or the user that
    * is signed in to a session.
    */
    
    public class User {
        /**
         * This is the formatting for the friendly name when the <pre>label</pre> property is queried.
         * It's a string where <pre>{0}</pre> represents the friendly name. For example the 
         * value <pre>"\"{0}\""</pre> would cause the <pre>label</pre> property to return <pre>"Friendly Name"</pre> 
         * if a friendly name is present for that user.
         */
        public static var friendlyNameFormat:String = "{0}";
        /**
        * Normalized AIM ID. Use this to identify objects like conversations and windows.
        */
        public var aimId:String;
        /**
        * Formatted AIM ID. Use this to display the aim ID to the user.
        */
        public var displayId:String;
        /**
        * Display name, often provided by ICQ. This is different from displayId in that it can contain competely separate characters.
        */
        public var friendlyName:String;
        /**
        * User's e-mail address. Only set when doing an e-mail search.
        */
        public var emailId:String;
        /**
        * Online state of the user.
        */
        public var state:String;
        /**
        * Online time in seconds.
        */
        public var onlineTime:int;
        /**
        * Idle time in minutes.
        */
        public var idleTime:int;
        /**
        * Away time in seconds.
        */
        public var awayTime:int;
        /**
        * Time since last status message change in seconds.
        */
        public var statusTime:int;
        /**
        * Away message in XHTML.
        */
        public var awayMessage:String;
        /**
        * Profile message in XHTML.
        */
        public var profileMessage:String;
        /**
        * Status message in XHTML.
        */
        public var statusMessage:String;
        /**
        * URL to the user's buddy icon.
        */
        public var buddyIconURL:String;
        /**
        * URL to the user's presence icon.
        * An application may wish to use its own icon set for presence, in which case this URL can be ignored.
        */
        public var presenceIconURL:String;
        /**
        * When the user joined AIM.
        */
        public var memberSince:int;
        /**
        * User's capabilities in an array. This is an array of 32 character UUID strings.
        * e.g. 8eec67ce70d041009409a7c1602a5c84
        */
        public var capabilities:Array;
        /**
        * Country code from which user is logged in; only set for logged in user.
        */ 
        public var countryCode:String = null;
                
        /**
        * Returns the displayId, or aimId if displayId is undefined.
        * This is a read-only property. Set displayId or aimId instead.
        */
        public function get label():String
        {
            return friendlyName ? friendlyNameFormat.replace(/\{0\}/g, friendlyName) : (displayId ? displayId : aimId);
        }
        
        public function get bot():Boolean
        {
            return ((aimId == "aolsystemmsg") || (aimId == "aim")) //fixme: hardcode this until SAWS gives a solution
        }
        
        /**
         * @private  
         */
        public function get isFollowMe():Boolean
        {
            return (capabilities && capabilities.indexOf("8eec67ce70d041009409a7c1602a5c84") >= 0);            
        }
        
        public function get userType():String
        {
            if(aimId.search(/^[0-9]+/) == 0)
                return UserType.ICQ;
            if(aimId.search(/^\+/) == 0)
                return UserType.SMS;
            return UserType.AIM;
        }

        public function toString():String {
            return "[User:" + aimId + 
                   ", displayId=" + displayId + 
                   ", friendlyName=" + friendlyName +
                   ", state=" + state +
                   ", awayMessage=" + awayMessage +
                   ", statusMessage=" + statusMessage +
                   ", emailId=" + emailId + 
                   ", onlineTime=" + onlineTime +
                   ", idleTime=" + idleTime +
                   ", awayTime=" + awayTime +
                   ", statusTime=" + statusTime +
                   ", buddyIconURL=" + buddyIconURL +
                   ", presenceIconURL=" + presenceIconURL +
                   ", memberSince=" + memberSince +
                   ", capabilities=" + capabilities + 
                   "]";
        }
        
        public function equals(other:User):Boolean {
            return (other.aimId == aimId);
        }
    }
}
