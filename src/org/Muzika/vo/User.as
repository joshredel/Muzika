package org.muzika.vo {
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	/**
	 * A User is a member of the system that has registered via the profile page.
	 */
	public class User {
		
		/**
		 * The shared object representing the local storage of users.
		 */
		private static var userSO:SharedObject = SharedObject.getLocal("users");
		
		/**
		 * The collection of all users.
		 */
		private static var _users:ArrayCollection;
		
		/**
		 * The user that is currently logged in.
		 */
		public static var loggedInUser:User;
		
		/**
		 * Gets the collection of all users.
		 */
		public static function get users():ArrayCollection {
			// make sure we actually have a set of users
			if(!_users) {
				// create a new collection
				_users = new ArrayCollection();
				
				// if there is data in the shared object, grab it!
				if(userSO.data['users']) {
					// there is... so let's cast them all to User value objects
					var temp:ArrayCollection = userSO.data['users'];
					
					// loop through each item and copy them into a new user
					for each(var user:* in temp) {
						_users.addItem(new User(user.profileName, user.pictureName, false));
					}
				}
			}
			
			// return our collection of users
			return _users;
		}
		
		/**
		 * The profile name of the user.
		 */
		private var _profileName:String;
		
		/**
		 * Gets the user's profile name.
		 */
		public function get profileName():String {
			return _profileName;
		}
		
		/**
		 * Sets the user's profile name.
		 */
		public function set profileName(value:String):void {
			// store the value
			_profileName = value;
			
			// save the user
			this.save();
		}
		
		/**
		 * The name of the picture representing the user.
		 * Used to fetch it from a list of pictures.
		 */
		private var _pictureName:String;
		
		/**
		 * Gets the user's profile name.
		 */
		public function get pictureName():String {
			return _pictureName;
		}
		
		/**
		 * Sets the user's profile name.
		 */
		public function set pictureName(value:String):void {
			// store the value
			_pictureName = value;
			
			// save the user
			this.save();
		}
		
		/**
		 * Creates a new User value object with the desired username and 
		 * profile picture name.
		 */
		public function User(profileName:String, pictureName:String, saveImmediately:Boolean = true) {
			// store the properties
			this._profileName = profileName;
			this._pictureName = pictureName;
			
			// add this user to the collection
			if(saveImmediately) {
				this.save();
			}
		}
		
		/**
		 * Saves the user and all changes made to it since the last save.
		 * Creates the user in storage if it does not exist.
		 */
		private function save():void {
			// see if the user already exists in the database
			if(!User.users.contains(this)) {
				// it does not, so add it!
				User.users.addItem(this);
			}
			
			// now save and flush
			User.userSO.data.users = User.users;
			User.userSO.flush();
		}
		
		/**
		 * Deletes the user from the database.
		 */
		public function remove():void {
			// remove the user
			User._users.removeItemAt(User.users.getItemIndex(this));
			
			// now save and flush
			User.userSO.data.users = User.users;
			User.userSO.flush();
		}
	}
}