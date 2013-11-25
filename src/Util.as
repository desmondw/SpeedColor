package  
{
	public class Util 
	{
		public static function randInt(min:int, max:int):int
		{
			return Math.random() * (max - min + 1) + min;
		}
		
		//returns in format hh:mm:ss.#
		public static function getFormatedTime(ms:Number, decimalAmount:uint):String
		{
			var s:int = ms / 1000;
			ms %= 1000;
			var m:int = s / 60;
			s %= 60;
			var h:int = m / 60;
			m %= 60;
			
			var time:String = new String("");
			
			if (h > 0)
			{
				time += h.toString() + ":";
				
				if (m < 10)
					time += "0";
				time += m.toString() + ":";
				
				if (s < 10)
					time += "0";
				time += s.toString();
			}
			else if (m > 0)
			{
				time += m.toString() + ":";
				
				if (s < 10)
					time += "0";
				time += s.toString();
			}
			else
				time += s.toString();
			if (decimalAmount > 0)
			{
				if (decimalAmount > ms.toString().length)
					time += "." + ms;
				else
					time += "." + ms.toString().substr(0, decimalAmount);
			}
			
			return time;
		}
	}
}