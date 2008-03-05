package com.aol.api.wim.data {
    import com.aol.api.wim.data.types.PresenceState;
    
    
    /**
    * Represents a user. Could either be a buddy, or the user that
    * is signed in to a session.
    */
    
    public class User {
        /**
        * Normalized AIM ID. Use this to identify objects like conversations and windows.
        */
        public var aimId:String;
        /**
        * Formatted AIM ID. Use this to display the aim ID to the user.
        */
        public var displayId:String;
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
        * User's capabilities in an array.
        */
        public var capabilities:Array;
                
        /**
        * Returns the displayId, or aimId if displayId is undefined.
        * This is a read-only property. Set displayId or aimId instead.
        */
        public function get label():String
        {
            return displayId ? displayId : aimId;
        }
 
        public function toString():String {
            return "[User:" + aimId + 
                   " displayId=" + displayId + 
                   ", emailId=" + emailId + 
                   ", state=" + state +
                   ", onlineTime=" + onlineTime +
                   ", idleTime=" + idleTime +
                   ", awayTime=" + awayTime +
                   ", statusTime=" + statusTime +
                   ", awayMessage=" + awayMessage +
                   ", statusMessage=" + statusMessage +
                   ", buddyIconURL=" + buddyIconURL +
                   ", presenceIconURL=" + presenceIconURL +
                   ", memberSince=" + memberSince +
                   ", capabilities=" + capabilities + 
                   "]";
        }
        
        public function equals(other:User):Boolean {
            return (other.uniqueIdentifier == this.uniqueIdentifier);
        }
        
        /**
        * If ICQ support adds in other fields, update this method to
        * check if the user is ICQ or AIM and return the appropriate ID.
        * @author Roger Braunstein
        */
        public function get uniqueIdentifier():String
        {
            return aimId;
        }
    }
}
