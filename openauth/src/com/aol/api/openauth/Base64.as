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

import flash.utils.ByteArray;

/**
 * Convert an array of ints into a Base64 formatted string.
 */
public class Base64 {
    public function Base64() {}
    
    /**
     * Array of ints go in, Base64 String comes out.
     */
    public static function encode(array:Array):String {
        var output:String = new String();
        var padding:String = new String();

        // Normalize to a multiple of 3.      
        var padCount:int = array.length % 3;
        if (padCount > 0) {
            while (padCount < 3) {
                padding += "=";
                array.push(0);
                padCount++;
            }
        }
        
        var temp:Number;
        var encode1:int;
        var encode2:int;
        var encode3:int;
        var encode4:int;
        var i:int;
        var length:int = array.length; 
        for (i=0; i<length; i+=3) {       
            temp = (array[i] << 16) + (array[i+1] << 8) + array[i+2];
            encode1 = (temp >>> 18) & 63;
            encode2 = (temp >>> 12) & 63;
            encode3 = (temp >>> 6) & 63;
            encode4 = temp & 63;
            
            output += _chars[encode1] + _chars[encode2] + _chars[encode3] + _chars[encode4]; 
        }
        
        return output.substring(0, output.length - padding.length) + padding;
    }

    private static var _chars:Array = new Array(
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
        'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
        'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
        'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3',
        '4', '5', '6', '7', '8', '9', '+', '/'
    );
}
}
