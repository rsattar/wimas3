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
     * This is an enumeration representing the Type of event received from WIM.
     * To use this class, assign a FetchEventType variable using the static
     * properties of this class. 
     */
    final public class FetchEventType {
        
        /**
         * Indicates that this event contains updated presence data for our own identity
         */
        public static const MY_INFO:String      = "myInfo";
        /**
         * Indicates that this event contains updated presence data for a user
         */
        public static const PRESENCE:String     = "presence";
        /**
         * Indicates that this event contains buddy list data
         */
        public static const BUDDY_LIST:String   = "buddylist";
        /**
         * Indicates that this event represents typing information for an IM
         */
        public static const TYPING:String       = "typing";
        /**
         * Indicates that this event contains instant message information
         */
        public static const IM:String           = "im";
        /**
         * Indicates that this event contains data IM information
         */
        public static const DATA_IM:String      = "dataIM";
        /**
         * Indicates that our session has ended.
         */
        public static const END_SESSION:String  = "sessionEnded"; // Documentation says 'endSession' but data returned is 'sessionEnded'
        /**
         * Indicates that we have received an offline instant message.
         */
        public static const OFFLINE_IM:String   = "offlineIM";
        /**
         * Indicates that someone has added the user to their list. 
         */
        public static const ADDED_TO_LIST:String = "userAddedToBuddyList";
    }
}