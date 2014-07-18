package org.muzika.events {
	import flash.events.Event;
	
	public class NoteEvent extends Event {
		
		public static var DELETE_NOTE:String = "deleteNote";
		
		public function NoteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}