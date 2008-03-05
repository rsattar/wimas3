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
    
    public class HMAC  {
        
        private var SHA256_H:Array        = null;
        private var SHA256_buf:Array      = null;
        private var HMAC_SHA256_key:Array = null;
        private var SHA256_len:Number     = 0;
        
        protected static const SHA256_hexchars:Array = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
          'a', 'b', 'c', 'd', 'e', 'f'];

        protected static const SHA256_K:Array = [
            0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 
            0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 
            0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 
            0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 
            0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 
            0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 
            0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 
            0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 
            0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 
            0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 
            0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2 ];
          
        /**
         * Compute HMAC_SHA256 hash given key and input data
         * @param key   secret to use as HMAC seed
         * @param msg   string to hash
         */
        public function SHA256(key:String, msg:Array):String {
            var res:Array;
            HMAC_SHA256_init(key);
            HMAC_SHA256_write(msg);
            res = HMAC_SHA256_finalize();
            return array_to_hex_string(res);
        }
        
        /**
         * Compute HMAC_SHA256 hash given key and input data
         * @param key   secret to use as HMAC seed
         * @param msg   string to hash
         * @return A hex encoded string of the hash
         */
        public function SHA256_S(key:String, msg:String):String {
            var res:Array;
            HMAC_SHA256_init(key);
            HMAC_SHA256_write_s(msg);
            res = HMAC_SHA256_finalize();
            return array_to_hex_string(res);
        }
        
        /**
         * Compute HMAC_SHA256 hash given key and input data
         * @param key   secret to use as HMAC seed
         * @param msg   string to hash
         * @return A base64 encoded string of the hash
         */
        public function SHA256_S_Base64(key:String, msg:String):String {
            var res:Array;
            HMAC_SHA256_init(key);
            HMAC_SHA256_write_s(msg);
            res = HMAC_SHA256_finalize();
            return Base64.encode(res);
        }
        
        /**
         * string_to_array: convert a string to a character (byte) array
         */
        private function string_to_array(str:String):Array {
            var len:Number = str.length;
            var res:Array = new Array(len);
            for(var i:Number = 0; i < len; i++)
                res[i] = str.charCodeAt(i);
            return res;
        }

        /**
         * array_to_hex_string: convert a byte array to a hexadecimal string
         */
        private function array_to_hex_string(ary:Array):String {
            var res:String = "";
            for(var i:Number = 0; i < ary.length; i++)
                res += SHA256_hexchars[ary[i] >> 4] + SHA256_hexchars[ary[i] & 0x0f];
            return res;
        }

        /**
         * initialize the internal state of the hash function.
         */
        private function SHA256_init():void {
            SHA256_H = new Array(0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 
                0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19);
            SHA256_buf = new Array();
            SHA256_len = 0;
        }

        /**
         * add a message fragment to the hash function's internal state.
         */
        private function SHA256_write(msg:Array):void {
            SHA256_buf = SHA256_buf.concat(msg);
            for(var i:Number = 0; i + 64 <= SHA256_buf.length; i += 64)
                SHA256_Hash_Byte_Block(SHA256_H, SHA256_buf.slice(i, i + 64));
            SHA256_buf = SHA256_buf.slice(i);
            SHA256_len += msg.length;
        }
        
        /**
         * add a message fragment to the hash function's internal state.
         */
        private function SHA256_write_s(msg:String):void {
            SHA256_buf = SHA256_buf.concat(string_to_array(msg));
            for(var i:Number = 0; i + 64 <= SHA256_buf.length; i += 64)
                SHA256_Hash_Byte_Block(SHA256_H, SHA256_buf.slice(i, i + 64));
            SHA256_buf = SHA256_buf.slice(i);
            SHA256_len += msg.length;
        }

        /**
         * finalize the hash value calculation.
         */
        private function SHA256_finalize():Array {
            SHA256_buf[SHA256_buf.length] = 0x80;

            if (SHA256_buf.length > 64 - 8) {
                for(i = SHA256_buf.length; i < 64; i++)
                    SHA256_buf[i] = 0;
                SHA256_Hash_Byte_Block(SHA256_H, SHA256_buf);
                SHA256_buf.length = 0;
            }

            for(var i:Number = SHA256_buf.length; i < 64 - 5; i++)
                SHA256_buf[i] = 0;
                
            SHA256_buf[59] = (SHA256_len >>> 29) & 0xff;
            SHA256_buf[60] = (SHA256_len >>> 21) & 0xff;
            SHA256_buf[61] = (SHA256_len >>> 13) & 0xff;
            SHA256_buf[62] = (SHA256_len >>> 5) & 0xff;
            SHA256_buf[63] = (SHA256_len << 3) & 0xff;
            SHA256_Hash_Byte_Block(SHA256_H, SHA256_buf);

            var res:Array = new Array(32);
            for(i = 0; i < 8; i++) {
                res[4 * i + 0] = SHA256_H[i] >>> 24;
                res[4 * i + 1] = (SHA256_H[i] >> 16) & 0xff;
                res[4 * i + 2] = (SHA256_H[i] >> 8) & 0xff;
                res[4 * i + 3] = SHA256_H[i] & 0xff;
            }

            SHA256_H = null;
            SHA256_buf = null;
            SHA256_len = 0;
            return res;
        }

        /**
         * calculate the hash value of the string or byte array 'msg'
         * 158 and return it as hexadecimal string.
         */
        private function SHA256_hash(msg:Array):String {
            var res:Array;
            SHA256_init();
            SHA256_write(msg);
            res = SHA256_finalize();
            return array_to_hex_string(res);
        }

        /**
         * initialize the MAC's internal state.
         */
        private function HMAC_SHA256_init(key:String):void {
            if (typeof(key) == "string")
                HMAC_SHA256_key = string_to_array(key);
            else
                HMAC_SHA256_key = new Array().concat(key);

            if (HMAC_SHA256_key.length > 64) {
                SHA256_init();
                SHA256_write(HMAC_SHA256_key);
                HMAC_SHA256_key = SHA256_finalize();
            }

            for(var i:Number = HMAC_SHA256_key.length; i < 64; i++)
                HMAC_SHA256_key[i] = 0;
            for(i = 0; i < 64; i++)
                HMAC_SHA256_key[i] ^=  0x36;
            SHA256_init();
            SHA256_write(HMAC_SHA256_key);
        }

        /**
         * process a message fragment
         */
        private function HMAC_SHA256_write(msg:Array):void {
            SHA256_write(msg);
        }
        
        /**
         * process a message fragment
         */
        private function HMAC_SHA256_write_s(msg:String):void {
            SHA256_write_s(msg);
        }

        /**
         * finalize the HMAC calculation
         */
        private function HMAC_SHA256_finalize():Array {
            var md:Array = SHA256_finalize();
            for(var i:Number = 0; i < 64; i++)
                HMAC_SHA256_key[i] ^= 0x36 ^ 0x5c;
            SHA256_init();
            SHA256_write(HMAC_SHA256_key);
            SHA256_write(md);
            for(i = 0; i < 64; i++)
                HMAC_SHA256_key[i] = 0;
            HMAC_SHA256_key = null;
            return SHA256_finalize();
        }

        /**
         * Byte array helpers.
         */
        private function SHA256_sigma0(x:Number):Number {
            return ((x >>> 7) | (x << 25)) ^ ((x >>> 18) | (x << 14)) ^ (x >>> 3);
        }

        private function SHA256_sigma1(x:Number):Number {
            return ((x >>> 17) | (x << 15)) ^ ((x >>> 19) | (x << 13)) ^ (x >>> 10);
        }

        private function SHA256_Sigma0(x:Number):Number {
            return ((x >>> 2) | (x << 30)) ^ ((x >>> 13) | (x << 19)) ^ 
                ((x >>> 22) | (x << 10));
        }

        private function SHA256_Sigma1(x:Number):Number {
            return ((x >>> 6) | (x << 26)) ^ ((x >>> 11) | (x << 21)) ^ 
                ((x >>> 25) | (x << 7));
        }

        private function SHA256_Ch(x:Number, y:Number, z:Number):Number {
            return z ^ (x & (y ^ z));
        }

        private function SHA256_Maj(x:Number, y:Number, z:Number):Number {
            return (x & y) ^ (z & (x ^ y));
        }

        private function SHA256_Hash_Word_Block(H:Array, W:Array):void {
            for(var i:Number = 16; i < 64; i++)
                W[i] = (SHA256_sigma1(W[i - 2]) +  W[i - 7] + 
                SHA256_sigma0(W[i - 15]) + W[i - 16]) & 0xffffffff;
            var state:Array = new Array().concat(H);
            for(i = 0; i < 64; i++) {
                var T1:Number = state[7] + SHA256_Sigma1(state[4]) + 
                SHA256_Ch(state[4], state[5], state[6]) + SHA256_K[i] + W[i];
                var T2:Number = SHA256_Sigma0(state[0]) + SHA256_Maj(state[0], state[1], state[2]);
                state.pop();
                state.unshift((T1 + T2) & 0xffffffff);
                state[4] = (state[4] + T1) & 0xffffffff;
            }
            for(i = 0; i < 8; i++)
                H[i] = (H[i] + state[i]) & 0xffffffff;
        }

        private function SHA256_Hash_Byte_Block(H:Array, w:Array):void {
            var W:Array = new Array(16);
            for(var i:Number = 0; i < 16; i++)
                W[i] = w[4 * i + 0] << 24 | w[4 * i + 1] << 16 | 
                    w[4 * i + 2] << 8 | w[4 * i + 3];
            SHA256_Hash_Word_Block(H, W);
        }
    }
}