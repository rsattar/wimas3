package com.aol.api.wim.data
{
    /**
     * This represents a group on the buddy list for a private chat, or IMServ.
     * @author Rizwan
     * 
     */    
    public class IMServGroup extends Group
    {
        /**
         * The name of the imservId 
         */
        public var imServId:String;
        
        public function IMServGroup(name:String, imServId:String, users:Array=null)
        {
            super(name, users);
            this.imServId = imServId;
        }
        
    }
}