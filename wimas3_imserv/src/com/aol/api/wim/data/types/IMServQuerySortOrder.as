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
     * This is an enumeration representing the different sort orders that can
     * be requested when doing a IMServ query
     */   
    public final class IMServQuerySortOrder
    {
        
        /**
        * No sort order
        */
        public static const NONE:String = "none";
        
        /**
        * Ascending by name
        */
        public static const ASCENDING_NAME:String = "ascendingName";

        /**
        * Descending by name
        */
        public static const DESCENDING_NAME:String = "descendingName";
        
        /**
        * Ascending by date
        */
        public static const ASCENDING_DATE:String = "ascendingDate";
        
        /**
        * Descending by date
        */
        public static const DESCENDING_DATE:String = "descendingDate";
        
        /**
        * Ascending Login Time
        */
        public static const ASCENDING_LOGINTIME:String = "ascendingLoginTime";
        
        /**
        * Descending Login Time
        */
        public static const DESCENDING_LOGINTIME:String = "descendingLoginTime";

    }
}