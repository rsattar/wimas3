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

package com.aol.api.wim.events
{
    import flash.events.Event;

    public class MemberDirectoryEvent extends Event
    {
        /** Event type for a search which is about to be performed. Cancel this event to prevent it from being requested */
        public static const DIRECTORY_SEARCHING:String = "directorySearching";
        
        /** Event type for completed searches. */
        public static const DIRECTORY_SEARCH_RESULT:String = "directorySearchResult";
        
        /** Event type for an IO_ERROR while doing a member directory search */
        public static const DIRECTORY_SEARCH_IO_ERROR:String = "directorySearchIOError";
        
        /** 
          * Event type for a get which is about to be performed (a 'get' is a query for the data of an individual user. 
          * Cancel this event to prevent it from being requested 
          */
        public static const DIRECTORY_GETTING:String = "directoryGetting";
        
        /** Event type for completed get. */
        public static const DIRECTORY_GET_RESULT:String = "directoryGetResult";
        
        /** Event type for an IO_ERROR while doing a member directory get */
        public static const DIRECTORY_GET_IO_ERROR:String = "directoryGetIOError";

        /**
         * A hash of all conditions searched against.
         * All parameters are strings.
         * Set only in DIRECTORY_SEARCHING events.
         * 
         * @see http://dev.aol.com/aim/web/serverapi_reference#searchMemberDir
         */
        public var searchTerms:Object;
            
        /**
        * An array of profile & aim preferences pairs. 
        * Untyped.
        * Only set in DIRECTORY_SEARCH_RESULT events.
        * 
        * @see http://dev.aol.com/aim/web/serverapi_reference#MemberDirInfo
        */
        public var searchResults:Array;
        
        /**
         * The status code of the response from the server. 
         */
        public var statusCode:Number;
        
        /**
         * The number (if any) of profiles that were NOT returned by the host
         * due to requesting a limited number of results.
         * Only set in DIRECTORY_SEARCH_RESULT events.
         */
        public var skippedProfiles:int;
        
        /**
         * The total number of profiles matching the search results. Should be <pre>skippedProfiles + numProfiles</pre>.
         * Only set in DIRECTORY_SEARCH_RESULT events.
         */
        public var totalProfiles:int;
        
        /**
         * The number (if any) of profiles that were returned by the host.
         * Only set in DIRECTORY_SEARCH_RESULT events.
         */
        public var numProfiles:int;
        
        public var requestId:uint;
        
        /**
         * How much data to return about each user.
         * 
         * @see com.aol.api.wim.data.types.MemberDirectoryInfoLevelType
         */  
        public var level:String; 
        
        /**
         * Caller context object.  Not used by the logic involved in these 
         * events.  It is available strictly as a means for the caller to pass
         * data to the listener. 
         */  
        public var context:Object = null;
        
        public function MemberDirectoryEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true)
        {
            super(type, bubbles, cancelable);
        }
        
        override public function toString():String
        {
            return "[MemberDirectoryEvent." + type + "]";
        }
    }
}