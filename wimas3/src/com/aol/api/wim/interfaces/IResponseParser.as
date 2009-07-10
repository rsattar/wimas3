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

package com.aol.api.wim.interfaces {
    
    import com.aol.api.wim.data.BuddyList;
    import com.aol.api.wim.data.DataIM;
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.data.IM;
    import com.aol.api.wim.data.SMSInfo;
    import com.aol.api.wim.data.User;
    
    public interface IResponseParser {
        
        // Simple data parsing
        /**
         * Creates a user object out of the data 
         * @param data
         * @return A <code>User</code> object.
         * 
         */        
        function parseUser(data:*):User;
        /**
         * Creates a <code>BuddyList</code> object out of the data 
         * @param data
         * @return a <code>BuddyList</code> object
         * 
         */        
        function parseBuddyList(data:*, owner:User=null):BuddyList;
        /**
         * Creates a <code>Group</code> object out of the data 
         * @param data
         * @return a <code>Group</code> object
         * 
         */        
        function parseGroup(data:*):Group;
        
        /**
         * Creates an <code>IM</code> object out of the data 
         * @param data
         * @return an <code>Group</code> object
         * 
         */        
        function parseIM(data:*, recipient:User=null, isOffline:Boolean=false, incoming:Boolean=true):IM;
        
        /**
         * Creates an <code>SMSInfo</code> object out of the data 
         * @param data
         * @return 
         * 
         */        
        function parseSMSInfo(data:*):SMSInfo;
        
        /**
         * Creates a <code>DataIM</code> object out of the data 
         * @param data
         * @return an <code>DataIM</code> object
         * 
         */        
        function parseDataIM(data:*, recipient:User=null):DataIM;
    }
       
}