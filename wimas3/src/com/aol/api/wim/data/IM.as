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

package com.aol.api.wim.data
{
    /**
     * Represents an incoming or outgoing IM.
     * 
     * @see com.aol.api.wim.data.DataIM
     */
     
    public class IM
    {
        /**
         * The message in MXML data
         */
        public var message:String;
        
        /**
         * UTC timestamp of when the message was sent.
         */        
        public var timestamp:Date;
        
        /**
         * True if the message is an autoresponse message. 
         */
        public var isAutoResponse:Boolean;
        
        /**
         * True if the message is an offline message. 
         */
        public var isOfflineMessage:Boolean;
        
        /**
         * True if the message is an archived message (from AIM logs, or other means of storage). This is generally set
         * by the client, and not by the wimas3 service, so by default this will usually be false. 
         */
        public var isArchivedMessage:Boolean;
        
        /**
         * The sender of the IM 
         */
        public var sender:User;
        
        /**
         * The recipient of the IM
         */
        public var recipient:User;
        
        /**
         * True if this is an incoming IM. False if it is an outgoing IM.
         */
        public var incoming:Boolean;
        
        /**
         * If not null, contains raw message information about the sender's country code, as well as a base64 encoded raw message block 
         */        
        public var rawMessageData:IMRawMessageData;   
        
        /**
         * Default is null. Can be "imservMsg" or "imservWirelessMsg"
         */
        public var specialIMType:String;     
        
        /**
         * Stores optional, contextual information about the type of IM this is, such as more detailed info about IMServ IMs
         * NOTE: should we move IMServIMInfo to the wimas3 project, so that we can access it even without requiring wimas3_imserv? --Riz 
         */        
        public var specialIMInfo:*;
        
        public function IM(message:String, timestamp:Date, sender:User, recipient:User, incoming:Boolean, isAutoResponse:Boolean=false, isOfflineMessage:Boolean=false, isArchivedMessage:Boolean=false)
        {
            this.message = message;
            this.timestamp = timestamp;
            this.isAutoResponse = isAutoResponse;
            this.isOfflineMessage = isOfflineMessage;
            this.isArchivedMessage = isArchivedMessage;
            this.sender = sender;
            this.recipient = recipient;
            this.incoming = incoming;
        }
        
        public function toString():String
        {
            return "[IM" + 
                   " message='" + message + "'" + 
                   ", timestamp=" + timestamp + 
                   ", sender=" + sender + 
                   ", recipient=" + recipient + 
                   ", isAutoResponse=" + isAutoResponse +
                   "]";
        }
    }
}