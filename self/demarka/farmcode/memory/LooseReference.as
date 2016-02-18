package org.farmcode.memory
{
	import flash.utils.Dictionary;
	
	public class LooseReference
	{
		public function get referenceExists():Boolean{
			for each(var i:Boolean in storage){
				return i;
			}
			return false;
		}
		public function get reference():Object{
			for(var i:* in storage){
				return i as Object;
			}
			return null;
		}
		
		public function set locked(value: Boolean): void
		{
			if (value != this.locked)
			{
				this._locked = value;
				if (this.locked)
				{
					this.lockedReference = this.reference;
				}
				else
				{
					this.lockedReference = null;
				}
			}
		}
		public function get locked(): Boolean
		{
			return this._locked;
		}
		
		private var storage:Dictionary = new Dictionary(true);
		private var _locked: Boolean;
		private var lockedReference: Object;
		
		public function LooseReference(object:Object){
			this.lockedReference = null;
			this._locked = false;
			storage[object] = true;
		}
	}
}