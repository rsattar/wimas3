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

package com.aol.api.wim.data {
    
    public class AuthChallenge {
        
        /**
         * The type of challenge. 
         * 
         * @see com.aol.api.wim.data.types.AuthChallengeType
         */        
        public var type:String;
        
        /**
         * Addition info from the server.
         */ 
        public var info:String;
        
        /**
         * The url for a captcha image. This url points to binary data, returning image/jpeg.
         */        
        public var captchaImageUrl:String;
        
        /**
         * The url for a captcha audio file. This url points to binary data, returning audio/mpeg.
         */ 
        public var captchaAudioUrl:String;
        
        /**
         * The account security question. This should be shown to the user.
         */ 
        public var accountSecurityQuestion:String;
        
        public function AuthChallenge(type:String, info:String=null, asqQuestion:String=null, captchaImageUrl:String=null, captchaAudioUrl:String=null) {
            this.type = type;
            this.info = info;
            this.captchaImageUrl = captchaImageUrl;
            this.captchaAudioUrl = captchaAudioUrl;
            this.accountSecurityQuestion = asqQuestion;
        }

    }
}