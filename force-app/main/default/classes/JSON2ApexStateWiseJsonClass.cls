public with sharing class JSON2ApexStateWiseJsonClass {

	public String state;
	public String statecode;
	public List<DistrictData> districtData;

	public class Delta {
		public Integer confirmed;
		public Integer deceased;
		public Integer recovered;
	}

	public class DistrictData {
		public String district;
		public String notes;
		public Integer active;
		public Integer confirmed;
		public Integer deceased;
		public Integer recovered;
		public Delta delta;
	}

	
	public static List<JSON2ApexStateWiseJsonClass> parse(String json) {
		return (List<JSON2ApexStateWiseJsonClass>) System.JSON.deserialize(json, List<JSON2ApexStateWiseJsonClass>.class);
	}
}