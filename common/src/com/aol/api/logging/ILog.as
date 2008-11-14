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

package com.aol.api.logging {

    /**
     * The interface for this logger matches that of mx.logging.ILogger so that you can use either this class or 
     * mx.logging.ILogger depending on whether or not you want to depend on the mx libraries.
     * 
     * For full delays on this interface, see the documentation for mx.logging.Ilogger.
     * 
     */   

    //TODO:  Does this need to extend IEventDispatcher just because mx.logging.ILogger does?
    public interface ILog
    {        
        /**
         *  In Flex, you can filter logs by their category.  For us, this is only present for API compatibility.
         *
         *  @return String containing the category for this logger.
         */
        function get category():String;
    
        /**
         *  Logs the specified data at the given level.
         *  
         *  <p>The String specified for logging can contain braces with an index
         *  indicating which additional parameter should be inserted
         *  into the String before it is logged.
         *  For example "the first additional parameter was {0} the second was {1}"
         *  is translated into "the first additional parameter was 10 the
         *  second was 15" when called with 10 and 15 as parameters.</p>
         *  
         *  @param level The level this information should be logged at.
         *  Valid values are:
         *  <ul>
         *    <li><code>LogEventLevel.FATAL</code> designates events that are very
         *    harmful and will eventually lead to application failure</li>
         *
         *    <li><code>LogEventLevel.ERROR</code> designates error events
         *    that might still allow the application to continue running.</li>
         *
         *    <li><code>LogEventLevel.WARN</code> designates events that could be
         *    harmful to the application operation</li>
         *
         *    <li><code>LogEventLevel.INFO</code> designates informational messages
         *    that highlight the progress of the application at
         *    coarse-grained level.</li>
         *
         *    <li><code>LogEventLevel.DEBUG</code> designates informational
         *    level messages that are fine grained and most helpful when
         *    debugging an application.</li>
         *
         *    <li><code>LogEventLevel.ALL</code> intended to force a target to
         *    process all messages.</li>
         *  </ul>
         *
         *  @param message The information to log.
         *  This String can contain special marker characters of the form {x},
         *  where x is a zero based index that will be replaced with
         *  the additional parameters found at that index if specified.
         *
         *  @param rest Additional parameters that can be subsituted in the str
         *  parameter at each "{<code>x</code>}" location, where <code>x</code>
         *  is an integer (zero based) index value into the Array of values
         *  specified.  
         */
        function log(level:int, message:String, ... rest):void;
    
        /**
         *  Logs the specified data using the <code>LogEventLevel.DEBUG</code>
         *  level.
         *  <code>LogEventLevel.DEBUG</code> designates informational level
         *  messages that are fine grained and most helpful when debugging
         *  an application.
         *  
         * @see com.aol.api.logging.ILog.log
         */
        function debug(message:String, ... rest):void;
    
        /**
         *  Logs the specified data using the <code>LogEventLevel.ERROR</code>
         *  level.
         *  <code>LogEventLevel.ERROR</code> designates error events
         *  that might still allow the application to continue running.
         *  
         * @see com.aol.api.logging.ILog.log
         */
        function error(message:String, ... rest):void;
    
        /**
         *  Logs the specified data using the <code>LogEventLevel.FATAL</code> 
         *  level.
         *  <code>LogEventLevel.FATAL</code> designates events that are very 
         *  harmful and will eventually lead to application failure
         *
         * @see com.aol.api.logging.ILog.log
         */
        function fatal(message:String, ... rest):void;
    
        /**
         *  Logs the specified data using the <code>LogEvent.INFO</code> level.
         *  <code>LogEventLevel.INFO</code> designates informational messages that 
         *  highlight the progress of the application at coarse-grained level.
         *  
         * @see com.aol.api.logging.ILog.log
         */
        function info(message:String, ... rest):void;
    
        /**
         *  Logs the specified data using the <code>LogEventLevel.WARN</code> level.
         *  <code>LogEventLevel.WARN</code> designates events that could be harmful 
         *  to the application operation.
         *      
         * @see com.aol.api.logging.ILog.log
         */
        function warn(message:String, ... rest):void;

    }
}