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

package com.aol.api.openauth
{
    /**
     * This class represent an OpenAuth Token from AOL. The <code>a</code> property of this object
     * is the actual token string. The token also holds an <code>expiresIn</code> property, which describes
     * the amount of time this token is valid, in seconds. A convenience function displays the time left, since this token
     * was created.
     */
    public class AuthToken
    {
        private var _a:String   =   null;
        private var _expiresIn:Number   =   0;
        private var _expirationTime:Date  =   null;
        private var _hostTime:Number = 0;

        public function AuthToken(a:String, expiresIn:Number, hostTime:Number):void {
            _a = a;
            _expiresIn = expiresIn;
            _expirationTime = new Date();
            // Expiration time is [now] + expiry, in seconds
            _expirationTime.time += 1000 * expiresIn;
            _hostTime = hostTime;
        }
        
        /**
         * Returns the token 'a' string. This property is read-only
         */
        public function get a():String {
            return _a;
        }
        
        /**
         * Returns the amount of time this token is valid, in seconds. This property is read-only
         */
        public function get expiresIn():Number {
            return _expiresIn;
        }
        
        /**
         * Returns the amount of time (since creation) of this object that this token is valid.
         */
        public function get timeLeft():Number {
            return _expirationTime.time;
        }
        
        /** 
         * Returns the time in seconds since epoch for the host which created the token.
         */
        public function get hostTime():Number {
            return _hostTime;
        } 
    }
}