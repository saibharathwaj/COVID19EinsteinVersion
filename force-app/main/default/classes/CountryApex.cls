global class CountryApex implements Schedulable, Database.AllowsCallouts{
   
    global void execute(SchedulableContext sc){
        CovidApex.upsertCountry();
    }
}