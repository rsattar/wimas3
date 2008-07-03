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
    import com.aol.api.wim.data.User;
    /**
     * Represents a group on the buddy list. Consists of a group name,
     * and an array of User objects for the group.
     */
    public class Group {
        /**
         * The name of the group 
         */
        public var label:String;
        
        /**
         * The users in the group, consisting of User objects.
         */
        public var users:Array;
        
        /**
         * If this is a "recent users" group, users cannot be added to it.
         */
        public var recent:Boolean;
        
        /**
         * Creates a new group object. If no users array is passed in,
         * an empty array will be created.
         *  
         * @param name  The name of the group.
         * @param users Optional. The array of users for the group.
         * 
         */
        public function Group(name:String, users:Array=null) {
            this.label = name;
            this.users = (users == null) ? new Array() : users;
            this.recent = false;
        }

        public function toString():String {
            return "[Group " + 
                    " label=" + label +
                    ", users=" + users.toString() +
                    "]";
        }

    }
}