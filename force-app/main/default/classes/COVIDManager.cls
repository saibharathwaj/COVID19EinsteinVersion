public class COVIDManager {
	@AuraEnabled
    public static list<COVID19CountrySummary> getCOVID19Summary(){
    	list<COVID19CountrySummary> COVID19Summary = new list<COVID19CountrySummary>();        
        String accToken;
       	String responseBody;
       	String endPoint = 'https://api.covid19api.com/summary';
       	Http h1 = new Http();
       	HttpRequest req1 = new HttpRequest();
       	req1.setHeader('Content-Type','application/json');
       	req1.setMethod('GET');
       	req1.setEndpoint(endPoint);
       	HttpResponse hresp1 = h1.send(req1);
       	system.debug('****hresp1.getBody()' + hresp1.getBody());
        JSONParser parser = JSON.createParser(hresp1.getBody());
        While(parser.nextToken()!=null){
            if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                While(parser.nextToken()!=null){
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                        COVID19CountrySummary covid19 = (COVID19CountrySummary)parser.readValueAs(COVID19CountrySummary.class);
                        if(string.isNotBlank(covid19.Country)){
                            COVID19Summary.add(covid19);
                        }
                    }
        	    }
     	   }
    	}
        if(COVID19Summary.size()>0){
            String countryName = 'World Total';
            integer NewConfirmedTotal = 0;
            integer TotalConfirmedTotal = 0;
            integer NewDeathsTotal = 0;
            integer TotalDeathsTotal = 0;
            integer NewRecoveredTotal = 0;
            integer TotalRecoveredTotal = 0;
            for(COVID19CountrySummary eachCountry : COVID19Summary){
                NewConfirmedTotal = NewConfirmedTotal + Integer.valueOf(eachCountry.NewConfirmed);
                TotalConfirmedTotal = TotalConfirmedTotal + Integer.valueOf(eachCountry.TotalConfirmed);
                NewDeathsTotal = NewDeathsTotal + Integer.valueOf(eachCountry.NewDeaths);
                TotalDeathsTotal = TotalDeathsTotal + Integer.valueOf(eachCountry.TotalDeaths);
                NewRecoveredTotal = NewRecoveredTotal + Integer.valueOf(eachCountry.NewRecovered);
                TotalRecoveredTotal = TotalRecoveredTotal + Integer.valueOf(eachCountry.TotalRecovered);
            }
            COVID19CountrySummary totalSummary = new COVID19CountrySummary();
			totalSummary.Country = countryName;
			totalSummary.CountrySlug = countryName;
            totalSummary.NewConfirmed = String.valueOf(NewConfirmedTotal);
            totalSummary.TotalConfirmed = String.valueOf(TotalConfirmedTotal);
            totalSummary.NewDeaths = String.valueOf(NewDeathsTotal);
            totalSummary.TotalDeaths = String.valueOf(TotalDeathsTotal);
            totalSummary.NewRecovered = String.valueOf(NewRecoveredTotal);
            totalSummary.TotalRecovered = String.valueOf(TotalRecoveredTotal);
            system.debug('*****total Summary' +totalSummary);
            COVID19Summary.add(totalSummary);
        } 
 		system.debug('*****COVID19Summary' +COVID19Summary);
        return COVID19Summary;
	}
    
    public class COVID19CountrySummary{
        @AuraEnabled
        public string Country;
        @AuraEnabled
        public string CountrySlug;
        @AuraEnabled
        public string NewConfirmed;
         @AuraEnabled
        public string TotalConfirmed;
         @AuraEnabled
        public string TotalDeaths;
         @AuraEnabled
        public string NewDeaths;
         @AuraEnabled
        public string NewRecovered;
         @AuraEnabled
        public string TotalRecovered;
    }
}