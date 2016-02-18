package org.farmcode.hoborg
{
	
	import flash.utils.Dictionary;
	
	public class Cloner
	{
		private static var cloneLibrary:Dictionary = new Dictionary(true);
		//private static var cloning:Boolean = false; // this avoids recursion
		
		public static function clone(object:*, allowSelfCloneBehaviour: Boolean = true):*{
			if(object==null)return;
			var description:ObjectDescription = ObjectDescriber.describe(object);
			var cloneResult: * = null;
			var trackClone: Boolean = false;
			switch(description.classPath){
				case "String":
				case "Number":
				case "uint":
				case "int":
				case "Boolean":
					return object;
				case "Array":
					var arrObject: Array = object;
					trackClone = true;
					cloneResult = arrObject.slice();
					break;
				case "flash.utils::Dictionary":
					var dictObject: Dictionary = object;
					cloneResult = new Dictionary();
					for (var key: * in dictObject)
					{
						cloneResult[key] = dictObject[key];
					}
					trackClone = true;
					break;
				default:
					trackClone = true;
					if (object is ISelfCloning && allowSelfCloneBehaviour)
					{
						var selfCloning: ISelfCloning = object as ISelfCloning;
						cloneResult = selfCloning.clone();
					}
					else
					{
						cloneResult = Pooler.takeObject(object);
						for each(var propDesc:ObjectPropertyDescription in description.properties){
							if(propDesc.clone && propDesc.writable){
								if(propDesc.deepClone){
									cloneResult[propDesc.propertyName] = clone(object[propDesc.propertyName]);
								}else{
									cloneResult[propDesc.propertyName] = object[propDesc.propertyName];
								}
							}
						}
					}
			}
			
			if (trackClone)
			{
				var id:Number = cloneLibrary[object];
				if (isNaN(id))
				{
					id = Math.random();
					cloneLibrary[object] = id;
				}
				cloneLibrary[cloneResult] = id;
			}
			
			return cloneResult;
		}
		
		/**
		 * TODO: make this listen to (selected) object pools to clear ids as items are released.
		 */
		public static function areClones(object1:*,object2:*):Boolean{
			return (cloneLibrary[object1]!=null && cloneLibrary[object1]==cloneLibrary[object2]);
		}
		protected static function onObjectReleased(e:PoolingEvent):void{
			delete cloneLibrary[e.object];
		}
	}
}