public with sharing class CovidDistrict {
    public CovidDistrict() {

    }
    @future(callout=true)
    public static void upsertDistrict(){
        HttpResponse httpResponse;
        List<JSON2ApexStateWiseJsonClass> json2ApexStateWiseJsonClassList;
        Map<String,Id> stateMap= new Map<String,Id>();
        List<District__c> districtList= new List<District__c>();
        String endPoint='https://api.covid19india.org/v2/state_district_wise.json';
        try {
            for(States__c stateObj : [Select Id, Name, Active__c, Confirmed__c, deaths__C, Last_Updated_Time__c,Recovered__c, State_Name__c from States__c]){
                stateMap.put(stateObj.State_Name__c, stateObj.Id);
            }
            Http http= new Http();
            HttpRequest httpRequest= new HttpRequest();
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setMethod('GET');
            httpRequest.setEndPoint(endPoint);
            httpRequest.setTimeout(1300);
            httpResponse= http.send(httpRequest);
           // System.debug('HttpResponse for getStateWiseSeriesAPI::::'+httpResponse);
            System.debug('getStateWiseSeriesAPI - HttpResponse.getBody::::'+httpResponse.getBody());
            if(httpResponse.getStatusCode() == 200){
                json2ApexStateWiseJsonClassList= JSON2ApexStateWiseJsonClass.parse(httpResponse.getBody());
                for(JSON2ApexStateWiseJsonClass obj: json2ApexStateWiseJsonClassList){
                   // System.debug('in 1:::::');
                    if(obj.state != null ){
                          // System.debug('in 2::::'+obj.state);
                        String states= obj.state;
                        for(JSON2ApexStateWiseJsonClass.DistrictData objData: obj.districtData){
                            District__c districtObj= new District__c();
                            //system.debug('3:::');
                            if(stateMap.get(states) !=null)
                            districtObj.States__c=stateMap.get(states);
                            //system.debug('4');
                            districtObj.Active__c= String.valueOf(objData.active);
                            districtObj.Recovered__c=String.valueOf(objData.recovered);
                            districtObj.Confirmed__c=String.valueOf(objData.confirmed);
                            districtObj.Deceased__c=String.valueOf(objData.deceased);
                            districtObj.District_Name__c=objData.district;
                            districtList.add(districtObj);
                        }
                    }
                }
            }
            if(districtList.size() > 0){
                upsert districtList;
            }
            System.debug('Size of DistrictList:::'+districtList.size());
        }catch(Exception e){
            System.debug('Exception in upsertDistrict:::::'+e.getLineNumber()+'~~ message:::'+e.getMessage());
        }

    }
}
