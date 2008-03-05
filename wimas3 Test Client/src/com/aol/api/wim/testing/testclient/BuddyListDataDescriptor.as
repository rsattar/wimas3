package com.aol.api.wim.testing.testclient
{
    import com.aol.api.wim.data.BuddyList;
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.data.User;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.controls.treeClasses.ITreeDataDescriptor;

    /**
     * A TreeDataDescriptor that can interpret the BuddyList
     * 
     * @author osmanullah1
     * 
     */
    public class BuddyListDataDescriptor implements ITreeDataDescriptor {
        public function BuddyListDataDescriptor() {
            super();
        }

        public function getChildren(node:Object, model:Object=null):ICollectionView {
            if(!node) return null;
            
            if(node is BuddyList) {
                return new ArrayCollection((node as BuddyList).groups);
            }
            else if(node is Group) {
                return new ArrayCollection((node as Group).users);
            }
            else if(node is User) {
                return null;
            }
            return null;
        }
        
        public function hasChildren(node:Object, model:Object=null):Boolean {
            if(!node) return false;
            var hasChildren:Boolean = false;
            if(node is BuddyList) {
                if((node as BuddyList).groups.length > 0)
                    hasChildren = true;
            }
            else if(node is Group) {
                if((node as Group).users.length > 0)
                    hasChildren = true; 
            }
            else if(node is User) {
                hasChildren = false;
            }
            return hasChildren;
        }
        
        public function isBranch(node:Object, model:Object=null):Boolean {
            if(!node) return false;
            var isBranch:Boolean = false;
            if(node is BuddyList) {
                isBranch = true;
            }
            else if(node is Group) {
                isBranch = true;
            }
            else if(node is User) {
                isBranch = false;
            }
            return isBranch;
        }
        
        public function getData(node:Object, model:Object=null):Object {
            return node;
        }
        
        public function addChildAt(parent:Object, newChild:Object, index:int, model:Object=null):Boolean {
            return false;
        }
        
        public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean {
            return false;
        }
    }
}