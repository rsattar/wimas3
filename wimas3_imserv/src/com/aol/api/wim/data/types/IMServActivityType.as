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

package com.aol.api.wim.data.types
{
    /**
     * This is an enumeration representing the different types of activities that can be
     * logged in an IMServ. Often this activity type is in the context of 2 members (member1 and member2)
     */
    public final class IMServActivityType
    {
        /**
        * member2 made member1 joined the IMServ
        */
        public static const MEMBER_JOIN:String = "memberJoin";
        
        /**
        * member2 made member1 leave the IMServ
        */
        public static const MEMBER_LEFT:String = "memberLeft";
        
        /**
        * member2 accepted member1's invite
        */
        public static const INVITE_ACCEPTED:String = "inviteAccepted";
        
        /**
        * member2 accepted member1's owner transfer invite
        */
        public static const INVITE_TRANSFER_ACCEPTED:String = "inviteTransferAccepted";
        
        /**
        * member2 rejected member1's invite
        */
        public static const INVITE_REJECTED:String = "inviteRejected";
        
        /**
        * member2 rejected member1's owner transfer invite
        */
        public static const INVITE_TRANSFER_REJECTED:String = "inviteTransferRejected";
      
        /**
        * member1's invite of member2 expired
        */
        public static const INVITE_EXPIRED:String = "inviteExpired";
        
        /**
        * member1's owner transfer invite of member2 expired
        */
        public static const INVITE_TRANSFER_EXPIRED:String = "inviteTransferExpired";
        
        /**
        * member1 transfered ownership to member2
        */
        public static const OWNER_CHANGE:String = "ownerChange";
        
        /**
        * member1 made member2 an editor
        */
        public static const BECAME_EDITOR:String = "becameEditor";
        
        /**
        * member1 made member2 to quit being an editor
        */
        public static const QUIT_EDITOR:String = "quitEditor";
        
        /**
        * member1 set imserv to disabled
        */
        public static const DISABLED:String = "disabled";
        
        /**
        * member1 set imserv to enabled
        */
        public static const ENABLED:String = "enabled";
        
        /**
        * member2 invites member1 to join the imserv group
        */
        public static const INVITE_JOIN:String = "inviteJoin";
        
        /**
        * member2 invites member1 to take ownership of the imserv group
        */
        public static const INVITE_OWNER_TRANSFERRED:String = "inviteOwnerTransferred";
    }
}