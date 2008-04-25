package com.aol.api.wim.data.types
{
    /**
     * Represents possible values for the "pdMode" parameter in the setPermitDeny call.
     *  
     */
    public class PermitDenyMode
    {
        /**
         * This permit mode allows all aimIds. 
         */
        public static var PERMIT_ALL:String = "permitAll";
        /**
         * This permit mode only allows aimIds on the allow list. 
         */
        public static var PERMIT_SOME:String = "permitSome";
        /**
         * This permit mode only allows aimIds on the Buddy List. 
         */
        public static var PERMIT_ON_LIST:String = "permitOnList";
        /**
         * This permit mode allows all aimIds who are not on the block list. 
         */
        public static var DENY_SOME:String = "denySome";
        /**
         * This permit mode doesn't allow anyone. 
         */
        public static var DENY_ALL:String  = "denyAll";
    }
}