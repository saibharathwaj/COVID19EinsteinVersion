public with sharing class CovidApex {
    public CovidApex() {

    }
    @future(callout=true)
    public static void upsertCountry(){
        
        HttpResponse httpResponse;
        JSON2ApexNationStateTestCounts json2ApexNationStateTestCountsList;
        Map<String,States__c> stateMap= new Map<String,States__C>();
        List<States__C> stateList= new List<States__c>();
        String endPoint='https://api.covid19india.org/data.json';
    try {
        for(States__c stateObj : [Select Id, Name, Active__c, Confirmed__c, deaths__C, Last_Updated_Time__c,Recovered__c, State_Name__c from States__c]){
            stateMap.put(stateObj.State_Name__c, stateObj);
        }
        System.debug('Map Details::::'+stateMap);
        Http http= new Http();
        HttpRequest httpRequest= new HttpRequest();
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setMethod('GET');
        httpRequest.setEndPoint(endPoint);
        httpRequest.setTimeout(1300);
        httpResponse= http.send(httpRequest);
        System.debug('HttpResponse for getNationalWideSeries::::'+httpResponse);
        System.debug('getNationalWideSeries - HttpResponse.getBody::::'+httpResponse.getBody());
        if(httpResponse.getStatusCode() == 200){
            json2ApexNationStateTestCountsList=JSON2ApexNationStateTestCounts.parse(httpResponse.getBody());
            for(JSON2ApexNationStateTestCounts.Statewise stateWiseObj :json2ApexNationStateTestCountsList.statewise){
                if(stateWiseObj.state != null && 
                    stateMap.get(stateWiseObj.state) != null && 
                    stateMap.get(stateWiseObj.state).State_Name__c !=null &&
                    stateMap.get(stateWiseObj.state).State_Name__c == stateWiseObj.state){
                    States__c statesObj= stateMap.get(stateWiseObj.state);
                    statesObj.Active__c=stateWiseObj.active;
                    statesObj.Confirmed__c=stateWiseObj.confirmed;
                    statesObj.deaths__C=stateWiseObj.deaths;
                    statesObj.Recovered__c=stateWiseObj.recovered;
                    statesobj.Last_Updated_Time__c=stateWiseObj.lastupdatedtime;
                    stateList.add(statesObj);
                }
            }
        }
        System.debug('Size of StateList::::'+stateList.size());
        if(stateList.size() > 0){
            upsert stateList;
        }

    }catch(Exception e){
        System.debug('Exception in CountryApex:::::'+e.getLineNumber()+'~~ message:::'+e.getMessage());
    }
    }

    
}