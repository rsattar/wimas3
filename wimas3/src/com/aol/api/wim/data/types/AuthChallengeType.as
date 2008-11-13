/* 
Copyright (c) 2008 AOL LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the AOL LCC nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/

package com.aol.api.wim.data.types {
    
    /**
     * This corresponsds to the types of errors available in OpenAuth.
     * 
     * @see http://dev.aol.com/openauth_api#login, look under Error Codes 
     */
    public final class AuthChallengeType {
        
        /**
         * Invalid login credentials.
         */        
        public static const USERPASS_CHALLENGE:String = "userPassChallenge";
        
        /**
         * A captcha challenge. Inspect <code>captchaImageUrl</code> and <code>captchaAudioUrl</code> for more information.
         */        
        public static const CAPTCHA_CHALLENGE:String = "captchaChallenge";
        
        
        /**
         * A securid number must be supplied during login.
         */        
        public static const SECURID_CHALLENGE:String = "securidChallenge";
        
        
        /**
         * The next securid number must be supplied during login.
         */        
        public static const SECURID_NEXT_CHALLENGE:String = "securidNextChallenge";
        
        
        /**
         * Consent is required before login.
         */        
        public static const CONSENT_CHALLENGE:String = "consentChallenge";
        
        
        /**
         * Account security question must be answered. Inspect <code>accountSecurityQuestion</code> for more information.
         */        
        public static const ASQ_CHALLENGE:String = "asqChallenge";
        
        /**
         * Dude, you are SOL.  This may mean that the account is parentally blocked or there may be other reasons but this
         * account will not be allowed to log in.
         */        
        public static const NOT_ALLOWED:String = "SOL";        
        
    }
}