package com.aol.api.wim.events
{
    import com.aol.api.wim.data.AuthChallenge;
    
    import flash.events.Event;

    /**
     * This corresponsds to the types of errors available in OpenAuth.
     * 
     * @see http://dev.aol.com/openauth_api#login, look under Error Codes 
     */
    public class AuthChallengeEvent extends Event
    {
        /**
         * The type for the authentication challenge.
         */        
        public static const AUTHENTICATION_CHALLENGED:String = "AUTHENTICATION_CHALLENGED";
        
        /**
         * The authentication challenge object.
         * 
         * @see com.aol.api.wim.data.AuthChallenge
         */
        public var challenge:AuthChallenge;
        
        /**
         * The authentication challenge object's type. This is provided for convenience
         * 
         * @see com.aol.api.wim.data.AuthChallengeType
         */
        public var challengeType:String;
        
        public function AuthChallengeEvent(challenge:AuthChallenge, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(AuthChallengeEvent.AUTHENTICATION_CHALLENGED, bubbles, cancelable);
            this.challenge = challenge;
            this.challengeType = challenge.type;
        }
        
    }
}